//黑洞效果
//顶点的移动方向为向某个点（黑洞的位置）
Shader "Effect/BloackHole"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //物体的y坐标上限
        _TopY("Top Y", Float) = 0
        //物体的y坐标下限
        _BottomY("Bottom Y", Float) = 0 
        //控制条
        _Control("Control Squash", Range(0, 2)) = 0
        //黑洞坐标
        _BlackHolePos("Position of the Black Hole", Vector) = (0, 0, 0, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _TopY;
            float _BottomY;
            float _Control;
            float4 _BlackHolePos;

            //对所有顶点的Y坐标进行归一化
            float GetNormalizedDist(float worldPosY)
            {
                float range = _TopY - _BottomY;
                float border = _TopY;

                float dist = abs(worldPosY - border);
                //saturate(x) Clamps x to the range [0, 1]
                float normalizedDist = saturate(dist / range);
                return normalizedDist;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 toBlackHolePos = mul(unity_WorldToObject, (_BlackHolePos - worldPos)).xyz;
                float normalizedDist = GetNormalizedDist(worldPos.y);
                float val = max(0, _Control - normalizedDist);
                v.vertex.xyz += toBlackHolePos * val;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                //clip(x) Discards the current pixel, if any component of x is less than zero.
                //过滤超过黑洞的部分
                clip(_BlackHolePos.y - i.worldPos.y);
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}