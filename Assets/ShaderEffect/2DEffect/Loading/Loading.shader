// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect/2D/Loading"  
{  
    Properties  
    {  
        _Color ("Color", Color) = (0, 1, 0, 1)  
        _Speed ("Speed", Range(1, 10)) = 5 
        _Radius ("Radius", Range(0, 0.5)) = 0.3  
    }  
    SubShader  
    {  
        Tags { "Queue" = "Transparent" }  
        Blend SrcAlpha OneMinusSrcAlpha  
        ZWrite Off  
  
        Pass  
        {  
            CGPROGRAM  
            #pragma vertex vert  
            #pragma fragment frag  
            #include "UnityCG.cginc"  
 
            #define PI 3.14159  
  
            struct appdata  
            {  
                float4 vertex : POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            struct v2f  
            {             
                float4 vertex : SV_POSITION;  
                float2 uv : TEXCOORD0;  
            };  
  
            fixed4 _Color;  
            half _Speed;  
            fixed _Radius;  

            //画圆
            fixed4 circle(float2 uv, float2 center, float radius)  
            {  
                //在半径范围内就可以显示
                fixed show = step(length(uv - center), radius);
                return show * _Color;
            }  
  
            v2f vert (appdata v)  
            {  
                v2f o;  
                o.vertex = UnityObjectToClipPos(v.vertex);  
                o.uv = v.uv;  
  
                return o;  
            }  


            /*实现一个圆绕中心点运动，原理：随着时间的流逝，起始边固定，
            而另一条边不断地移动，弧度从0到2*PI，只需求出移动边与圆边的交点，然后画圆即可。至于这个交点，因为圆心的uv为(0.5,0.5)，所以交点的坐标就是(0.5 - r * cos(a) , 0.5 + r * sin(a))。*/
            fixed4 frag (v2f i) : SV_Target  
            {  
                fixed4 finalCol = (0, 0, 0, 0);  

                //画6个从大到小的圆
                for(int count = 7; count > 1; count--)  
                {  
                    //每个圆之间的间隙
                    half interval = count * 0.5;
                    //fmod(x, y) Returns the floating point remainder of x/y.
                    half radian = fmod(_Time.y * _Speed + interval, 2 * PI);//弧度  
                    //根据弧度实时计算圆的中心位置
                    half2 center = half2(0.5 - _Radius * cos(radian), 0.5 + _Radius * sin(radian));   
  
                    finalCol += circle(i.uv, center, count * 0.01);  
                }  
  
                return finalCol;  
            }  
            ENDCG  
        }  
    }  
}  