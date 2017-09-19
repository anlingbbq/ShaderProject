// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Siki/09-Specular Fragment BlinnPhong"{
	Properties{
		_Diffuse("Diffuse Color",Color) = (1,1,1,1)
		_Specular("Specular Color",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8,200)) = 10

	}
		SubShader{
			Pass{
				Tags{ "LightMode" = "ForwardBase" }
				CGPROGRAM
	#include "Lighting.cginc" //取得第一个直射光的颜色 _LightColor0 第一个直射光的位置_WorldSpaceLightPos0 
		#pragma vertex vert
		#pragma fragment frag
				fixed4 _Diffuse;
				fixed4 _Specular;
				half _Gloss;
			
			//application to vertex
			struct a2v {
				float4 vertex:POSITION;//告诉unity把模型空间下的顶点坐标填充给vertex
				float3 normal:NORMAL;
			};

			struct v2f {
				float4 position:SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float4 worldVertex :TEXCOORD1;
			}; 
				
			v2f vert(a2v v) { 
				v2f f;
				f.position = mul(UNITY_MATRIX_MVP,v.vertex);
				//f.worldNormal = mul(v.normal, (float3x3) _World2Object);
				f.worldNormal = UnityObjectToWorldNormal(v.normal);
				f.worldVertex = mul(v.vertex, unity_WorldToObject);
				return f;
			} 

			fixed4 frag(v2f f) :SV_Target{

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

				fixed3 normalDir = normalize(f.worldNormal);

				//fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//对于每个顶点来说 光的位置就是光的方向 ，因为光是平行光
				fixed3 lightDir = normalize( WorldSpaceLightDir(f.worldVertex).xyz );
				
				fixed3 diffuse = _LightColor0.rgb * max(dot(normalDir, lightDir), 0) *_Diffuse.rgb;  //取得漫反射的颜色

				//fixed3 reflectDir = normalize(reflect(-lightDir, normalDir)); 

				//fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - f.worldVertex );
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(f.worldVertex));

				fixed3 halfDir = normalize(viewDir + lightDir);

				fixed3 specular = _LightColor0.rgb *  _Specular.rgb * pow(max(dot(normalDir, halfDir), 0), _Gloss);

				fixed3 tempColor = diffuse + ambient + specular;

				return fixed4(tempColor,1);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}