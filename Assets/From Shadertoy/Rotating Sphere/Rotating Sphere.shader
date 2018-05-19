// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shadertoy/Rotating Sphere" { //see https://www.shadertoy.com/view/4sj3zy  
    Properties {  
        _MainTex ("Base (RGB)", 2D) = "white" {}  
    }  
    SubShader {  
        Pass {  
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
            #pragma target 3.0  
              
            #include "UnityCG.cginc"  
  
            sampler2D _MainTex;  
          
            //Variable declarations  
              
            struct myvars {  
                float3 bgColor;  
                float sphereScale;  
                float sphereShine;  
                float3 sphereDiff;  
                float3 sphereSpec;  
                float2 specPoint;  
            };  
  
            float4 vert(appdata_base v) : POSITION {  
                return UnityObjectToClipPos(v.vertex);  
            }  
              
            float4 frag(float4 sp:WPOS): COLOR {  
                myvars mv;  
                mv.bgColor = float3(0.6, 0.5, 0.6);  
                mv.sphereScale = 0.7;  
                mv.sphereShine = 0.5;  
                mv.sphereDiff = float3(0.5, 0.0, 0.5);  
                mv.sphereSpec = float3(1.0, 1.0, 1.0);  
                mv.specPoint = float2(0.2, -0.1);  
              
                // creates shader pixel coordinates  
                float2 uv = sp.xy/_ScreenParams.xy;  
                // sets the position of the camera  
                float2 p = uv * 2.5 - float2(1.0, 1.0);  
                p.x *= _ScreenParams.x / _ScreenParams.y;  
                  
                // Rotates the sphere in a circle  
                p.x += cos(-_Time.y) *0.35;  
                p.y += sin(-_Time.y) * 0.35;  
                  
                // Rotates the specular point with the sphere  
                mv.specPoint.x += cos(-_Time.y) * 0.35;  
                mv.specPoint.y += sin(-_Time.y) * 0.35;  
                  
                //Sets the radius of the sphere to the middle of the screen  
                float radius = length(p);//sqrt(dot(p, p));  
      
                float3 col = mv.bgColor;  
      
                //Sets the initial dark shadow around the edge of the sphere  
                float f = smoothstep(mv.sphereScale * 0.7, mv.sphereScale, length(p + mv.specPoint));  
                col -= lerp(col, float3(0.0,0.0,0.0), f) * 0.2;  
                  
                //Only carries out the logic if the radius of the sphere is less than the scale  
                if(radius < mv.sphereScale) {  
                    float3 bg = col;  
                      
                    //Sets the diffuse colour of the sphere (solid colour)  
                    col = mv.sphereDiff;  
                      
                    //Adds smooth dark borders to help achieve 3D look  
                    f = smoothstep(mv.sphereScale * 0.7, mv.sphereScale, radius);  
                    col = lerp(col, mv.sphereDiff * 0.45, f);  
                      
                    //Adds specular glow to help achive 3D look  
                    f = 1.0 - smoothstep(-0.2, 0.6, length(p - mv.specPoint));  
                    col += f * mv.sphereShine * mv.sphereSpec;  
                  
                    //Smoothes the edge of the sphere  
                    f = smoothstep(mv.sphereScale - 0.01, mv.sphereScale, radius);  
                    col = lerp(col, bg, f);  
                }  
                  
                  
                //The final output of the shader logic above  
                //gl_FragColor is a vector with 4 paramaters(red, green, blue, alpha)  
                //Only 2 need to be used here, as "col" is a vector that already carries r, g, and b values  
                return float4(col, 1);  
            }  
              
            ENDCG  
        }  
    }   
    FallBack "Diffuse"  
}  