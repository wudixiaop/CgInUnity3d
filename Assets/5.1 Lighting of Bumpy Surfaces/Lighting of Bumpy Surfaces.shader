Shader "5. Textures in 3D/5.1 Lighting of Bumpy Surfaces" {
	Properties {
		_BumpMap("Normal map", 2D) = "bump" {}
		_Color ("Diffuse Material color", Color) = (1, 1, 1, 1)
		_SpecularColor ("Specular Material Color", Color) = (1, 1, 1, 1)
		_Shininess ("Shininess", Float) = 10
	}

	SubShader {
		pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex  vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float4 texcoord : TEXCOORD1;
				float3 tangentWorld : TEXCOORD2;
				float3 normalWorld : TEXCOORD3;
				float3 binormalWorld : TEXCOORD4;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.normalWorld = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);
				output.tangentWorld = normalize(mul(_Object2World, float4(input.tangent.xyz, 0.0)).xyz);
				
				// tangent.w 是Unity里面特有的，是由于Unity提供的法线和切线需要我么乘以tangent.w
				//
				output.binormalWorld = normalize(cross(output.normalWorld, output.tangentWorld) * input.tangent.w);

				output.texcoord = input.texcoord;
				output.posWorld = mul(_Object2World, input.vertexPos);

				return output;
			}


			float4 frag(vertexOutput input) : COLOR
			{
				float4 encodedNormal = tex2D(_BumpMap, _BumpMap_ST.xy * input.texcoord.xy + _BumpMap_ST.zw);
				
				// 反解码，只利用到了alpha通道（对应为x的值）和一个颜色(g通道，对应为y值)。读取的值范围为[0, 1], 
				// 要映射成标准向量的取值范围[-1, 1], 所以转换的关系为 2 * x - 1, x 属于 [0, 1]. 最后一个z值
				// 为 sqrt(1 - x^2 - y^2)，因为x, y, z满足 x^2 + y^2 + Z^2 = 1 
				//
				float3 localCoords = float3(2.0 * encodedNormal.a - 1.0, 2.0 * encodedNormal.g - 1.0, 0.0);
				localCoords.z = sqrt(1 - dot(localCoords, localCoords));
				
				float3x3 local2WorldTranspose = float3x3(input.tangentWorld, input.binormalWorld, input.normalWorld);

				float3 normalDirection = normalize(mul(localCoords, local2WorldTranspose));
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.posWorld.xyz);

				float3 lightDirection;
				float  attenuation;

				if( _WorldSpaceLightPos0.w == 0.0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color * max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;
				
				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _SpecularColor.rgb * _LightColor0.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				return float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}
	
	    pass
		{
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One
			CGPROGRAM

			#pragma vertex  vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float4 texcoord : TEXCOORD1;
				float3 tangentWorld : TEXCOORD2;
				float3 normalWorld : TEXCOORD3;
				float3 binormalWorld : TEXCOORD4;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.normalWorld = normalize(mul(float4(input.normal, 1.0), _World2Object));

				// tangent的w值不做贡献
				//
				output.tangentWorld = normalize(mul(_Object2World, float4(input.tangent.xyz, 0.0)).xyz);				

				// tangent.w 是Unity里面特有的，是由于Unity提供的法线和切线需要我么乘以tangent.w
				//
				output.binormalWorld = normalize(cross(output.normalWorld, output.tangentWorld) * input.tangent.w);

				output.texcoord = input.texcoord;
				output.posWorld = mul(_Object2World, input.vertexPos);

				return output;
			}


			float4 frag(vertexOutput input) : COLOR
			{
				float4 encodedNormal = tex2D(_BumpMap, _BumpMap_ST.xy * input.texcoord.xy + _BumpMap_ST.zw);
				
				// 反解码，只利用到了alpha通道（对应为x的值）和一个颜色(g通道，对应为y值)。读取的值范围为[0, 1], 
				// 要映射成标准向量的取值范围[-1, 1], 所以转换的关系为 2 * x - 1, x 属于 [0, 1]. 最后一个z值
				// 为 sqrt(1 - x^2 - y^2)，因为x, y, z满足 x^2 + y^2 + Z^2 = 1 
				//
				float3 localCoords = float3(2.0 * encodedNormal.a - 1.0, 2.0 * encodedNormal.g - 1.0, 0.0);
				localCoords.z = sqrt(1 - dot(localCoords, localCoords));
				
				float3x3 local2WorldTranspose = float3x3(input.tangentWorld, input.binormalWorld, input.normalWorld);

				float3 normalDirection = normalize(mul(localCoords, local2WorldTranspose));
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.posWorld.xyz);

				float3 lightDirection;
				float  attenuation;

				if( _WorldSpaceLightPos0.w == 0.0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color * max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;
				
				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _SpecularColor.rgb * _LightColor0.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				return float4(diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}
	
	} 
	FallBack "Diffuse"
}
