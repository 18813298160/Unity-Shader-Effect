//正片叠底模式混合（将基色和混合色相乘）
Shader "Effect/Multiply" {  
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
              
            fixed4 frag(v2f_img i) : COLOR  
            {  
                //tex2D 2D纹理查询，可获取纹理的rgba值
                fixed4 renderTex = tex2D(_MainTex, i.uv);  
                fixed4 blendTex = tex2D(_BlendTex, i.uv);  

                //两张纹理执行乘法操作
                fixed4 mutiply = renderTex * blendTex;
                    
                fixed4 finalColor = lerp(renderTex, mutiply, _Opacity);  
                  
                return finalColor;  
            }  
              
            ENDCG  
        }  
    }  
    FallBack "Diffuse"  
}  