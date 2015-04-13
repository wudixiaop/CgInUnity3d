Shader "4. Basic texturing/4.5 Layers of Textures" {
	Properties {
		_MainTex ("NightTime Earth", 2D) = "white" {}
		_DecalTex ("DayTime Earth", 2D) = "White" {}
		_Color ("NightTime Color Filter", Color) = (1, 1, 1, 1)
	}

	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _DecalTex;
			float4 _Color;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
				float levelOfLighting : TEXCOORD1;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.texcoord = input.texcoord;
				output.levelOfLighting = max(0.0, dot(normalize(mul(float4(input.normal, 1.0), _World2Object).xyz), normalize(_WorldSpaceLightPos0.xyz)));

				return output;
			}

			float4 frag(vertexOutput input) : COLOR 
			{
				float4 dayTimeColor = tex2D(_DecalTex, input.texcoord.xy);
				float4 nightTimeColor = tex2D(_MainTex, input.texcoord.xy);

				return lerp(nightTimeColor, dayTimeColor, input.levelOfLighting);
			}

			ENDCG
		}
	} 

	// FallBack "Diffuse"
}
