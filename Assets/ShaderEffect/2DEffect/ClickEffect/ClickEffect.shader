    Shader "Effect/2D/ClickStyle" {
        Properties {
            [PerRendererData]_MainTex("Sprite Texture",2D)="white"{}
            [HideInInspector]_StartTime("Start Time",Float)=0  //起始时间，在Ripple中设置
            _AnimationTime("AnimationTime",Range(0.1,10.0))=1.5 //动画时间
            _Width("Width",Range(0.1,3.0))=0.3   //内圆和外圆形成环的宽度
            _StartWidth("Start Width",Range(0,1.0))=0.3  //内圆的默认直径，注意这里是按照uv尺寸走的，最大也就是1
            [Toggle]_isAlpha("isAlpha",Float)=1   //是否开启透明度插值
            [MaterialToggle]PixelSnap("Pixe Snap",Float)=1
        }
        SubShader {

            //启用透明混合，不然没有透明效果
            Tags{"Queue"="Transparent" "RenderType"="Transparent"}
            Blend SrcAlpha OneMinusSrcAlpha

            Pass
            {
                CGPROGRAM
                #pragma target 3.0
                #pragma vertex vert 
                #pragma fragment frag 
                #include "UnityCG.cginc"

                struct v2f
                {
                     float4 vertex : SV_POSITION;
                     float2 texcoord : TEXCOORD0;
                };

                sampler2D _MainTex;
                float _StartTime;
                float _AnimationTime;
                float _StartWidth;
                float _Width;
                float _isAlpha;

                v2f vert(appdata_base IN)
                {
                    v2f OUT;
                    OUT.vertex=UnityObjectToClipPos(IN.vertex);
                    OUT.texcoord=IN.texcoord;
                    return OUT;
                }

                fixed4 frag(v2f IN) : SV_Target
                {
                    fixed4 color = tex2D(_MainTex, IN.texcoord);
                    //计算像素点到中心的距离，乘以2近似代表圆的直径
                    half2 pos = (IN.texcoord - float2(0.5, 0.5)) * 2;
                     
					//如果指定内径开始向外扩散 ,在Ripple类中 已经减去了开始长度的时间。所以这里就不用再减了
					half timeIncreaseMent = (_Time.y - _StartTime) / _AnimationTime;
					half dis = timeIncreaseMent + _StartWidth - length(pos);
                    
                    float alpha = 1;
                    //如果开启了透明度渐变就让透明度进行插值(这里进行了优化，不用if语句)
                    alpha = _isAlpha * clamp((_Width - dis) * 3, 0.1, 1.5) + alpha * (1 - _isAlpha);

                    //大于最大宽度以及小于0都去掉这部分像素
                    //环内：dis > _Width
                    //环外：dis < 0
                    //可保留的部分，[0, width]
                    //step(a, x) : Returns (x >= a) ? 1 : 0
                    fixed canStay = step(0, dis) * step(dis, _Width);
                    alpha *= canStay;

                    return fixed4(color.rgb, color.a * alpha);
                }


                ENDCG
            }
        }
    }