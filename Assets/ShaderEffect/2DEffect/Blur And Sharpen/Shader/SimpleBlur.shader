// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//简单模糊，采样附近上下左右四个相邻像素的颜色，与当前像素颜色按比例混合（简单滤波） 
Shader "Effect/2D/SimpleBlur" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
         Tags{"Queue"="Transparent"}
     
        pass
        {
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float uvOffset;
           
            struct v2f
            {
                float4  pos : SV_POSITION;
                float2  uv : TEXCOORD0;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv =  TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }

            float4 frag (v2f i) : COLOR
            {
                float4 s1 = tex2D(_MainTex, i.uv + float2(uvOffset,0.00));
                float4 s2 = tex2D(_MainTex, i.uv + float2(-uvOffset,0.00));
                float4 s3 = tex2D(_MainTex, i.uv + float2(0.00,uvOffset));
                float4 s4 = tex2D(_MainTex, i.uv + float2(0.00,-uvOffset));
               
                float4 texCol = tex2D(_MainTex, i.uv);
                float4 outp;
                float pct = 0.2;
                outp = texCol * (1- pct*4) + s1* pct + s2* pct+ s3* pct + s4* pct;
                return outp;
            }
            ENDCG
        }
    }
}