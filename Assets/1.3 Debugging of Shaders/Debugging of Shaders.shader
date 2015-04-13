Shader "1. Basic/1.3 Debugging of Shaders" {
	SubShader
    {
		pass
		{
			CGPROGRAM
			
			#pragma vertex vert 
			#pragma fragment frag

			// vertex shader 输入参数的定义结构
			//
			struct vertexInput 
			{
				float4 vertexPosition : POSITION; // 顶点位置，通过POSITION语义来定义
				float4 tangent : TANGENT;		// 切线，通过TANGENT语义来定义
				float4 normal : NORMAL;			// 法线， 通过NORMAL语义来定义
				float4 texcoord : TEXCOORD0;		// 第一套UV坐标，通过TEXCOORD0语义来定义
				float4 texcoord1 : TEXCOORD1;	// 第二套UV坐标，通过TEXCOORD1语义来定义
				float4 color : COLOR;			// 颜色，通过COLOR语义来定义
			};


			// vertex shader 输出参数的定义结构
			// 
			struct vertexOutput 
			{
				float4 pos : SV_POSITION;
				float4 col : TEXCOORD0;
			};
			
			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPosition);
				output.col = input.texcoord;  

				
				// 其他可以输出的选项

				//output.col = input.texcoord1;
				//output.col = input.color;
				//output.col = input.normal;
				//output.col = input.tangent;

				return output;
			}

			// fragment shader 
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				return input.col;
			}

			ENDCG
		}
	}
}
