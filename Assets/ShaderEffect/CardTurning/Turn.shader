Shader "Personal/PageTurning" {
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		//正面
		_MainTex("MainTex",2D) = "White"{}
		//反面
		_SecTex("SecTex",2D) = "White"{}
		_Angle("Angle",Range(0,180)) = 0
		_Downward("Downward",Range(0,1)) = 0
	}


		CGINCLUDE

#include "UnityCG.cginc"  

	struct v2f
	{
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;
	};

	fixed4 _Color;
	float _Angle;
	float _Downward;
	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata_base v)
	{
		v2f o;
		float s;
		float c;
		sincos(radians(-_Angle), s, c);
		//构建z轴的旋转矩阵
		float4x4 rotate = {
			c,0,s,0,
			0,1,0,0,
			-s,0,c,0,
			0,0,0,1 };
		float rangeF = saturate(1 - abs(90 - _Angle) / 90);
		v.vertex.x -= rangeF * v.vertex.x*_Downward;
		v.vertex = mul(rotate, v.vertex);

		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
		return o;
	}


	ENDCG

		//用了两个Pass通道来实现，一个是后面剔除，一个是前面剔除。分别对两个图片采样。
		SubShader
	{
		Blend SrcAlpha OneMinusSrcAlpha
		pass
	{
		Cull Back

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			fixed4 frag(v2f i) :COLOR
			{
				fixed4 color = tex2D(_MainTex,-i.uv);
				return _Color * color;
			}

			ENDCG
	}

	pass
	{
		Cull Front

			CGPROGRAM
			#pragma vertex vert 
			#pragma fragment frag 

			sampler2D _SecTex;

			fixed4 frag(v2f i) :COLOR
			{
				float2 uv = i.uv;
				uv.x = -uv.x;
				fixed4 color = tex2D(_SecTex,-uv);
				return _Color * color;
			}
			ENDCG
	}
	}
}