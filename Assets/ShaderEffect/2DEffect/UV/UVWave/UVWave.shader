Shader "Effect/UVWave" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed("speed", Range(0,20)) = 11.4
        _Scale("scale", Range(0,5)) = 4
        _Identity("Identity",Range(50,100.0)) = 77
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Speed;
            float _Scale;
            float _Identity;

            struct v2f
            {
                float4 pos : POSITION;
                float4 uv : TEXCOORD0;
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }


            //让图片的每一个像素沿着某个方向周期性的往复运动， 
            //可以通过平面简谐波进行模拟，其波函数我们简写为y=Acos(at+bx)，其中t为时间，x为与原点（已知振动方程的点）的距离。t可以用_Time[1]表示，
            //距离我们可以取uv.x(即u相同让它有相同的运动)，
            //更优的方法是使用sqrt(uv.x*uv.x + uv.y*uv.y)
            float4 frag(v2f i) : COLOR
            {      
                float4 o;
                fixed2 uv = i.uv.xy;
                fixed curR = sqrt(uv.x*uv.x + uv.y*uv.y);
                fixed finalR = cos(_Time[1] * _Speed + curR * _Scale)/_Identity;
                o.rgb = tex2D(_MainTex, float2(finalR, 0) + uv).rgb;
                o.a = 1;
                return o;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}