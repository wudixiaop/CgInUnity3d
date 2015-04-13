Shader "3. Basic lighting/3.3 Two sides surfaces" {
	Properties {
		_Color ("Front Material Diffuse Color", color) = (1, 1, 1, 1)
		_SpecularColor ("Front Material Speular Color", Color) = (1, 1, 1, 1)
		_Shininess ("Front Material Shininess", Float) = 10
		_BackColor ("Back Material Diffuse Color", Color) = (1, 1, 1, 1)
		_BackSpecularColor ("Back Material Specular Color", Color) = (1, 1, 1, 1)
		_BackShininess ("Back Material Shininess", Float) = 10
	}

	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }	
			Cull Back // 裁剪背部

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
			float  _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);

				float3 normalDirection = normalize(mul(float4(input.normal, 0.0).xyz, _World2Object).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, input.vertexPos).xyz);

				float3 lightDirection;
				float attenuation;

				if(_WorldSpaceLightPos0.w == 0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(_Object2World, input.vertexPos).xyz;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0, 0, 0);
				}
				else
				{
					specularReflection = attenuation * _SpecularColor.rgb * _LightColor0.rgb * pow( max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				output.col = float4(ambientLighting + diffuseReflection + specularReflection, 1.0);

				return output;

			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;				
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }	
			Blend One One
			Cull Back // 裁剪背部

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
			float  _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);

				float3 normalDirection = normalize(mul(float4(input.normal, 0.0).xyz, _World2Object).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, input.vertexPos).xyz);

				float3 lightDirection;
				float attenuation;

				if(_WorldSpaceLightPos0.w == 0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(_Object2World, input.vertexPos).xyz;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0, 0, 0);
				}
				else
				{
					specularReflection = attenuation * _SpecularColor.rgb * _LightColor0.rgb * pow( max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				output.col = float4(diffuseReflection + specularReflection, 1.0);

				return output;

			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;				
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardBase" }	
			Cull Front// 裁剪前面

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
			float  _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);

				float3 normalDirection = normalize(mul(float4(input.normal, 0.0).xyz, _World2Object).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, input.vertexPos).xyz);

				float3 lightDirection;
				float attenuation;

				if(_WorldSpaceLightPos0.w == 0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(_Object2World, input.vertexPos).xyz;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _BackColor.rgb;
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _BackColor.rgb * max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0, 0, 0);
				}
				else
				{
					specularReflection = attenuation * _BackSpecularColor.rgb * _LightColor0.rgb * pow( max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _BackShininess);
				}

				output.col = float4(ambientLighting + diffuseReflection + specularReflection, 1.0);

				return output;

			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;				
			}

			ENDCG
		}

		Pass {
			Tags { "LightMode" = "ForwardAdd" }	
			Blend One One
			Cull Front// 裁剪前面

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
			float  _BackShininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);

				float3 normalDirection = normalize(mul(float4(input.normal, 0.0).xyz, _World2Object).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, input.vertexPos).xyz);

				float3 lightDirection;
				float attenuation;

				if(_WorldSpaceLightPos0.w == 0)
				{
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				}
				else
				{
					float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - mul(_Object2World, input.vertexPos).xyz;
					attenuation = 1 / length(vertexToLightSource);
					lightDirection = normalize(vertexToLightSource);
				}

				float3 diffuseReflection = attenuation * _LightColor0.rgb * _BackColor.rgb * max(0.0, dot(normalDirection, lightDirection));

				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					specularReflection = float3(0, 0, 0);
				}
				else
				{
					specularReflection = attenuation * _BackSpecularColor.rgb * _LightColor0.rgb * pow( max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _BackShininess);
				}

				output.col = float4(diffuseReflection + specularReflection, 1.0);

				return output;

			}

			float4 frag(vertexOutput input) : COLOR
			{
				return input.col;				
			}

			ENDCG
		}

	}
}
