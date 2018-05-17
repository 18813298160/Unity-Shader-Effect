using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BasicFix : RenderImageEffect
{
    public Texture blendTex;
    [Range(0, 1)]
    public float opacity = 0.5f;

	public override void Start()
	{
		base.Start();
	}

	public override void Update()
	{
        opacity = Mathf.Clamp(opacity, 0.0f, 1.0f);
	}

	public override void SetShaderProperties()
	{
		base.SetShaderProperties();
        mat.SetTexture("_BlendTex", blendTex); 
		mat.SetFloat("_Opacity", opacity);
	}
}
