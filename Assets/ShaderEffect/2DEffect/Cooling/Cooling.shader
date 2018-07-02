// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect/2D/Cooling"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	_BrushTex("Brush Texture", 2D) = "white" {}
	_Speed("Speed", Range(1, 10)) = 1
		_Color("Color", Color) = (0, 0, 0, 1)
		[Toggle]_Dir("Direction", float) = 1
		_Angle("Angle",Range(0,360)) = 0

	}

		CGINCLUDE
#include "UnityCG.cginc" 

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

#define PI 3.142  

	sampler2D _MainTex;
	sampler2D _BrushTex;
	float4 _MainTex_ST;
	float4 _BrushTex_ST;
	half _Speed;
	fixed4 _Color;
	float _Dir;
	float _Angle;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}

	ENDCG

		SubShader
	{
		//渲染队列设置为  以从后往前的顺序渲染透明物体
		Tags{ "Queue" = "Transparent" }
		Lighting off //关闭光照
		ZWrite off //关闭深度缓存

		Blend SrcAlpha OneMinusSrcAlpha

		Pass
	{

		CGPROGRAM
#pragma vertex vert  
#pragma fragment frag   

		fixed4 frag(v2f i) : SV_Target
	{
		fixed4 col = tex2D(_MainTex, i.uv);

	//以正中间为中心，所以将uv范围映射到(-0.5, 0.5)  
	float2 uv = i.uv - float2(0.5, 0.5);
	//atan2(y, x)：反正切，y/x的反正切范围在[-π, π]内，计算角度信息  
	//_Dir用于控制方向(-1, +1)
	fixed negative = step(0.9, _Dir);
	fixed dir = negative + -1 * (1 - negative);
	float radian = dir * atan2(uv.y, uv.x) + PI;

	float2 radian1 = radians(_Angle);
	fixed v = step(radian, radian1);

	return col* (v + (1 - v) * _Color);

	}
		ENDCG
	}

		Pass
	{

		CGPROGRAM
#pragma vertex vert  
#pragma fragment frag  

		fixed4 frag(v2f i) : SV_Target
	{
		//角度不在2到357区间时，不显示_BrushTex
		float show = step(2, _Angle) * step(_Angle, 357);
	//初始偏移90度
	float2 radian1 = radians(_Angle) + 0.5 * PI;

	float rot = _Dir * radian1;
	float s = sin(rot);
	float c = cos(rot);

	//调整旋转中心
	i.uv -= float2(0.5, 0.5);
	//施加旋转矩阵
	i.uv = mul(i.uv, float2x2(c, -s, s, c));
	i.uv += float2(0.5, 0.5);

	fixed4 brushCol = tex2D(_BrushTex, i.uv) * show;

	return brushCol;

	}
		ENDCG
	}

	}
}