using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//运动模糊，注意必须是摄像机进行运动，而物体不移动才有运动模糊的效果，原因会在shader中分析
public class MotionBlur : RenderImageEffect
{

    public float blurSize = 2;

	/// <summary>
	/// 上一帧摄像机的视角 * 投影矩阵  
	/// </summary>
	private Matrix4x4 preViewProjectionMat;

	private Camera cam;

    public Camera selfCamera
    {
        get
        {
            if (!cam)
                cam = GetComponent<Camera>();
            return cam;
        }
    }

    void OnEnable()
    {
        //获取深度图
        selfCamera.depthTextureMode = DepthTextureMode.Depth;
    }

    public override void SetShaderProperties()
    {
        mat.SetFloat("_BlurSize", blurSize);

		//传递上一帧摄像机的视角 * 投影矩阵
		mat.SetMatrix("_PreViewProjectionMat", preViewProjectionMat);

		//计算当前帧的视角 * 投影矩阵  
		//Camera.projectionMatrix获得当前摄像机投影矩阵  
		//Camera.worldToCameraMatrix获得当前摄像机视角矩阵 
		Matrix4x4 curViewProjectionMat = selfCamera.projectionMatrix * selfCamera.worldToCameraMatrix;
        Matrix4x4 curViewProjectionInverseMat = curViewProjectionMat.inverse;

		//传递当前帧的视角 * 投影矩阵
		mat.SetMatrix("_CurViewProjectionInverseMat", curViewProjectionInverseMat);

		//更新前一帧的视角 * 投影矩阵
		preViewProjectionMat = curViewProjectionMat;
	}
}
