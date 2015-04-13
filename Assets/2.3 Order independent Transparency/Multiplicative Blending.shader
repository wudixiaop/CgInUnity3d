Shader "2. Transparent Surfaces/2.3 Multiplicative blending" {
	SubShader 
	{
		Tags { "Queue" = "Transparent" }

		Pass
		{
			Cull Off
			ZWrite Off 

			// 乘法混合
			Blend Zero SrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag 

			float4 vert(float4 vertexPos : POSITION) : SV_POSITION 
			{
				return mul(UNITY_MATRIX_MVP, vertexPos);
			}

			float4 frag(void) : COLOR 
			{
				return float4(1.0, 0.0, 0.0, 0.3);
			}

			ENDCG
		}

	}
}
