Shader "5. Textures in 3D/5.3 Cookies" {
	Properties {
		_Color ("Diffuse Material Color", Color) = (1, 1, 1, 1)
		_SpecularColor ("Specular Material Color", Color) = (1, 1, 1, 1)
		_Shiniess ("Shininess", Float) = 10
	}

	SubShader {

		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float3 normalDir : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.posWorld = mul(_Object2World, input.vertexPos);
				output.normalDir = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR 
			{
				// 计算方向
				//
				float3 normalDirection = normalize(input.normalDir);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.posWorld.xyz);
				float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);

				// 计算光
				//
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;

				float3 diffuseReflection = _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); 

				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				return float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
			}

			ENDCG

		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One

			CGPROGRAM

			// Unity根据这个标志来允许为不同的light创建不同Shader
			//
			#pragma multi_compile_lightpass

			#pragma vertex vert 
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;

			#if defined(DIRECTIONAL_COOKIE) || defined(SPOT)
				sampler2D _LightTexture0;
			#elif defined(POINT_COOKIE)
				samplerCUBE _LightTexture0;
			#endif

			float4x4 _LightMatrix0;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float4 posLight : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.posWorld = mul(_Object2World, input.vertexPos);
				output.normalDir = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);
				output.posLight = mul(_LightMatrix0, output.posWorld);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR 
			{
				float3 normalDirection = normalize(input.normalDir);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.posWorld.xyz);

				float3 lightDirection;
				
				// 默认为没有衰减
				//
				float attenuation = 1.0;

				#if defined (DIRECTIONAL) || defined (DIRECTIONAL_COOKIE)
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				#elif defined(POINT_NOATT)
					lightDirection = normalize(_WorldSpaceLightPos0.xyz - input.posWorld.xyz);
				#elif defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
					attenuation = 1.0 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				#endif

				// 计算光
				//
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection)); 

				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				// 计算Cookie衰减
				//
				float cookieAttenuation = 1.0;

				#if defined(DIRECTIONAL_COOKIE)
					cookieAttenuation = tex2D(_LightTexture0, input.posLight.xy).a;
				#elif defined(POINT_COOKIE)
					cookieAttenuation = texCUBE(_LightTexure0, input.posLight.xyz).a;
				#elif defined(SPOT)
					cookieAttenuation = tex2D(_LightTexure0, input.posLight.xy / input.posLight.w + float2(0.5, 0.5)).a;
				#endif

				return float4(cookieAttenuation * (diffuseReflection + specularReflection), 1.0);
			}

			ENDCG
		}
	} 
}
