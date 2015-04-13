Shader "1. Basic/1.2 RGB Cube" {
	SubShader 
	{
		Pass 
		{
			CGPROGRAM

			// vertex和fragment是大小写敏感的
			//
			#pragma vertex vert 
			#pragma fragment frag 

			// 为多个输出定义一个结构类型
			//
			struct vertexOutput
			{
				float4 pos : SV_POSITION; // 转换后输出的定点位置
				float4 clr : TEXCOORD0;   // 定点颜色
			};
			
			//vertex shader 
			//
			vertexOutput vert(float4 vertexPos : POSITION)
			{
				vertexOutput output;
				
				output.pos = mul(UNITY_MATRIX_MVP, vertexPos);

				// 因为Cube的在坐标系上的数值是在-0.5到0.5之间（包含-0.5和0.5）,
				// 但是对于颜色数据，我们需要的值是0到1.0之间，所以下面给顶点数值都加上了0.5
				//
				output.clr = vertexPos + float4(0.5, 0.5, 0.5, 0.0);

				return output;
			}

			float4 frag(vertexOutput input) : COLOR 
			{
				// 返回颜色，input是从vertex shader传过来的
				return input.clr;


				// 灰度的效果
				//
				// float gray = (input.clr.x + input.clr.y + input.clr.z) / 3;
				// return float4(gray, gray, gray, 1);
			}


			ENDCG
			
		}
	} 
	FallBack "Diffuse"
}
