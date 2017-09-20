// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/BasicLight3" {
	Properties{
		_diffuseColor("diffuseColor", Color) = (1, 1, 1, 1)
		_ambientColor("ambientColor", Color) = (1, 1, 1, 1)
		_specularColor("specularColor", Color) = (1, 1, 1, 1)
		_ambientStrength("ambientStrength", Range(0, 1)) = 0.1
		_gloss("gloss", Range(8, 200)) = 10
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
				float4 worldVertex:COLOR0;
			};

			v2f vert(a2v v) {
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.normal = UnityObjectToWorldNormal(v.normal);
				f.worldVertex = mul(v.vertex, unity_WorldToObject);
				return f;
			}

			fixed4 _diffuseColor;
			fixed4 _ambientColor;
			fixed _ambientStrength;
			fixed4 _specularColor;
			half _gloss;
			fixed4 frag(v2f f) : SV_Target {
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 _ambient = (_ambientColor * _ambientStrength).rgb;
				fixed3 deffuse = _LightColor0.rgb * max(dot(f.normal, lightDir), 0) * _diffuseColor;
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldVertex.xyz);
				
				fixed3 halfDir = normalize(viewDir + lightDir);
				fixed3 specular = pow(max(dot(f.normal, halfDir), 0), _gloss) * _specularColor.rbg;
				return fixed4((_ambient + deffuse + specular), 1);
			}
			ENDCG
		}
	}
	Fallback "Specular"
}