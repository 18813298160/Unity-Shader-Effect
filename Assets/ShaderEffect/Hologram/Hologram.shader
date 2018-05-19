// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

//全息投影
//来源 ：http://www.xshadow.org/index.php/archives/125
Shader "Effect/Hologram" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _ColorScale ("Scale", Float) = 1 
        _ScaningAmount ("Scaning Amount", Float) = 10
        _ScaningSpeed ("Scaning Speed", Float) = 1
        _SplashLevel ("Splash Level", Range(0, 1)) = 0
        _SplashFrequency ("Splash Frequency", Float) = 1
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
        LOD 300
 
        CGINCLUDE
        #include "UnityCG.cginc"
 
        fixed4 _Color;
        float _ColorScale;
        float _ScaningAmount;
        float _ScaningSpeed;
        fixed _SplashLevel;
        float _SplashFrequency;
 
        struct v2f {
            float4 pos : SV_POSITION;
            float4 srcPos : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
            float3 worldViewDir : TEXCOORD2;
        };
 
        v2f vert(appdata_base v) {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.srcPos = ComputeScreenPos(o.pos);
            o.worldNormal = UnityObjectToWorldNormal(v.normal);
            o.worldViewDir = UnityWorldSpaceViewDir(v.vertex);
            return o;
        }
 
        fixed4 frag(v2f i) : SV_TARGET {
            fixed3 worldNormal = normalize(i.worldNormal);
            fixed3 worldViewDir = normalize(i.worldViewDir);
 
            // 视线和法线越平行，看到的全息投影越亮
            fixed3 hologram = _Color.rgb * abs(dot(worldNormal, worldViewDir)) * _ColorScale;
 
            // 计算扫描线的亮暗
            float t = _Time.y;
            fixed tDecimal = t - floor(t);
            float splashFrequency = tDecimal * _SplashFrequency;
 
            half y = (i.srcPos.y * _ScaningAmount) / i.srcPos.w + tDecimal * _ScaningSpeed;
            half scaninglineY = floor(y);
            half scaningScale = lerp(0, 1, abs((y - scaninglineY) - 0.5) * 2);
 
            fixed4 finalColor = fixed4(hologram, _Color.a * scaningScale * lerp(1 - _SplashLevel, 1, splashFrequency - floor(splashFrequency)));
            return finalColor;
        }
 
        ENDCG
 
        Pass {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha 
            Cull Front
 
            CGPROGRAM
 
            #pragma vertex vert
            #pragma fragment frag
 
            ENDCG
        }
 
        Pass {
            ZWrite Off
            Blend SrcAlpha One
            Cull Back
 
            CGPROGRAM
 
            #pragma vertex vert
            #pragma fragment frag
 
            ENDCG
        }
    }
}