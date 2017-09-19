// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/BasicColor" {
	Properties{
		_objectColor("objectColor", Color) = (1, 1, 1, 1)
		_ambientColor("ambientColor", Color) = (1, 1, 1, 1)
		_specularColor("specularColor", Color) = (1, 1, 1, 1)
		_ambientStrength("ambientStrength", Range(0, 1)) = 0.1
		_specularStrength("specularStrength", Range(0, 1)) = 0.5
	}

	SubShader{
		Pass {
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			
			struct v2f {
				float4 position:SV_POSITION;
				float3 normal:NORMAL;
				float3 viewDir:COLOR0;
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(v.vertex, unity_WorldToObject).xyz);;
				f.normal = normalize(UnityObjectToWorldNormal(v.normal));
				return f;
			}

			fixed4 _objectColor;
			fixed4 _ambientColor;
			fixed _ambientStrength;
			fixed4 _specularColor;
			fixed _specularStrength;
			fixed4 frag(v2f f) : SV_Target {
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 _ambient = (_ambientColor * _ambientStrength).rgb;
				fixed3 deffuse = _LightColor0.rgb * max(dot(lightDir, f.normal), 0);
				
				
				float3 reflectDir = normalize(reflect(-lightDir, f.normal));
				fixed3 halfDir = normalize(f.viewDir + lightDir);
				float spec = pow(max(dot(f.normal, halfDir), 0), 16);
				fixed3 specular = _specularStrength * spec * _specularColor.rbg;
				return fixed4((_ambient + deffuse + specular) * _objectColor, 1);
			}
			ENDCG
		}
	}
	Fallback "Specular"
}