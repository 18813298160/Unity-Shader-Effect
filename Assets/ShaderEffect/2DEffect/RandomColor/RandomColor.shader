Shader "Custom/RandomColor"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" }
		Lighting off //关闭光照
		ZWrite off //关闭深度缓存

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			#define HASHSCALE3 float3(.1031, .1030, .0973)

			float2 Hash22(float2 p)
			{
				float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz)*p3.zy);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//做乘法分区
				i.uv *= 4;
			//随机分配颜色值
			i.uv = Hash22(floor(i.uv));
			return fixed4(i.uv, 0, 1);

			}
			ENDCG
		}
	}
}
