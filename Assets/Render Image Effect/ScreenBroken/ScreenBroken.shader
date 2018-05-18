﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// 法线贴图映射的屏幕破碎特效
Shader "Effect/ScreenBroken" {
    Properties{
        _Color("Color",Color) = (1,1,1,1)
        _MainTex("Main Tex",2D) = "white"{}
        _NormalMap("Normal Map",2D) = "bump"{} //bump默认值的意思：若没有法线贴图，则使用顶点自带的
        _LuminosityAmount ("GrayScale Amount", Range(0.0, 1.0)) = 1.0  
    }

    SubShader{

        Tags{ "Queue" = "Transparent" "IngnoreProjector" = "True" "RenderType" = "Transparent" }
        
        Pass{
        
            Tags {"LightMode" = "ForwardBase"}

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment frag

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float _DepthTime;
            float _LuminosityAmount;

            // application to vertex
            // 由应用程序传递给顶点函数
            struct a2v {
                float4 vertex:POSITION;
                float3 normal:NORMAL; // 切线空间的确定是通过(存储模型里的)法线和(存储模型里的)切线确定的，所以需要模型的法线
                float4 texcoord:TEXCOORD0; // 模型的纹理坐标
                float4 tangent:TANGENT;// 模型空间的切线
            };

            // vertex to fragment
            // 由顶点函数传递给片元函数
            struct v2f {
                float4 svPos:SV_POSITION;
                float4 uv:TEXCOORD0; // uv.xy 存储MainTex的纹理坐标,uv.zw 存储法线贴图的纹理坐标
            };

            v2f vert(a2v v) {
                v2f f;

                f.svPos = UnityObjectToClipPos(v.vertex);
                // 将MainTex纹理坐标赋值给v2f.uv.xy并赋值面板贴图的旋转缩放
                f.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                // 将法线贴图纹理坐标赋值给v2f.uv.zw并赋值面板贴图的旋转缩放
                f.uv.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;

                // 调用这个宏之后，会得到一个矩阵 rotation
                // 这个矩阵用来把模型空间下的方向转换成切线空间下
                TANGENT_SPACE_ROTATION;
                    
                return f;
            }

            float4 frag(v2f f) : Color{

               // tex2D 根据法线贴图的纹理坐标获取颜色值
                fixed4 normalColor = tex2D(_NormalMap,f.uv.zw);

                // 切线空间下的法线
                half2 bump = UnpackNormal(normalColor).rg;

                //屏幕中心坐标
				float2 centerPoint = float2(_ScreenParams.x /2, _ScreenParams.y /2);  
                float dis = distance(f.svPos.xy , centerPoint);

                //使用时间产生向外扩散的效果
                float isInFlow = step(dis / _Time.y, 500);
                //法线的深度随时间增大，直到到达临界时间time为止
                fixed hasReachTime = step(_DepthTime, _Time.y);
                 
                f.uv.xy += bump * 0.5 * isInFlow * ((1 - hasReachTime) * _Time.y + hasReachTime);

                //控制灰度
                fixed4 col = tex2D(_MainTex, f.uv.xy);
                fixed lum = Luminance(col);
                return lerp(col, lum, _LuminosityAmount);
            }

            ENDCG
        }
    }

    Fallback "VertexLit"
}