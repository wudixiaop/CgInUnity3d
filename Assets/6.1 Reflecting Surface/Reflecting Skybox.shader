Shader "6. Environment Mapping/6. Reflecting skybox" { 
	Properties {
		_Cube("Skybox", Cube) = "" {}
	}

    SubShader { 
		Pass { 
		
			CGPROGRAM 

			#pragma vertex vert 
			#pragma fragment frag

			samplerCUBE _Cube;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};
			
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float3 normalDir : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};
			
			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.normalDir = normalize(mul(float4(input.normal, 0.0), _Object2World));
				output.viewDir = mul(_Object2World, input.vertexPos).xyz - _WorldSpaceCameraPos;
				
				return output;
				
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				float3 reflectedDir = reflect(input.viewDir, normalize(input.normalDir));
				return texCUBE(_Cube, reflectedDir);
			}

			ENDCG 
		}
    }
	
	FallBack "Diffuse"
}