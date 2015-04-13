Shader "1. Basic/1.4 cg shadering in world space" {
	SubShader 
	{
		pass
		{
			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			struct vertexInput
			{
				float4 vertexPos : POSITION;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 position_in_world_space : TEXCOORD0;
			};

			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);

				// 从物体坐标转换到世界坐标
				//
				output.position_in_world_space = mul(_Object2World, input.vertexPos);

				return output;
			}

			// fragment shader 
			// 
			float4 frag(vertexOutput input) : COLOR 
			{
				// 计算到原点的距离(对于点来说，第4位永远是1)
				//
				float dist = distance(input.position_in_world_space, float4(0, 0, 0, 1.0));

				// 如果离原点距离超过5.0颜色为深灰色
				//
				if (dist < 5.0)
				{
					return float4( 0, 1.0, 0, 1.0);
				}
				else
				{
					return float4(0.3, 0.3, 0.3, 1.0);
				}
			}


			ENDCG
		}	
	} 
}
