// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
//从任意角度看这个物体时它都和从正面看到的一样
//ref:https://blog.csdn.net/cheng624/article/details/65635288
Shader "Custom/MainView" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}

		SubShader{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProject" = "True" "DisableBatching" = "True" }
		Pass{
		Tags{ "LightMode" = "ForwardBase" }

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

		fixed4 _Color;
	sampler2D _MainTex;

	struct a2v {
		float4 vertex : POSITION;
		float4 texcoord : TEXCOORD0;
	};

	struct v2f {
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
	};

	v2f vert(a2v v) {
		v2f o;
		float3 center = float3(0,0,0);
		float3 viewerPos = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));

		float3 z1 = normalize(viewerPos - center);//视觉向量，新的Z1
												  //上方，模型的向上方向向量，和视觉方向垂直，当视觉方向接近垂直时设为世界坐标的水平方向
		float3 y1 = abs(z1.y) > 0.999 ? float3(0,0,1) : float3(0,1,0);
		float3 x1 = normalize(cross(y1, z1));//叉乘得垂直
		y1 = normalize(cross(z1, x1));//获取准确的向上分量

		float3 curVector = v.vertex.xyz - center;//当前坐标向量
												 //向量在三个方向上的分量为最终坐标，相当于重构坐标轴
		float3 newPos = center + x1 * curVector.x + y1 * curVector.y + z1 * curVector.z;//转化到新坐标系
		o.pos = UnityObjectToClipPos(float4(newPos, 1));
		o.uv = v.texcoord.xy;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target{
		return tex2D(_MainTex, i.uv) * _Color;
	}

		ENDCG
	}
	}

		FallBack Off
}