Shader "4. Basic texturing/4.3 Golssy Textures" {
	Properties {
		_MainTex ("MainTex", 2D) = "White" {}
		_Color ("Material Diffuse Color", color) = (1, 1, 1, 1)
		_SpecularColor ("Material Specular Color", Color) = (1, 1, 1, 1)
		_Shininess ("Material Shininess", float) = 10
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
				float3 normalDirection : TEXCOORD2;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.worldPos = mul(_Object2World, input.vertexPos);
				output.normalDirection = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);
				output.texcoord = input.texcoord;

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				float4 textureColor = tex2D(_MainTex, input.texcoord.xy);

				// 法线方向，再次标准化是因为从vertex shader到fragment shader会经过插值,
				// 而插值后的数值可能不是标准化的。
				//
				float3 normalDirection = normalize(input.normalDirection);

				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.worldPos.xyz);

				// 得到衰减度和光线方向
				//
				float3 lightDirection;
				float  attenuation;

				if (_WorldSpaceLightPos0.w == 0.0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.worldPos;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				// 得到环境光和漫反射光
				//
				float3 ambientLighting = textureColor.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
				float3 diffuseReflection = textureColor.rgb * attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

				// 得到高光
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = (1 - textureColor.a) * attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininess);
				}

				return float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One

			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
				float3 normalDirection : TEXCOORD2;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.worldPos = mul(_Object2World, input.vertexPos);
				output.normalDirection = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);
				output.texcoord = input.texcoord;

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				float4 textureColor = tex2D(_MainTex, input.texcoord.xy);

				// 法线方向，再次标准化是因为从vertex shader到fragment shader会经过插值,
				// 而插值后的数值可能不是标准化的。
				//
				float3 normalDirection = normalize(input.normalDirection);

				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - input.worldPos.xyz);

				// 得到衰减度和光线方向
				//
				float3 lightDirection;
				float  attenuation;

				if (_WorldSpaceLightPos0.w == 0.0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - input.worldPos;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				// 得到环境光和漫反射光
				//
				float3 diffuseReflection = textureColor.rgb * attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

				// 得到高光
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = (1- textureColor.a) * attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininess);
				}

				return float4(diffuseReflection + specularReflection, 1.0);
			}

			ENDCG	
		}

	} 
}
