// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
//简单UV动画（使用Surface Shader）
Shader "Effect/2D/NormalUv" {
    Properties {
        _MainTex ("Image Sequence", 2D) = "white" {}
        _ScrollX ("x speed", Float) = 2
        _ScrollY ("y speed", Float) = 2
    }

    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True"}
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        float _ScrollX;
        float _ScrollY;
        
        struct Input {  
            float2 uv_MainTex;
        };  

        UNITY_INSTANCING_CBUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutputStandard o) 
        {
            fixed2 scrolledUv = IN.uv_MainTex;
            fixed x = _ScrollX * _Time;
            fixed y = _ScrollY * _Time;

            scrolledUv += fixed2(x, y);
			// Albedo comes from a texture tinted by color
			half4 c = tex2D (_MainTex, scrolledUv);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
            
        ENDCG 
    }
    FallBack "Transparent/VertexLit"
}