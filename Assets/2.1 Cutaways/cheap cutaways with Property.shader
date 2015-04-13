Shader "2. Transparent Surfaces/2.1 Cheap cutaways with Property" {
	Properties 
	{
		_YThreshold ("Y threshold", float) = 0.0
	}

	SubShader {
		Pass 
		{
			// 关闭三角形的裁剪，可以用的选项有：
			//   Cull Front : 只裁剪前面
			//   Cull Back  : 只裁剪后面
			//   Cull Off   : 关闭裁剪
			//
			Cull Off

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			float _YThreshold;

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
				if( input.posInObjectCoords.y > _YThreshold)
				{
					discard;
				}

				return float4(0.0, 0.0, 1.0, 1.0);
			}

			ENDCG
		}
	} 
}
