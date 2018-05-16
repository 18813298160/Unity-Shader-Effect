using UnityEngine;

//参考：https://blog.csdn.net/stalendp/article/details/40859441
//受击时的屏幕闪烁特效
public class Bloom : RenderImageEffect
{

    public float intensity = 0.5f;
    public Color colorMix = Color.white;
    public float colorMixBlend = 0.25f;
    public float agonyTint = 0;

	public override void Start()
	{
		base.Start();
	}

	public override void Update()
	{
		base.Update();
        agonyTint += 0.1f;
	}

	public override void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
        agonyTint = Mathf.Clamp01(agonyTint - Time.deltaTime * 2.75f);
		//GetTemporary获取临时的RenderTexture, 后期使用ReleaseTemporary来释放，达到复用的效果，提高性能
		//获取两个渲染贴图tmpRtA和tmpRtAB（长宽都是原图的1 / 4，用以加快渲染速度）
		//由于接下来的步骤是对图片进行模糊处理（对质量要求不高），这样做是可行的。
		var tmpRtA = RenderTexture.GetTemporary(source.width / 4, source.height / 4);
		var tmpRtB = RenderTexture.GetTemporary(source.width / 4, source.height / 4);

        mat.SetColor("_ColorMix", colorMix);
        mat.SetVector("_Parameter", new Vector4(colorMixBlend * 0.25f, 0.0f, 0.0f, 1.0f - intensity - agonyTint));

		//最后一个数字参数是用来指代shader的pass, -1表示执行这个shader上所有的pass

		//在目标shader中， pass1 或者 pass5， 提取颜色中最亮的部分；
		//pass2 对高亮图片进行纵向模糊；pass3 对高亮图片进行横向模糊；pass0或pass4；把模糊的图片叠加到原图片上。
		//一个亮点，先经过横向模糊，再经过纵向模糊的过程（可以把这理解为“使一个点向周围扩散的算法”）
		Graphics.Blit(source, tmpRtA, mat, agonyTint < 0.5f ? 1 : 5);
        Graphics.Blit(tmpRtA, tmpRtB, mat, 2);
		Graphics.Blit(tmpRtB, tmpRtA, mat, 3);

		mat.SetTexture("_Bloom", tmpRtA);
        Graphics.Blit(source, destination, mat, 4);

        RenderTexture.ReleaseTemporary(tmpRtA);
        RenderTexture.ReleaseTemporary(tmpRtB);
	}

    private void OnDestroy()
    {
        agonyTint = 1.0f;
    }
}
