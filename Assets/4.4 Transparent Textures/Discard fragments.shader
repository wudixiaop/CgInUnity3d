Shader "4. Basic texturing/4.4 Discard Fragments" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha Cut off", float) = 0.5
	}
	SubShader {
		Pass {
			
			Cull off

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			sampler2D _MainTex;
			float _Cutoff;

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
				float4 textureColor =  tex2D(_MainTex, input.texcoord.xy);

				if (textureColor.a < _Cutoff)
				{
					discard;
				}

				return textureColor;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
