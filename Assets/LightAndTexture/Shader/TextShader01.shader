// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/TextShader01" {
	Properties {
		_color("Color", Color) = (1, 1, 1, 1)
	}

	SubShader{
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// 通过POSITION和SV_POSITION来声明需要的v是什么，以及返回的float4是什么
			// 这里POSITION是模型坐标，SV_POSITION是剪裁空间的坐标
			float4 vert(float4 v : POSITION) :SV_POSITION {
				return UnityObjectToClipPos(v);
			}
			fixed4 _color;
			fixed4 frag() : SV_Target {
				return _color;
			}
			ENDCG
		}
	}
	Fallback "VextexLit"
}