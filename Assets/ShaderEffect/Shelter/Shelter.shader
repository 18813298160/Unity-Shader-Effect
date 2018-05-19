// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//遮挡关系处理实现：通过两个Pass以及深度测试实现；
//X-Ray ：边缘光效果，检测视线方向与法线方向夹角来实现。

Shader "Effect/XRayEffect"  
{  
    Properties  
    {  
        _MainTex("Base 2D", 2D) = "white"{}  
        _XRayColor("XRay Color", Color) = (1,1,1,1)  

        _NoiseTex("noise", 2D) = "bump" {}  
        _Density("speed", Range(0, 0.5)) = 0.3
    }  
  
    SubShader  
    {  
        Tags{ "Queue" = "Geometry+100" "RenderType" = "Opaque" }  
           
        /*
        渲染X光效果的Pass使用ZTest Greater，在渲染的时候，有遮挡的部分之前的遮挡物的深度，而未遮挡的部分由于深度无穷大深度测试不会通过，
        不显示任何内容，而被遮挡的部分，深度是遮挡物的深度，人物在遮挡物后，深度大于遮挡物，深度测试通过，会将遮挡部分渲染成Pass的输出，
        而且，这个Pass不能写入深度，因为我们还需要正常画出人物未被遮挡的部分，此时就可以正常的深度测试ZTest LEqual，被遮挡的部分不渲染，
        只渲染未被遮挡的部分*/

        //渲染X光效果的Pass 
        Pass  
        {  
            Blend SrcAlpha One  
            ZWrite Off  
            ZTest Greater  
  
            CGPROGRAM  
            #include "Lighting.cginc"  
            fixed4 _XRayColor;  
            sampler2D _NoiseTex;  
            float _Density;              

            struct v2f  
            {  
                float4 pos : SV_POSITION;  
                float3 viewDir : TEXCOORD0; 
                float3 normal : normal;  
                half2 zw : TEXCOORD1;
            };  
  
            v2f vert (appdata_base v)  
            {  
                v2f o;  
                o.pos = UnityObjectToClipPos(v.vertex);  
                o.viewDir = ObjSpaceViewDir(v.vertex);  
                o.normal = v.normal; 
                o.zw = v.texcoord.xy + _Time.x; 
                return o;  
            }  
  
            //fixed4 frag(v2f i) : SV_Target  
            fixed4 frag(v2f i) : COLOR0  
            {  
                float3 normal = normalize(i.normal);  
                float3 viewDir = normalize(i.viewDir);  
                //视线方向V与法线方向N垂直时，这个法线对应的面就与视线方向平行，
                //说明当前这个点对于当前视角来说，就处在边缘；
                float rim = 1 - dot(normal, viewDir);  

                //增加了一点噪声效果
                half3 noise = tex2D(_NoiseTex, i.zw );  
                return lerp(_XRayColor * rim, fixed4(noise.rgb, 0.2), _Density);
                //return _XRayColor * rim;  
            }  
            #pragma vertex vert  
            #pragma fragment frag  
            ENDCG  
        }  
          
        //正常渲染的Pass  
        Pass  
        {  
            ZWrite On  
            CGPROGRAM  
            #include "Lighting.cginc"  
            sampler2D _MainTex;  
            float4 _MainTex_ST;  
  
            struct v2f  
            {  
                float4 pos : SV_POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            v2f vert(appdata_base v)  
            {  
                v2f o;  
                o.pos = UnityObjectToClipPos(v.vertex);  
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);  
                return o;  
            }  
  
            fixed4 frag(v2f i) : SV_Target  
            {  
                return tex2D(_MainTex, i.uv);  
            }  
 
            #pragma vertex vert  
            #pragma fragment frag     
            ENDCG  
        }  
    }  
      
    FallBack "Diffuse"  
}  