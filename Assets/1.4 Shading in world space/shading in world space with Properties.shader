Shader "1. Basic/1.4 shading in world space with Properties" {
	Properties {
		_Point ("a point in world space", Vector) = (0.0, 0.0, 0.0, 1.0)
		_DistanceNear("threshold distance", Float) = 5.0
		_ColorNear("color near to point", Color) = (0.0, 0.0, 1.0, 1.0)
		_ColorFar("Color far from point", Color) = (0.0, 1.0, 0.0, 1.0)
	}

	SubShader {
		pass
		{
			CGPROGRAM 

			#pragma vertex vert 
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform float4 _Point;
			uniform float  _DistanceNear;
			uniform float4 _ColorNear;
			uniform float4 _ColorFar;

			struct vertexInput
			{
				float4 vertexPos : POSITION;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 position_in_world_position : TEXCOORD0;
			};
			
			// vertex shader 
			//
			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;

				output.pos = mul(UNITY_MATRIX_MVP, input.vertexPos);
				output.position_in_world_position = mul(_Object2World, input.vertexPos);

				return output;
			}
			
			// fragment shader 
			//
			float4 frag(vertexOutput input) : COLOR 
			{
				float dist = distance(input.position_in_world_position, _Point);
				
				if (dist < _DistanceNear)
				{
					return _ColorNear;
				}
				else
				{
					return _ColorFar;
				}
			}

			ENDCG
		}
		
	} 
}
