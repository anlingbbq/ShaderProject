// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TextShader02" {
	Properties {
		_color("Color", Color) = (1, 1, 1, 1)
	}

	SubShader{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			
			struct v2f {
				float4 position:SV_POSITION;
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				return f;
			}

			fixed4 _color;
			fixed4 frag() : SV_Target {
				return _color;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}