// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


//透明躁动图片，这是在alpha图片的基础上加入躁动得到的结果
Shader "Effect/imageShine" {  
    Properties {  
        _MainTex ("image", 2D) = "white" {}  
        _NoiseTex("noise", 2D) = "bump" {}  
        _percent("percent", Range(-0.3, 1)) = 0  
        _DefColor ("defalutColor", COLOR)  = ( 0, .8, .4, 1)  
    }  
      
    CGINCLUDE  
        #include "UnityCG.cginc"             
        
        sampler2D _MainTex;  
        sampler2D _NoiseTex;          
        float _percent;  
        fixed4 _DefColor;  
          
        struct v2f {      
            half4 pos:SV_POSITION;      
            half4 uv : TEXCOORD0;     
        };    
    
        v2f vert(appdata_full v) {    
            v2f o;    
            o.pos = UnityObjectToClipPos (v.vertex);    
            o.uv.xy = v.texcoord.xy;  
            o.uv.zw = v.texcoord.xy + _Time.x;  
            return o;    
        }    

        /*
        图片扭曲过程的解释：
		a）由于_NoiseTex所表示的噪声图片的每个像素点的值在区间[0,1]之内。即noise.xy的值在[0,1]之间。
		b)  noise.xy * 0.05 的区间为[0,0.05]；
		c）noise.xy * 0.05-0.025的区间为[-0.025,0.025]
		d）i.uv.xy + noise.xy * 0.05 - 0.025 表示对原来图片的uv进行[-0.025,0.025]之间任意值的一次偏移（取决于噪声图），这样就形成了图像扭曲效果。
		e）又由于i.uv.zw受时间支配，所以noise的值也随时间变化。这样整个图片的扭曲，也随时间变化，就形成了液化的效果。
		其中0.05和0.025的值是实验得出的。可以更具实际情况改变来达到不同的效果。
        */
        fixed4 frag(v2f i) : COLOR0 {  
            // 原始卡牌, 把alpha设置为1，屏蔽掉alpha通道信息  
            fixed4 tex0 = tex2D(_MainTex, i.uv.xy);  
            tex0.a = 1;  
            // 透明躁动卡牌; 使用alpha通道信息，设置显示颜色，并加入躁动；  
            half3 noise = tex2D(_NoiseTex, i.uv.zw );  
            fixed4 tex1 = tex2D(_MainTex, i.uv.xy + noise.xy * 0.05 - 0.025);  
            tex1.rgb = _DefColor.rgb;  

            //两个图片的叠加；通过比较uv中的v 和 _percent，来融合处理后的alpha通道和rgb通道
            return lerp(tex0, tex1, smoothstep(0, 0.3, i.uv.y-_percent));  
        }    
    ENDCG      
    
    SubShader {     
        Tags {"Queue" = "Transparent"}       
        ZWrite Off       
        Blend SrcAlpha OneMinusSrcAlpha       
        Pass {      
            CGPROGRAM      
            #pragma vertex vert      
            #pragma fragment frag      
            #pragma fragmentoption ARB_precision_hint_fastest       
    
            ENDCG      
        }  
    }  
    FallBack Off    
}  