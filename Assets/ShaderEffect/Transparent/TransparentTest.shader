//使用alpha通道创建透明效果

//使用Surface Shaders得到透明效果,依赖三个元素：
//正确设置Shader渲染队列，#pragma声明中的alpha参数，
//以及在SurfaceOutput结构体中的Alpha值。
Shader "Effect/TransparentTest" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
        //使用该贴图的RGB通道作为一个取值为0或1的透明度值。
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Transparence ("Transparence", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
		LOD 200
		
		CGPROGRAM
        //通过在Shader的#pragma声明中添加alpha参数来实现,告诉Unity我们想要在Shader中使用透明度
        #pragma surface surf Lambert alpha 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		float _Transparence;
		fixed4 _Color;
        
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
            /*则贴图中除了红色部分以及白色部分（白色的RGB通道值均为1）
            其R通道的值为1，其余（绿色和蓝色部分）均为0。因此只有红色和白色的部分才不透明。*/
			o.Alpha = c.r * _Transparence;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
