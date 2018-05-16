﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//挤压效果
//从上到下对顶点进行偏移
Shader "Effect/Crush"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //物体的y坐标上限
        _TopY("Top Y", Float) = 0
        //物体的y坐标下限
        _BottomY("Bottom Y", Float) = 0 
        //控制条
        _Control("Control Squash", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
            float4 _MainTex_ST;
            float _TopY;
            float _BottomY;
            float _Control;

            //对所有顶点的Y坐标进行归一化
            float GetNormalizedDist(float worldPosY)
            {
                float range = _TopY - _BottomY;
                float border = _TopY;

                float dist = abs(worldPosY - border);
                //saturate(x) Clamps x to the range [0, 1]
                float normalizedDist = saturate(dist / range);
                return normalizedDist;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float worldPosY = mul(unity_ObjectToWorld, v.vertex).y;
                float3 localNegativeY = mul(unity_WorldToObject, float4(0, -1, 0, 1)).xyz;
                float normalizedDist = GetNormalizedDist(worldPosY);
                float val = max(0, _Control - normalizedDist);
                v.vertex.xyz += localNegativeY * val;

                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}