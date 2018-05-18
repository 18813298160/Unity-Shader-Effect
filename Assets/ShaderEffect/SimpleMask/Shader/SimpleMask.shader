//通过shader简单的遮罩

Shader "Effect/Mask" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}//目标图片，即需要被遮罩的图片
        _MaskLayer("Culling Mask",2D) = "white"{}//混合的图片，设置为白色的图片，任何颜色与白色混合，其颜色不变
        _Cutoff("Alpha cutoff",Range(0,1)) = 0
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
        /*
        这里要注意.在一个SetTextrue 中我们只能对一个texture来操作. 所以在混合前
        我们需要先用一个SetTexture 将第一张图贴上去.
        然后再用 combine texture,previous .将第二张与之前的(previous)来混合.
        */

            //方法2， 使用Alpha Blend
            Blend SrcAlpha OneMinusSrcAlpha
        
            SetTexture[_MaskLayer]{combine texture}//混合贴图
            //混合贴图，previous为放置在前一序列这样在进行AlphaTest的时候会以这个图片为主来进行混合
            SetTexture[_MainTex]{combine texture,previous}
        } 
    }
}