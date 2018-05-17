// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//使用sobel算法进行边缘检测(扣掉内部)

Shader "Effect/SobelCheck2" {  
Properties {  
    _MainTex ("MainTex", 2D) = "white" {}   
     _DefColor ("defalutColor", COLOR)  = ( 0, .8, .4, 1) 
}  
SubShader {  
    pass{  
    Tags{"LightMode"="ForwardBase" }  
    Cull off  
    CGPROGRAM  
    #pragma vertex vert  
    #pragma fragment frag  
    #include "UnityCG.cginc"  
     
    sampler2D _MainTex;  
    float4 _MainTex_ST;  
    //内置变量，主贴图 _MainTex 的像素尺寸大小，值为：Vector4(1 / width, 1 / height, width, height)
    float4 _MainTex_TexelSize;
    fixed4 _DefColor;

    struct v2f {  
        float4 pos:SV_POSITION;  
        float2 uv_MainTex:TEXCOORD0;  
          
    };  

    v2f vert (appdata_full v) {  
        v2f o;  
        o.pos=UnityObjectToClipPos(v.vertex);  
        o.uv_MainTex = TRANSFORM_TEX(v.texcoord,_MainTex);  
        return o;  
    }  

    fixed3 dealTex(sampler2D t, float2 x)
    {
        //只需要最外围的边缘“信息”。因此将非透明区域都填充成统一的颜色，再做边缘检测
        fixed4 tex = tex2D(t, x);
        if(tex.a > 0.9)
        {
            tex.rgb = _DefColor.rgb;
        }
        return tex.rgb;
    }


    float4 frag(v2f i):COLOR  
    {  

        fixed4 tex = tex2D(_MainTex, i.uv_MainTex); 


        float3 lum = float3(0.2125,0.7154,0.0721);//转化为luminance亮度值  
        //获取当前点的周围的点  
        //并与luminance点积，求出亮度值（黑白图）  
        float2 Size = _MainTex_TexelSize.zw;
        float mc00 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(1,1)/Size), lum);  
        float mc10 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(0,1)/Size), lum);  
        float mc20 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(-1,1)/Size), lum);  
        float mc01 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(1,0)/Size), lum);  
        float mc11mc = dot(dealTex(_MainTex, i.uv_MainTex), lum);  
        float mc21 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(-1,0)/Size), lum);  
        float mc02 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(1,-1)/Size), lum);  
        float mc12 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(0,-1)/Size), lum);  
        float mc22 = dot(dealTex(_MainTex, i.uv_MainTex-fixed2(-1,-1)/Size), lum);  
        //根据过滤器矩阵求出GX水平和GY垂直的灰度值  
        float GX = -1 * mc00 + mc20 + -2 * mc01 + 2 * mc21 - mc02 + mc22;  
        float GY = mc00 + 2 * mc10 + mc20 - mc02 - 2 * mc12 - mc22;  

        //第一种方法
        float G = sqrt(GX*GX+GY*GY);//标准灰度公式  
        //第二种，近似方法
        //float G = abs(GX)+abs(GY);//近似灰度公式
        //return G;
            
        //float th = atan(GY/GX);//灰度方向  
        //第三种方法
        float4 c = 0;  
//          c = G>th?1:0;  
//          c = G/th*2;  
        c = length(float2(GX,GY));//length的内部算法就是灰度公式的算法，欧几里得长度  

        return c;  
    }  
    ENDCG  
    }//  

}   
} 