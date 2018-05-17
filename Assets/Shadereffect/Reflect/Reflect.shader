//使用CubeMap进行环境反射
//CubeMap通过CubeMapGen.cs脚本制作
Shader "Effect/Reflect"{
    Properties {
        _MainTex ("Image Sequence", 2D) = "white" {}
        _CubeMap ("CubeMap", CUBE) = "" {}
        _ReflectAmount ("Reflect Amount", Range(0.01, 1)) = 0.5
    }

    SubShader {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True"}
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        samplerCUBE _CubeMap;
        float _ReflectAmount;
        
        struct Input {  
            float2 uv_MainTex;
            //世界空间的反射向量, 这里是surface shader的内置变量
            float3 worldRefl;
        };  

        UNITY_INSTANCING_CBUFFER_START(Props)
        // put more per-instance properties here
        UNITY_INSTANCING_CBUFFER_END

        void surf (Input IN, inout SurfaceOutputStandard o) 
        {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            //texCUBE提供新的世界反射向量
            o.Emission = texCUBE(_CubeMap, IN.worldRefl).rgb * _ReflectAmount; 
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
            
        ENDCG 
    }
    FallBack "Diffuse"
}