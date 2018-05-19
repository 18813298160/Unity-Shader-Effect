// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect/ScreenRotating"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _Twist("Twist",float) = 0
	}
	SubShader
	{
        Tags { "RenderType"="Opaque" }
        LOD 100

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


            sampler2D _MainTex;
            float _Twist;
            float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
                //点到纹理中心的向量，取长度就是到中心的距离
                fixed2 uv = fixed2(i.uv.x - 0.5, i.uv.y - 0.5);
                fixed len = length(uv);
                //根据距离算出旋转角度, UNITY_PI / 180 = 0.1745
                float angle = _Twist * 0.1745 / (len + 0.1);
                
                float sinval, cosval;
                sincos(angle, sinval, cosval);

                 //构建旋转矩阵
                float2x2 _matrix = float2x2(cosval, -sinval, sinval, cosval);
                //旋转完成后，平移至原位置
                uv = mul(_matrix, uv) + 0.5;

                fixed4 col = tex2D(_MainTex, uv);

				return col;
			}
			ENDCG
		}
	}
}
