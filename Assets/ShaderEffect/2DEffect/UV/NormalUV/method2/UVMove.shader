﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect/2D/UVMove" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        //加入噪声测试
        //_NoiseTex("Noise Texture", 2D) = "bump" {}
        _ScrollX("scroll x", float) = 2
        _ScrollY("scroll y", float) = 2
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
            //sampler2D _NoiseTex;

            float4 _MainTex_ST;

            float _ScrollX;
            float _ScrollY;

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
                //o.uv.zw = TRANSFORM_TEX(v.texcoord, _MainTex) + _Time.x;
                return o;
            }

            float4 frag(v2f i) : COLOR
            {      
                float4 o;
                fixed2 scrolledUv = i.uv.xy;
                fixed x = _ScrollX * _Time;
                fixed y = _ScrollY * _Time;
                scrolledUv += fixed2(x, y);

                //fixed2 noiseUv = tex2D(_NoiseTex, i.uv.zw).xy * 0.05 - 0.025 ; 
                //o.rgb = tex2D(_MainTex, scrolledUv + noiseUv).rgb;
                o.rgb = tex2D(_MainTex, scrolledUv).rgb;
                return o;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}