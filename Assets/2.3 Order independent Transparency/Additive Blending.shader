Shader "2. Transparent Surfaces/2.3 Addivtive" {
	SubShader 
	{
		Tags { "Queue" = "Transparent" }

		Pass
		{
			Cull Off
			ZWrite Off 

			// 加法混合
			//  float4 result = SrcAlpha * SrcColor + One * DstColor
			//
			Blend SrcAlpha One

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag 

			float4 vert(float4 vertexPos : POSITION) : SV_POSITION 
			{
				return mul(UNITY_MATRIX_MVP, vertexPos);
			}

			float4 frag(void) : COLOR 
			{
				return float4(0.0, 0.0, 1.0, 0.5);
			}

			ENDCG
		}

	}
}
