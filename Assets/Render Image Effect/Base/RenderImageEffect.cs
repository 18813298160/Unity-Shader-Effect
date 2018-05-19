using UnityEngine;

/// <summary>
/// 负责在编辑中实时更新图像，同时也负责从主摄像机抓取render texture，然后把该texture传递给Shader。
/// 基类型，各种具体的特效在具体子类中实现
/// </summary>
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class RenderImageEffect : MonoBehaviour {

	/*在片段着色器（或者说顶点着色器）中对每个像素单独做计算是非常耗性能的。
	 * 如果想让shader以一个流畅运行的帧率来展现的话，一个比较通用的做法是
	 * 将片段着色器中的像素缩小到一个合适的比率，再通过放大到屏幕比例的方式
	 * 来减少计算量。
    */
	public int horizontalResolution = 320;
	public int verticalResolution = 240;
    /// <summary>
    /// 是否进行优化
    /// </summary>
    public bool useScaledMode = true;
    /// <summary>
    /// 需要的Shader
    /// </summary>
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

    public void Start()
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

        OnStart();
	}

    public virtual void OnStart()
    {
        //Do something.
    }
	
    public virtual void Update() 
    {

	}

	void OnDisable()
	{
		if (curMat)
			DestroyImmediate(curMat);
	}

	/// <summary>
	/// 使用内置的OnRenderImage实现画面特效
	/// 配合Blit函数实现屏幕后处理，OnRenderImage可抓取当前的Render Texture，
    /// 通过Blit传递给Shader，再将处理后的图像回传给Unity渲染器
	/// </summary>
	/// <param name="source">Source.</param>
	/// <param name="destination">Destination.</param>
    public virtual void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
		//source会成为mat的_MainTex
		if(curShader)
        {
			SetShaderProperties();
            if (useScaledMode)
            {
                RenderTexture scaled = RenderTexture.GetTemporary(horizontalResolution, verticalResolution);
                Graphics.Blit(source, scaled, mat);
                Graphics.Blit(scaled, destination);
                RenderTexture.ReleaseTemporary(scaled);
            }
            else
            {
				Graphics.Blit(source, destination, mat);
            }
            return;
        }

        Graphics.Blit(source, destination);
    }

	/// <summary>
    /// 用于设置shader相关属性
	/// 简单操作时直接重写此函数即可，若操作较复杂，可直接重写OnRenderImage函数
	/// </summary>
	public virtual void SetShaderProperties()
    {
        
    }
}
