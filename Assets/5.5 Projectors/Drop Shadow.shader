Shader "5. Textures in 3D/5.5 Projectors for drop shadows" { 
	Properties {
		_ShadowTex ( "Projector Image", 2D ) = "White" {}
	}

    SubShader { 
		Pass { 
			
			Blend Zero OneMinusSrcAlpha
			ZWrite Off
			Offset -1, -1 //避免Z fighting
		
			CGPROGRAM 

			#pragma vertex vert 
			#pragma fragment frag

			sampler2D _ShadowTex;
			float4x4 _Projector;

			struct vertexInput {
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};
			
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posProj : TEXCOORD0;
			};
			
			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.posProj = mul(_Projector, input.vertexPos);
				
				return output;
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				// posProj的w大于0表示是在Projector得正面，如果不这样判断的话
				// Projector会正面和后面都投射
				//
				if ( input.posProj.w > 0.0)
				{
					return tex2Dproj(_ShadowTex, input.posProj);
					//return tex2D(_ShadowTex, input.posProj.xy / input.posProj.w);
				}
				else
				{
					return float4(0, 0, 0, 0);
				}
			}

			ENDCG 
		}
    }
}