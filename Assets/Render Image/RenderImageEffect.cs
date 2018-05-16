using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 负责在编辑中实时更新图像，同时也负责从主摄像机抓取render texture，然后把该texture传递给Shader。
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class RenderImageEffect : MonoBehaviour {

    public Shader curShader;
    /// <summary>
    /// 需要的材质
    /// </summary>
    private Material curMat;

    public Material mat
    {
        get
        {
            if (curMat == null)
            {
                curMat = new Material(curShader);
                curMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMat;
        }
    }

    public virtual void Start()
    {
        //平台是否支持画面特效
        if(!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        //是否支持此shader
        if(curShader != null && !curShader.isSupported)
        {
            enabled = false;
        }
	}
	
    public virtual void Update() 
    {

	}

	/// <summary>
	/// 使用内置的OnRenderImage实现画面特效
	/// 配合Blit函数实现屏幕后处理，OnRenderImage可抓取当前的Render Texture，
    /// 通过Blit传递给Shader，再将处理后的图像回传给Unity渲染器
	/// </summary>
	/// <param name="source">Source.</param>
	/// <param name="destination">Destination.</param>
	void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if(curShader)
        {
            SetShaderProperties();
			//source会成为mat的_MainTex
			Graphics.Blit(source, destination, mat);
            return;
        }

        Graphics.Blit(source, destination);
    }

    public virtual void SetShaderProperties()
    {
        
    }

    void OnDisable()
    {
        if (curMat)
            DestroyImmediate(curMat);
    }
}
