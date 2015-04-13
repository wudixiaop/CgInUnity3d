// 这个shader有两个pass, 第一个是裁剪正面，然后给背面填上红色；
// 第二个是裁剪背面，然后给证明填上绿色，所以结果能看到一个绿色外表
// ，内部红色的物体 
//
Shader "2. Transparent Surfaces/2.1 cutways with two passes" {
	SubShader {
		// 第一个Pass, 会在第二个pass前执行
		// 
		Pass 
		{
			Cull Front  

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
				float4 posInObjectCoords : TEXCOORD0;
			};
		
			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.posInObjectCoords = input.vertexPos;

				return output;
			}
			
			// fragment shader 
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				// 如果物体坐标系y值大于0则放弃这个fragment的计算.
				// 我们可以通过同样的方法来生成半球或者圆柱体等等
				//
				if( input.posInObjectCoords.y > 0.0)
				{
					discard;
				}

				return float4(1.0, 0.0, 0.0, 1.0);
			}

			ENDCG
		}

		// 第二个pass, 在第一个pass执行完后执行
		//
		Pass
		{
			Cull Back 

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
				float4 posInObjectCoords : TEXCOORD0;
			};

			//vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.posInObjectCoords = input.vertexPos;
				return output;
			}

			// fragment shader 
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				if(input.posInObjectCoords.y > 0.0)
				{
					discard;
				}

				return float4(0.0, 1.0, 0.0, 1.0);
			}

			ENDCG
			
		}
	} 
}
