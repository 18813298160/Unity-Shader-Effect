//动态变色
/*通过坐标的值来判断fragment 返回不同的颜色值。需要注意的是模型的坐标通常是［－0.5，0.5］的范围内的，
然后通过lerp函数来进行颜色的融合相加。不建议通过if else等判断语句来完成，效率不高
*/
Shader "Effect/TransitionColor" {
    Properties {
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
 
        _UpColor("UpColor",color) = (1,0,0,1)
        _DownColor("DownColor",color) = (0,1,0,1)
        _Center("Center",range(-0.5,0.5)) = 0
        _R("R",range(0,0.5)) = 0.2
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
         
        CGPROGRAM
        #pragma surface surf Standard vertex:vert fullforwardshadows
        //说明：pragma surface method1 Standard vertex:method2 fullforwardshadows
         
        #pragma target 3.0
 
        sampler2D _MainTex;
 
        struct Input {
            float2 uv_MainTex;
            float x:TEXCOORD0;
        };
 
        half _Glossiness;
        half _Metallic;
 
        float4 _UpColor;
        float4 _DownColor;
        float _Center; 
        float _R; 
 
        void vert(inout appdata_full v,out Input o){
            o.uv_MainTex = v.texcoord.xy;
            o.x = v.vertex.x;
        }
 
        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            // 融合带, 如果为正值则第一种颜色，否则负值就是第二种颜色  
            float d = IN.x - _Center;
            float s = abs(d);
            d = d/s;//,结果只能是1或-1，正负值分别描述上半部分和下半部分
 
            float f = s/_R; //范围>1：表示上下部分;范围<1:表示融合带
            //Clamps f to the range [0, 1]
            f = saturate(f);
            d *= f;//表示全部[-1,1];范围>1：表示上部分；范围<1:表示融合带;范围<-1:表示下部分
                 
            d = d/2+0.5;//将范围控制到[0,1],因为颜色值返回就是[0,1]

            //for testing, 这样做，就可以出现模型的颜色对半分了
            //float test = IN.x > 0 ? 0.1 : 0.5;
            //o.Albedo = lerp(_UpColor,_DownColor, tt);

            o.Albedo = lerp(_UpColor,_DownColor, d);
        }
        ENDCG
    }
    FallBack "Diffuse"
}