//UV动画的模版shader

Shader "Effect/2D/UVPattern" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}

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

            float4 frag(v2f i) : COLOR
            {      
                float4 o;
                //进行一些处理。。。
                return o;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}