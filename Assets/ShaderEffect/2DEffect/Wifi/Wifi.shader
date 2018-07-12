// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect/2D/Wifi"
{
	Properties
	{
		_Color("Color", Color) = (0, 1, 0, 1)
		_Radius("Radius", Range(0, 18)) = 12
	}
		SubShader
	{
		Tags{ "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off

		Pass
	{
		CGPROGRAM
		#pragma vertex vert  
		#pragma fragment frag  
		#include "UnityCG.cginc"  

	#define QUARTER_PI 0.78539
	#define TQUARTER_PI 2.35617

		struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			float2 uv : TEXCOORD0;
		};

		fixed4 _Color;
		fixed _Radius;

	//画WIFI
	fixed4 DrawWifi(float2 uv, float2 center, float radius)
	{
		//在半径范围内就可以显示
		fixed distance = length(uv - center);

		fixed baseCircle = step(distance, radius);

		fixed discardPart1 = step(radius / 3, distance) * step(distance, radius / 2);
		fixed discardPart2 = step(2 * radius / 3, distance) * step(distance, 5 * radius / 6);

		//将uv范围映射到(-0.5, 0.5)  
		float2 uvCenter = uv - float2(0.5, 0.5);

		float radian = atan2(uvCenter.y, uvCenter.x);
		fixed v = step(radian, TQUARTER_PI) * step(QUARTER_PI, radian);

		return baseCircle * _Color * v * (1 - discardPart1) * (1 - discardPart2);
	}

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;

		return o;
	}


	fixed4 frag(v2f i) : SV_Target
	{
		return DrawWifi(i.uv, float2(0.5, 0.5), 0.01 * _Radius);
	}
		ENDCG
	}
	}
}