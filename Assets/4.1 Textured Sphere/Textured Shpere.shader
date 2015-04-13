Shader "4. Basic texturing/4.1 Textured Shpere" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader {
		Pass {
			CGPROGRAM
			
			#pragma vertex vert 
			#pragma fragment frag

			sampler2D _MainTex;

			// Unity为每个纹理都提供一个
			//
			float4 _MainTex_ST;

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

				// 纹理坐标，即UV
				//
				output.texcoord = input.texcoord;

				return output;
			}

			float4 frag(vertexOutput input) : COLOR 
			{
				return tex2D(_MainTex, _MainTex_ST.xy * input.texcoord.xy + _MainTex_ST.zw);
			}

			ENDCG
		}
	} 

	FallBack "Diffuse"
}
