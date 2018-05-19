using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenRotating : RenderImageEffect {
    public float twist;

	public override void Update()
	{
        if (!Application.isPlaying) return;
        twist += (50 - twist) * 0.018f + 0.02f;
        twist = Mathf.Clamp(twist, 0, 50);
	}

    public override void SetShaderProperties()
    {
        base.SetShaderProperties();
        useScaledMode = false;
        mat.SetFloat("_Twist", twist);
    }
}
