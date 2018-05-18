using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenBroken : RenderImageEffect {

    public Texture2D normalMap;
    public float depthTime;
    /// <summary>
    /// 灰度设置
    /// </summary>
    public float LuminosityAmount;

    private float cachedDepthTime = 1;

    private void Awake()
    {
        cachedDepthTime = depthTime;
    }

    public override void SetShaderProperties()
    {
        base.SetShaderProperties();
        if (normalMap)
        {
            mat.SetFloat("_LuminosityAmount", LuminosityAmount);
            mat.SetFloat("_DepthTime", cachedDepthTime);
            mat.SetTexture("_NormalMap", normalMap);
        }
	}
}
