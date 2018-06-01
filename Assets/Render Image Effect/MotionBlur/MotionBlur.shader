Shader "Effect/MotionBlur"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _BlurSize ("Blur Size", Float) = 1.0 
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;  
			//使用_MainTex_TexelSize变量来对深度纹理的采样坐标进行平台化差异处理  
			half4 _MainTex_TexelSize;  
			//Unity传递来的深度纹理  
			sampler2D _CameraDepthTexture;  
            
			float4x4 _PreViewProjectionMat;  
			float4x4 _CurViewProjectionInverseMat;  
			half _BlurSize;  

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
                //用于深度纹理采样的纹理坐标变量
                half2 uvDepth : TEXCOORD1;
			};

			v2f vert (appdata_img v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
				o.uvDepth = v.texcoord;

				//平台差异化处理  
				#if UNITY_UV_STARTS_AT_TOP  
				if (_MainTex_TexelSize.y < 0) 
                {  
				    o.uvDepth.y = 1 - o.uvDepth.y;  
				}  
				#endif  
                
				return o;
			}


	         //定义片元着色器  
	        fixed4 frag(v2f i) : SV_Target{  
	            //使用宏和纹理坐标对深度纹理进行采样，得到深度值  
	            float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uvDepth);  
	  
	            //构建当前像素的NDC坐标,xy坐标由像素的纹理坐标映射而来，z坐标由深度值d映射而来  
	            float4 H = float4(i.uv.x * 2 - 1, i.uv.y * 2 - 1, d * 2 - 1, 1); 
	            //像素当前帧NDC坐标  
	            float4 currentPos = H;  
	             
	            //使用 当前帧的视角 * 投影矩阵 的逆矩阵 对H进行变换  
	            float4 D = mul(_CurViewProjectionInverseMat, H);  
	            //把结果除以它的w分量，得到该像素世界空间下的坐标  
	            float4 worldPos = D / D.w;

                //由于此处用于获得前一帧NDC坐标的世界坐标是当前值，所以如果是物体进行移动，
                //那么得到的NDC坐标就还是当前值，但是如果是通过摄像机移动，那么就能得到前一帧的值了。
	  
	            //使用 前一帧视角 * 投影矩阵 变换世界空间的的坐标worldPos，并除以它的w分量，得到前一帧的NDC坐标  
	            float4 previousPos = mul(_PreViewProjectionMat, worldPos);  
	            previousPos /= previousPos.w;  
	  
	            //计算当前帧与前一帧在屏幕空间下的位置差，得到该像素的速度  
	            float2 velocity = (currentPos.xy - previousPos.xy) / 2.0f;  
	  
	            //使用速度值对邻域像素进行采样，相加后取平均值得到一个模糊效果，使用_BlurSize控制采样距离  
	            float2 uv = i.uv;  
	            float4 c = tex2D(_MainTex, uv);  
	            uv += velocity * _BlurSize;  
	            for (int it = 1; it < 3; it++, uv += velocity * _BlurSize) 
	            {  
	                float4 currentColor = tex2D(_MainTex, uv);  
	                c += currentColor;  
	            }  
	            c /= 3;  
	  
	            return fixed4(c.rgb, 1.0);  
	        }   
            
			ENDCG
		}
	}
}
