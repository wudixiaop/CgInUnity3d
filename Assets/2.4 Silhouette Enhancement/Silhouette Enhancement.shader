Shader "2. Transparent Surfaces/2.4 Silhouette Enhancement" {
	Properties
	{
		_Color ("Color", Color) = (1, 1, 1, 0.5)
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }

		Pass
		{
			ZWrite Off 

			// 标准的Alpha混合
			//
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float4 _Color;

			struct vertexInput
			{
				float4 vertexPos : POSITION;
				float3 normal : NORMAL; 
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float3 normal : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.normal = normalize(mul(float4(input.normal, 0), _Object2World).xyz);
				output.viewDir = normalize(_WorldSpaceCameraPos - mul(_Object2World, input.vertexPos).xyz);

				return output;
			}

			// fragment shader
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				float3 normalDIR = input.normal;
				float3 viewDIR = input.viewDir;

				float newOpacity = min(1.0, _Color.a / abs(dot(viewDIR, normalDIR)));

				return float4(_Color.rgb, newOpacity);
			}

			ENDCG

		}
	}
}
