Shader "Effect/ScreenWaterWave"     
{  
    Properties   
    {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
    }  
  
    CGINCLUDE  
    #include "UnityCG.cginc"  
    uniform sampler2D _MainTex;  
    uniform float _distanceFactor;  
    uniform float _timeFactor;  
    uniform float _totalFactor;  
    uniform float _waveWidth;  
    uniform float _curWaveDis;  
  
    fixed4 frag(v2f_img i) : SV_Target  
    {  
        //计算uv到中间点的向量(向外扩，反过来就是向里缩)  
        float2 dv = float2(0.5, 0.5) - i.uv;  
        //按照屏幕长宽比进行缩放，使波纹变为圆形，否则可能是椭圆形  
        dv *= float2(_ScreenParams.x / _ScreenParams.y, 1);  
        //计算像素点距中点的距离  
        float dis = length(dv);
        //用sin函数计算出波形的偏移值factor  
        //dis在这里都是小于1的，所以我们需要乘以一个比较大的数，比如60，这样就有多个波峰波谷  
        //sin函数是（-1，1）的值域，我们希望偏移值很小，所以这里我们缩小100倍，(采用乘法比较快) 
        float sinFactor = sin(dis * _distanceFactor + _Time.y * _timeFactor) * _totalFactor * 0.01;  

        //距离当前波纹运动点的距离，如果小于waveWidth才予以保留，否则已经出了波纹范围，factor通过clamp设置为0
        //没有这一步，则波纹不会消失  
        float discardFactor = clamp(_waveWidth - abs(_curWaveDis - dis), 0, 1);  
        //归一化  
        float2 dv1 = normalize(dv);  
        //计算每个像素uv的偏移值  
        float2 offset = dv1 * sinFactor * discardFactor;   
        //像素采样时偏移offset  
        float2 uv = offset + i.uv;  
        return tex2D(_MainTex, uv);   
    }  
  
    ENDCG  
  
    SubShader   
    {  
        Pass  
        {  
            ZTest Always  
            Cull Off  
            ZWrite Off  
            Fog { Mode off }  
  
            CGPROGRAM  
            #pragma vertex vert_img  
            #pragma fragment frag  
            #pragma fragmentoption ARB_precision_hint_fastest   
            ENDCG  
        }  
    }  
    Fallback off  
} 