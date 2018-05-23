using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScreenPainter : MonoBehaviour
{

	private Vector2 lastPoint;
	private Material paintMat;
	private RenderTexture renderTex;
	public Shader paintShader;
	public Texture brushTex;

	public RawImage PaintBoard;

	private float _paintLerpSize;

	void Awake()
	{

		var brushSize = 300;
		_paintLerpSize = (brushTex.width + brushTex.height) / 2.0f / brushSize;
		lastPoint = Vector2.zero;

		if (paintShader != null)
			paintMat = new Material(paintShader);
		paintMat.SetTexture("_BrushTex", brushTex);
		paintMat.SetFloat("_Size", brushSize);

		renderTex = RenderTexture.GetTemporary(Screen.width, Screen.height, 24);
        if(PaintBoard)
		    PaintBoard.texture = renderTex;
	}

    void Update()
	{
		if (renderTex && paintMat)
		{
			if (Input.GetMouseButton(0))
				LerpPaint(Input.mousePosition);

			if (Input.GetMouseButtonUp(0))
				lastPoint = Vector2.zero;
		}
	}


	/// <summary>
	/// 在update获取的鼠标移动过快，两个点的距离太大会导致绘画不连续，这里就需要插值绘制
	/// </summary>
	/// <param name="point">Point.</param>
	private void LerpPaint(Vector2 point)
	{
		Paint(point);

		if (lastPoint == Vector2.zero)
		{
			lastPoint = point;
			return;
		}

		var dis = Vector2.Distance(point, lastPoint);
		if (dis > _paintLerpSize)
		{
			var dir = (point - lastPoint).normalized;
			var num = (int)(dis / _paintLerpSize);
			for (var i = 0; i < num; i++)
			{
				var newPoint = lastPoint + dir * (i + 1) * _paintLerpSize;
				Paint(newPoint);
			}
		}
		lastPoint = point;
	}

	void Paint(Vector2 point)
	{
		if (point.x < 0 || point.x > Screen.width || point.y < 0 || point.y > Screen.height)
			return;
		if (!paintMat)
			return;
		//获取鼠标的位置计算与屏幕宽高的占比就是对应了图片的uv值
		Vector2 uv = new Vector2(point.x / (float)Screen.width, point.y / (float)Screen.height);
      
		paintMat.SetVector("_UV", uv);
		//将笔刷纹理、颜色绘制到一张RenderTexture保存下来
		Graphics.Blit(renderTex, renderTex, paintMat);
	}

}
