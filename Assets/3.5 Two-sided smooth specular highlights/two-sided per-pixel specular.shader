Shader "3. Basic lighting/3.5 Two-sided per-pixel specular" {
	Properties {
		_Color ("Material Diffuse Color", color) = (1, 1, 1, 1)
		_SpecularColor ("Material Specular Color", Color) = (1, 1, 1, 1)
		_Shininess ("Material Shininess", float) = 10
		_BackColor ("Back Material Diffuse Color", Color) = (1, 1, 1, 1)
		_BackSpecularColor("Back Material Specular Color", Color) = (1, 1, 1, 1)
		_BackShiness("Back Material Shininess", float) = 10
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			Cull Back
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;
			float4 _BackColor;
			float4 _BackSpecularColor;
			float _BackShininess;;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
				float3 normalDirection : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.worldPos = mul(_Object2World, input.vertexPos);
				output.normalDirection = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
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
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

				// 得到高光
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininess);
				}

				return float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One
			Cull Back
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;
			float4 _BackColor;
			float4 _BackSpecularColor;
			float _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
				float3 normalDirection : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.worldPos = mul(_Object2World, input.vertexPos);
				output.normalDirection = normalize(mul(float4(input.normal, 1.0), _World2Object).xyz);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
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

				// 得到反射光(这个Pass不需要环境光)
				//
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

				// 得到高光
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _Shininess);
				}

				return float4(diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardBase" }
			Cull Front
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;
			float4 _BackColor;
			float4 _BackSpecularColor;
			float _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
				float3 normalDirection : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.worldPos = mul(_Object2World, input.vertexPos);
				output.normalDirection = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
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
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _BackColor.rgb;
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _BackColor.rgb * max(0.0, dot(normalDirection, lightDirection));

				// 得到高光
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _BackSpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _BackShininess);
				}

				return float4(ambientLighting + diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }
			Blend One One
			Cull Front
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			float4 _Color;
			float4 _SpecularColor;
			float _Shininess;
			float4 _BackColor;
			float4 _BackSpecularColor;
			float _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 worldPos : TEXCOORD0;
				float3 normalDirection : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.worldPos = mul(_Object2World, input.vertexPos);
				output.normalDirection = normalize(mul(float4(input.normal, 1.0), _World2Object).xyz);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
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

				// 得到反射光(这个Pass不需要环境光)
				//
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _BackColor.rgb * max(0.0, dot(normalDirection, lightDirection));

				// 得到高光
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _BackSpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection),viewDirection)), _BackShininess);
				}

				return float4(diffuseReflection + specularReflection, 1.0);
			}

			ENDCG
		}

	} 
}
