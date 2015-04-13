Shader "4. Basic texturing/4.2 Lighting Textured Surface" {
	Properties {
		_MainTex ("Main Texture", 2D) = "White" {}
		_Color ("Diffuse Material Color", color) = (1, 1, 1, 1)
		_SpecularColor ("Specular Material Color", color) = (1, 1, 1, 1)
		_Shininess ("Shininess", Float) = 10
	}

	SubShader {
		Pass {
			Tags  { "LightMode" = "ForwardBase" }
			
			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			uniform float4 _Color;
			uniform float4 _SpecularColor;   
			uniform float  _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float3 diffuseColor : TEXCOORD1;
				float3 specularColor : TEXCOORD2;
			};


			//vertex shader 
			//
			vertexOutput vert(vertexInput input) 
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);	
				output.tex = input.texcoord;

				// 物体表面的法线方向
				//
				float3 normalDirection = normalize(mul(float4(input.normal, 1.0).xyz, _World2Object).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(_Object2World, input.vertexPos).xyz);

				float3 lightDirection;
				float3 attenuation;

				if ( _WorldSpaceLightPos0.w == 0)
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
				
				// Unity内置的环境光NITY_LIGHTMODE_AMBIENT
				//
				float3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.rgb * _Color.rgb;


				// 计算漫反射
				//		DiffuseReflection = attenuation * light * color * max(0, NdotL)
				//
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0, dot(normalDirection, lightDirection) );

				output.diffuseColor = ambientLighting + diffuseReflection;

				// 计算高亮. 高亮的大小是视角方向和入射光的反射光线夹角有关。夹角越小，高亮范围越大；反之则越小。
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					// 物体法线方向和入射光线的方向夹角大于90度，顶点在反面，没有反射光
					//
					specularReflection = (0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				output.specularColor = specularReflection;

				return output;
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR
			{
				return float4(input.specularColor + input.diffuseColor * tex2D(_MainTex, input.tex.xy), 1.0);
			}
			
			ENDCG
		}
		
		Pass {
			Tags  { "LightMode" = "ForwardAdd" }
			Blend One One

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			uniform float4 _Color;
			uniform float4 _SpecularColor;   
			uniform float  _Shininess;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float3 diffuseColor : TEXCOORD1;
				float3 specularColor : TEXCOORD2;
			};


			//vertex shader 
			//
			vertexOutput vert(vertexInput input) 
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);	
				output.tex = input.texcoord;

				// 物体表面的法线方向
				//
				float3 normalDirection = normalize(mul(float4(input.normal, 1.0).xyz, _World2Object).xyz);
				float3 viewDirection = normalize(_WorldSpaceCameraPos - mul(_Object2World, input.vertexPos).xyz);

				float3 lightDirection;
				float3 attenuation;

				if ( _WorldSpaceLightPos0.w == 0)
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
				
				// 计算漫反射
				//		DiffuseReflection = attenuation * light * color * max(0, NdotL)
				//
				float3 diffuseReflection = attenuation * _LightColor0.rgb * _Color.rgb * max(0, dot(normalDirection, lightDirection) );

				output.diffuseColor = diffuseReflection;

				// 计算高亮. 高亮的大小是视角方向和入射光的反射光线夹角有关。夹角越小，高亮范围越大；反之则越小。
				//
				float3 specularReflection;

				if(dot(normalDirection, lightDirection) < 0.0)
				{
					// 物体法线方向和入射光线的方向夹角大于90度，顶点在反面，没有反射光
					//
					specularReflection = (0.0, 0.0, 0.0);
				}
				else
				{
					specularReflection = attenuation * _LightColor0.rgb * _SpecularColor.rgb * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess);
				}

				output.specularColor = specularReflection;

				return output;
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR
			{
				return float4(input.specularColor + input.diffuseColor * tex2D(_MainTex, input.tex.xy), 1.0);
			}
			
			ENDCG
		}

	} 
}
