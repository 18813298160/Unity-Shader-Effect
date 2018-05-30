// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//作用：将之前的Texture与最新的笔刷纹理再混合成一张新的图片
Shader "Effect/PaintBrush"
{
    Properties
    {
        //之前的texture(这里就是用来保存笔刷信息的这张render texture)
        _MainTex ("Texture", 2D) = "white" {}
        //笔刷纹理
        //注意，笔刷纹理的wrap mode要设置为Clamp模式
        _BrushTex("Brush Texture",2D)= "white" {}
        _Color("Color",Color)=(1,1,0,1)
        //笔刷的当前位置
        _UV("UV",Vector)=(0,0,0,0)
        _Size("Size",Range(1,1000))=100
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
        ZTest Always Cull Off ZWrite Off Fog{ Mode Off }
        Blend SrcAlpha OneMinusSrcAlpha
        //Blend One DstColor
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
            sampler2D _BrushTex;
            fixed4 _UV;
            float _Size;
            fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            fixed4 frag (v2f i) : COLOR
            {
                // sample the texture
                //将笔刷的中心移动到整个纹理的中心
                float2 uv = i.uv + (0.5f/_Size);
                //计算动态的绘画的位置
                uv = uv - _UV.xy;
                //放大uv->缩小纹理
                uv *= _Size;
                fixed4 col = tex2D(_BrushTex, uv);
                //去掉原来的颜色
                col.rgb = 1;
                //*上笔刷的颜色
                col *= _Color;
                return col;
            }
            ENDCG
        }
    }
}
