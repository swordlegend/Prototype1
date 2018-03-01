﻿Shader "Cg  shader for billboards" {
	Properties{
		_MainTex("Texture Image", 2D) = "white" {}
	_ScaleX("Scale X", Float) = 1.0
		_ScaleY("Scale Y", Float) = 1.0
	}
		SubShader{
		Tags{ 
		"Queue" = "Transparent"
		"SortingLayer" = "Resources_Sprites"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
		"CanUseSpriteAtlas" = "True"
		"DisableBatching" = "True" 
	}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha


		Pass{
		CGPROGRAM

#pragma vertex vert  
#pragma fragment frag
#pragma target 2.0
#pragma multi_compile _ PIXELSNAP_ON
#pragma multi_compile _ ETC1_EXTERNAL_ALPHA

		// User-specified uniforms            
		uniform sampler2D _MainTex;
	uniform float _ScaleX;
	uniform float _ScaleY;

	struct vertexInput {
		float4 vertex : POSITION;
		float4 tex : TEXCOORD0;
	};
	struct vertexOutput {
		float4 pos : SV_POSITION;
		float4 tex : TEXCOORD0;


		//float4 projPos : TEXCOORD4;
	};

	vertexOutput vert(vertexInput input)
	{
		vertexOutput output;

		output.pos = mul(UNITY_MATRIX_P,
			mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0))
			+ float4(input.vertex.x, input.vertex.y, 0.0, 0.0)
			* float4(_ScaleX, _ScaleY, 1.0, 1.0));

		output.tex = input.tex;







		return output;
	}

	float4 frag(vertexOutput input) : COLOR
	{
		fixed4 col = tex2D(_MainTex, float2(input.tex.xy));
		col.rgb *= col.a;
		return col;
	}

		ENDCG
	}
	}
}