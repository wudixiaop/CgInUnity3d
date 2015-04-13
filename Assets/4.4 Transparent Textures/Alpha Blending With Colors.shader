Shader "4. Basic texturing/4.4 Alpha Blending With Colors" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue" = "Transparent" }

		Pass {
			Cull Front 
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			sampler2D _MainTex;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos); 
				output.texcoord = input.texcoord;

				return output;
			}

			float4 frag(vertexOutput input) : Color 
			{
				float4 c = tex2D(_MainTex, input.texcoord.xy);
				if (c.a > 0.5)
				{
					c = float4(0, 0, 0.2, 1.0);
				}
				else
				{
					c = float4(0, 0, 1.0, 0.3);
				}

				return c;
			}

			ENDCG
		}

		Pass {
			Cull Back 
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			sampler2D _MainTex;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos); 
				output.texcoord = input.texcoord;

				return output;
			}

			float4 frag(vertexOutput input) : Color 
			{
				float4 c = tex2D(_MainTex, input.texcoord.xy);
				if (c.a > 0.5)
				{
					c = float4(0, 0, 0.2, 1.0);
				}
				else
				{
					c = float4(0, 0, 1.0, 0.3);
				}

				return c;
			}

			ENDCG
		}

	} 
	FallBack "Diffuse"
}
