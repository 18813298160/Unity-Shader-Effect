Shader "Effect/EraseBg" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}//目标图片
        _Cutoff("Alpha cutoff",Range(0,0.9)) = 0
    }
    SubShader {
        Tags { 
            "Queue"="Transparent" 
        }//渲染队列设置为  以从后往前的顺序渲染透明物体
        Lighting off //关闭光照
        ZWrite off //关闭深度缓存
        /*方法1
        Blend off //关闭混合
        //启用alpha测试, GEqual代表仅渲染alpha >= _Cutoff的像素
        //使用alpha测试，边缘会有较强的锯齿感
        AlphaTest GEqual[_Cutoff] 
        */

        Pass{
        //方法2， 使用Alpha Blend
            Blend SrcAlpha OneMinusSrcAlpha
            SetTexture[_MainTex]{combine texture}
        } 
    }
}