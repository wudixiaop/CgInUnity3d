Shader "6. Environment Mapping/6.3 Skyboxes" { 
	Properties {
		_Cube ("Cube", Cube) = "white" {}
	}
    SubShader { 
		
		Tags { "Queue" = "Background" }

		Pass { 

			ZWrite off
			Cull off
			
			CGPROGRAM 
			#pragma vertex vert 
			#pragma fragment frag

			samplerCUBE _Cube;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float3 texcoord : TEXCOORD0;
			};
			
			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.texcoord = input.texcoord;
				
				return output;
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				return texCUBE(_Cube, input.texcoord);
			}

			ENDCG 
		}
    }
}