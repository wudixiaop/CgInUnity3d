Shader "1. Basic/1.3 Debugging of Shader with Built-in Structs" {
	SubShader {
		pass
		{
			CGPROGRAM

			// 引用自带的包"UnityCG.cginc", 这样就可以用它定义的一些结构或者方法了
			//
			#include "UnityCG.cginc"
			#pragma vertex vert 
			#pragma fragment frag

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 col : TEXCOORD0;
			};

			//vertex shader 
			//
			vertexOutput vert(appdata_base input) // 输入参数类型可以是appdata_tan, appdata_full
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertex);
				//output.col = input.texcoord;

				// 如果是在sphere上会变成黑色
				//
				output.col = float4(cross(input.normal, input.vertex.xyz), 1.0);
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
