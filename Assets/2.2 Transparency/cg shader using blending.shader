Shader "2. Transparent Surfaces/2.2 cg shader using blending" {
	SubShader {
		// 在所有不透明物体之后绘制，这里必须指定顺序
		//
		Tags { "Queue" = "Transparent" }

		Pass
		{
			// 为了不阻挡其他物体，不写入depth buffer中
			//
			ZWrite off

			// 使用alpha混合
			//
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			// 记住下面两句声明一定要放到CGPROGRAM...ENDCG语句段内
			//
			#pragma vertex vert 
			#pragma fragment frag

			// vertex shader
			//
			float4 vert(float4 vertexPos : POSITION) : SV_POSITION
			{
				return mul(UNITY_MATRIX_MVP, vertexPos);
			}

			// fragement shader 
			// 函数并没有输入参数
			//
			float4 frag(void) : COLOR 
			{
				// 第四位是aplha值比较重要。结果返回半透明的绿色。
				//
				return float4(0.0, 1.0, 0.0, 0.3);
			}

			ENDCG
		}
	} 
}
