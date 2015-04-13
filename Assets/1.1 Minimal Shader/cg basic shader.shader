// defines the name of the shader 
// (定义Shader的名字)
Shader "1. Basic/1.1 Cg basic shader" { 
	// Unity chooses the subshader that fits the GPU best
	// (Unity会选择最适合GPU的SubShader,如果在有多个SubShader的情况下。)
    SubShader { 
		// some shaders require multiple passes
		// (有些shader会需求多个Pass)
		Pass { 
			// here begins the part in Unity's Cg
			//  (Unity中Cg程序的开始标志) 
			CGPROGRAM 

			// this specifies the vert function as the vertex shader 
			// (指定函数vert为Vertex shader)
			#pragma vertex vert 

			// this specifies the frag function as the fragment shader
			// (指定函数frag为fragment shader)
			#pragma fragment frag

			// vertex shader 
			float4 vert(float4 vertexPos : POSITION) : SV_POSITION 
			{
			    // this line transforms the vertex input parameter 
			    // vertexPos with the built-in matrix UNITY_MATRIX_MVP
			    // and returns it as a nameless vertex output parameter 
				// (借助Unity内置矩阵UNITY_MATRIX_MVP来转换输入参数vertexPos,
				// 返回一个名字无关的顶点输出参数)
				return mul(UNITY_MATRIX_MVP, vertexPos);
			}

			// fragment shader
			float4 frag(void) : COLOR 
			{
			    // this fragment shader returns a nameless fragment
			    // output parameter (with semantic COLOR) that is set to
			    // opaque red (red = 1, green = 0, blue = 0, alpha = 1)
				// (这个fragment shader返回了一个带有COLOR语义的fragment输出参数,
				// 参数的值设置为了不带透明度的红色。Red = 0, green = 0, blue = 0, alpha = 1)
				return float4(1.0, 0.0, 0.0, 1.0); 
			}

			// here ends the part in Cg 
			//   (Unity中Cg程序的结束标志)
			ENDCG 
		}
    }
}