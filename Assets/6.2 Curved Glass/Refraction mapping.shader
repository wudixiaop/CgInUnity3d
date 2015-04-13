Shader "6. Environment Mapping/6.2 Refract mapping" { 
	Properties {
		_Cube ("Refract mapping", Cube) = "" {}
		_Refractive ("Refractive", Range(1.0, 3.0)) = 1.5
	}

    SubShader { 
		Pass { 
		
			CGPROGRAM 

			#pragma vertex vert 
			#pragma fragment frag
			#include "UnityCG.cginc"

			samplerCUBE _Cube;
			float _Refractive;

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
				output.viewDir = mul(_Object2World, input.vertexPos).xyz - _WorldSpaceCameraPos;
				output.normalDir = normalize(mul(float4(input.normal, 0.0), _World2Object).xyz);
				
				return output;
				
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				float3 refractedDir = refract(normalize(input.viewDir), normalize(input.normalDir), 1.0 / _Refractive);
				return texCUBE(_Cube, refractedDir);
			}

			ENDCG 
		}
    }
}