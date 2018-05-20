//屏幕灰度控制
Shader "Effect/ImageEffect" {  
    Properties {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _LuminosityAmount ("GrayScale Amount", Range(0.0, 1.0)) = 1.0  
    }  
    SubShader {  
        Pass {  
            CGPROGRAM  
            #pragma vertex vert_img  
            #pragma fragment frag  
              
            #include "UnityCG.cginc"  
              
            uniform sampler2D _MainTex;  
            fixed _LuminosityAmount;  
              
            fixed4 frag(v2f_img i) : COLOR  
            {  
                fixed4 renderTex = tex2D(_MainTex, i.uv);  
                fixed luminosity = Luminance(renderTex.rgb);   
                fixed3 lumColor = fixed3(luminosity, luminosity, luminosity);
                fixed4 finalColor = fixed4(lerp(renderTex.rgb, lumColor, _LuminosityAmount), renderTex.a);
                return finalColor;  
            }  
              
            ENDCG  
        }  
    }  
    FallBack "Diffuse"  
}  