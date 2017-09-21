Shader "Custom/NormalMap"{
	Properties{
		_color("Color", Color) = (1, 1, 1, 1)
		_mainTex("MainTexture", 2D) = "white"{}
		_normalMap("NormalMap", 2D) = "bump"{}
	}
	SubShader{
		Pass{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
#include "Lighting.cginc"
#pragma vertex vert
#pragma fragment frag
			fixed4 _color;
			sampler2D _mainTex;
			float4 _mainTex_ST;
			sampler2D _normalMap;
			float4 _normalMap_ST;
			
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 tangent:TANGENT;
				float4 texcoord:TEXCOORD0;
			};

			struct v2f {
				float4 svPos:SV_POSITION;
				float3 lightDir:TEXCOORD0;
				float4 worldVertex:TEXCOORD1;
				// x,y保存纹理坐标 z,w保存法线的纹理坐标
				float4 uv:TEXCOORD2;
			}; 
				
			v2f vert(a2v v) 
			{ 
				v2f f;
				f.svPos = UnityObjectToClipPos(v.vertex);
				f.worldVertex = mul(v.vertex, unity_WorldToObject);
				f.uv.xy = v.texcoord.x * _mainTex_ST.xy + _mainTex_ST.zw;
				f.uv.wz = v.texcoord.x * _normalMap_ST.xy + _normalMap_ST.zw;

				TANGENT_SPACE_ROTATION;
				f.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));

				return f;
			} 

			fixed4 frag(v2f f) :SV_Target
			{
				fixed4 normalColor = tex2D(_mainTex, f.uv.wz);
				fixed3 tangentNormal = UnpackNormal(normalColor);
				fixed3 lightDir = normalize(WorldSpaceLightDir(f.worldVertex));
				fixed3 texColor = tex2D(_mainTex, f.uv.xy) * _color.rgb;
				fixed3 diffuse = _LightColor0.rgb * texColor * max(dot(tangentNormal, lightDir), 0);


				fixed3 tempColor = diffuse + texColor;
				return fixed4(tempColor, 1);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}