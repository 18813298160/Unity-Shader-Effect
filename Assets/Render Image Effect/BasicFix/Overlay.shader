//叠加模式混合（与第一种的区别，计算公式不同而已）
Shader "Effect/Overlay" {  
    Properties {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
        _BlendTex ("Blend Texture", 2D) = "white" {}  
        _Opacity ("Blend Opacity", Range(0.0, 1.0)) = 1.0  
    }

    SubShader {  
        Pass {  
            CGPROGRAM  
            #pragma vertex vert_img  
            #pragma fragment frag  
              
            #include "UnityCG.cginc"  
              
            uniform sampler2D _MainTex;   
            uniform sampler2D _BlendTex;   
            fixed _Opacity;

            fixed OverlayBlendMode(fixed basePixel, fixed blendPixel) 
            {  
			    if (basePixel < 0.5) {  
			        return (2.0 * basePixel * blendPixel);  
			    } else {  
			        return (1.0 - 2.0 * (1.0 - basePixel) * (1.0 - blendPixel));  
		    }  
}  
              
            fixed4 frag(v2f_img i) : COLOR  
            {  
                //tex2D 2D纹理查询，可获取纹理的rgba值
                fixed4 renderTex = tex2D(_MainTex, i.uv);  
                fixed4 blendTex = tex2D(_BlendTex, i.uv);  

                fixed4 overlay = renderTex;
                overlay.r = OverlayBlendMode(renderTex.r, blendTex.r);  
                overlay.g = OverlayBlendMode(renderTex.g, blendTex.g);  
                overlay.b = OverlayBlendMode(renderTex.b, blendTex.b); 
                    
                fixed4 finalColor = lerp(renderTex, overlay, _Opacity);  
                  
                return finalColor;  
            }  
              
            ENDCG  
        }  
    }  
    FallBack "Diffuse"  
}  