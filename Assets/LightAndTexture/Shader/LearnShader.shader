Shader "Custom/LearnShader" {
	Properties {
		_color("颜色", Color) = (1, 1, 1, 1)
		_vector("向量", Vector) = (0, 0, 0, 0)
		_int("整数", Int) = 1
		_float("浮点数", Float) = 1.1
		_range("范围", Range(0, 1)) = 0
		_texture("纹理", 2D) = "white"{}
		_cube("立方体纹理", Cube) = "white"{}
		_texture3D("3D纹理", 3D) = "white"{}
	}

		// SubShader用于适配不同的显卡
		SubShader {
		// 至少有一个Pass
			Pass {
			// 声明使用cg在此编写shader
			CGPROGRAM
			// float32 half16 fixed11 颜色通常使用fiexed
			float4 _color;
			half4 _vecter;
			int _int;
			float _float;
			float _range;
			sampler2D _texture;
			samplerCube _cube;
			sampler3D _texture3D;
			ENDCG
		}
	}

	// 当所有的SubShader都不支持时使用fallback
	Fallback "VertexLit"
}