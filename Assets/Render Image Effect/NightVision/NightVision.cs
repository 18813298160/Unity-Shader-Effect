using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//参考 https://blog.csdn.net/candycat1992/article/details/39482593
public class NightVision : RenderImageEffect
{
	public float contrast = 2.0f;
	public float brightness = 1.0f;
	public Color nightVisionColor = Color.white;

	public Texture2D vignetteTexture;

	public Texture2D scanLineTexture;
	public float scanLineTileAmount = 4.0f;

	public Texture2D nightVisionNoise;
	public float noiseXSpeed = 100.0f;
	public float noiseYSpeed = 100.0f;

	public float distortion = 0.2f;
	public float scale = 0.8f;

	private float randomValue = 0.0f;

	public override void Start()
	{
		base.Start();
	}

	public override void Update()
	{
		base.Update();
		contrast = Mathf.Clamp(contrast, 0.0f, 4.0f);
		brightness = Mathf.Clamp(brightness, 0.0f, 2.0f);
		distortion = Mathf.Clamp(distortion, -1.0f, 1.0f);
		scale = Mathf.Clamp(scale, 0.0f, 3.0f);
		randomValue = Random.Range(-1.0f, 1.0f);
	}

	public override void SetShaderProperties()
	{
		base.SetShaderProperties();
		mat.SetFloat("_Contrast", contrast);
		mat.SetFloat("_Brightness", brightness);
		mat.SetColor("_NightVisionColor", nightVisionColor);
		mat.SetFloat("_RandomValue", randomValue);
		mat.SetFloat("_Distortion", distortion);
		mat.SetFloat("_Scale", scale);

		if (vignetteTexture)
		{
			mat.SetTexture("_VignetteTex", vignetteTexture);
		}

		if (scanLineTexture)
		{
			mat.SetTexture("_ScanLineTex", scanLineTexture);
			mat.SetFloat("_ScanLineTileAmount", scanLineTileAmount);
		}

		if (nightVisionNoise)
		{
			mat.SetTexture("_NoiseTex", nightVisionNoise);
			mat.SetFloat("_NoiseXSpeed", noiseXSpeed);
			mat.SetFloat("_NoiseYSpeed", noiseYSpeed);
		}
	}
}
