Shader "3. Basic lighting/3.1 per-vertex diffuse reflection" {
	Properties {
		_DiffuseColor("Diffuse color", color) = (1, 1, 1, 1)
	}

	SubShader 
	{
		// ForwardBase只能使用一个光源，当有多个光源的时候, Unity会根据给光源
		// 配置的优先级(Render Mode)来决定使用哪个，如果优先级一样，则会只有更
		// 先生效的光源起作用 
		// 如果要多个光源选项要改为ForwardAdd
		Tags { "LightMode" = "ForwardBase" }
		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert 
			#pragma fragment frag

			// _World2Object来自UnityCG.cginc文件
			//
			#include "UnityCG.cginc"

			// _LightColor0和_WorldSpaceLightPos0来自Lighting.cginc文件
			//
			#include "Lighting.cginc"

			uniform float4 _DiffuseColor;

			struct vertexInput
			{
				float4 vertexPos : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 col : COLOR;
			};
			
			// vertex shader
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);

				// 漫反射公式
				//   I = LightColor * DiffuseColor * max(0, dot(Normal, LightDIR))
				//
				float3 normalDir = normalize(mul(float4(input.normal, 0), _World2Object).xyz);

				// 光的方向是基于原点的，所以位置标准化之后就是方向
				//
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = _LightColor0.rgb * _DiffuseColor.rgb * max(0.0, dot(normalDir, lightDir));

				output.col = float4(diffuseReflection, 1.0);

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
	// 开发的时候建议把FallBack注视掉
	FallBack "Diffuse"
}
