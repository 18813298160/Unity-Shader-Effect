// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect/2D/ImageSequence" {
    Properties {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Image Sequence", 2D) = "white" {}
        _HorizontalAmount ("Horizontal Amount", Float) = 8
        _VerticalAmount ("Vertical Amount", Float) = 8
        _Speed ("Speed", Range(1, 100)) = 30
    }
    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        
        Pass {
            Tags { "LightMode"="ForwardBase" }
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            
            #pragma vertex vert  
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _HorizontalAmount;
            float _VerticalAmount;
            float _Speed;
            
            struct a2v {  
                float4 vertex : POSITION; 
                float2 texcoord : TEXCOORD0;
            };  
            
            struct v2f {  
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };  
            
            v2f vert (a2v v) {  
                v2f o;  
                //将顶点坐标转换到裁剪空间坐标系并且
                o.pos = UnityObjectToClipPos(v.vertex);  
                //o.texcoord = v.texcoord.xy *_MainTex_ST.xy+_MainTex_ST.zw 
                //将纹理坐标映射到顶点上以及zw偏移
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);  
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target {
                //_Time.y是在场景中运行的时间，乘上速度得到模拟的时间
                float time = floor(_Time.y * _Speed);  
                float row = floor(time / _HorizontalAmount);    // /通过时间运算获取当前行
                float column = time - row * _HorizontalAmount;  // %运算获取当前列（余数）
                
                //首先把原纹理坐标i.uv按行数和列数进行等分，得到每个子图像的大致纹理范围，然后使用当前的行列进行偏移
                half2 uv = i.uv + half2(column, -row);
                //缩放至子图像的大小
                uv.x /= _HorizontalAmount;
                uv.y /= _VerticalAmount;
                
                //纹理采样
                fixed4 c = tex2D(_MainTex, uv);
                c.rgb *= _Color;
                
                return c;
            }
            
            ENDCG
        }  
    }
    //FallBack "Transparent/VertexLit"
}