using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//屏幕灰度处理
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class GrayCtrl : RenderImageEffect {
    
    /// <summary>
    /// 用于控制灰度值
    /// </summary>
    public float grayScaleAmount = 0;

    public override void Start ()
    {
        base.Start();
	}
	
    public override void Update () 
    {
        base.Update();
        grayScaleAmount += Time.deltaTime;
        grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
	}

   public override void SetShaderProperties()
    {
        base.SetShaderProperties();
		mat.SetFloat("_LuminosityAmount", grayScaleAmount);
    }
}
