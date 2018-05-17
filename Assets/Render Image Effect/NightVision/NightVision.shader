//夜视效果

Shader "Effect/NightVision" {  
    Properties {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _VignetteTex ("Vignette Texture", 2D) = "white" {}  
        _ScanLineTex ("Scan Line Texture", 2D) = "white" {}  
        _ScanLineTileAmount ("Scale Line Tile Amount", Float) = 4.0  
        _NoiseTex ("Noise Texture", 2D) = "white" {}  
        _NoiseXSpeed ("Noise X Speed", Float) = 100.0  
        _NoiseYSpeed ("Noise Y Speed", Float) = 100.0  
        _NightVisionColor ("Night Vision Color", Color) = (1, 1, 1, 1)  
        _Contrast ("Contrast", Range(0, 4)) = 2  
        _Brightness ("Brightness", Range(0, 2)) = 1  
        _RandomValue ("Random Value", Float) = 0  
        _Distortion ("Distortion", Float) = 0.2  
        _Scale ("Scale (Zoom)", Float) = 0.8  
    }  
    SubShader {  
        Pass {  
            CGPROGRAM  
              
            #pragma vertex vert_img  
            #pragma fragment frag  
              
            #include "UnityCG.cginc"  
              
            uniform sampler2D _MainTex;  
            uniform sampler2D _VignetteTex;  
            uniform sampler2D _ScanLineTex;  
            fixed _ScanLineTileAmount;  
            uniform sampler2D _NoiseTex;  
            fixed _NoiseXSpeed;  
            fixed _NoiseYSpeed;  
            fixed4 _NightVisionColor;  
            fixed _Contrast;  
            fixed _Brightness;  
            fixed _RandomValue;  
            fixed _Distortion;  
            fixed _Scale;  

            //透镜变形（lens distortion）效果，来模拟从透镜中观察、图像边界由于透镜度数而发生变形的效果
            float2 barrelDistortion(float2 coord) 
            {  
                // Lens distortion algorithm  
                // See http://www.ssontech.com/content/lensalg.htm  

                //首先找到纹理的中心——float(0.5, 0.5)。一旦得到了图像中心，我们可以根据像素距离中心的远近对像素应用一个拉伸
                float2 h = coord.xy - float2(0.5, 0.5);  
                float r2 = h.x * h.x + h.y * h.y;  
                float f = 1.0 + r2 * (_Distortion * sqrt(r2));  
                  
                return f * _Scale * h + 0.5;  
            }  
              
            fixed4 frag(v2f_img i) : COLOR {  
                // Get the colors from the Render Texture and the uv's  
                // from the v2f_img struct  
                half2 distortedUV = barrelDistortion(i.uv);  
                fixed4 renderTex = tex2D(_MainTex, distortedUV);  
                fixed4 vignetteTex = tex2D(_VignetteTex, i.uv);  
                  
                // 处理扫描线和噪点纹理  
                half2 scanLinesUV = half2(i.uv.x * _ScanLineTileAmount, i.uv.y * _ScanLineTileAmount);  
                fixed4 scanLineTex = tex2D(_ScanLineTex, scanLinesUV);  
                  
                half2 noiseUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _NoiseXSpeed),  
                                            i.uv.y + (_Time.x * _NoiseYSpeed));  
                fixed4 noiseTex = tex2D(_NoiseTex, noiseUV);  
                  
                //通过YIQ得到当前的光度值lum，再加上_Brightness来调整亮度。最后，再加上_NightVisionColor（也就是绿色）。这里lum*2是为了不至于让整个画面太暗  
                //设置偏绿的颜色效果
                fixed lum = dot(fixed3(0.299, 0.587, 0.114), renderTex.rgb);  
                lum += _Brightness;  
                fixed4 finalColor = (lum * 2) + _NightVisionColor;  
                  
                // 把所有的图层结合在一起，返回最终的像素值 
                finalColor = pow(finalColor, _Contrast);  
                finalColor *= vignetteTex;  
                finalColor *= scanLineTex * noiseTex;  
                  
                return finalColor;  
            }  
              
            ENDCG  
        }  
    }   
    FallBack "Diffuse"  
}  