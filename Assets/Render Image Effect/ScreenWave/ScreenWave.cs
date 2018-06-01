using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenWave : RenderImageEffect {

       //距离系数  
    public float distanceFactor = 60.0f;  
    //时间系数  
    public float timeFactor = -30.0f;  
    //sin函数结果系数  
    public float totalFactor = 1.0f;  
  
    //波纹宽度  
    public float waveWidth = 0.6f;  
    //波纹扩散的速度  
    public float waveSpeed = 0.3f;  
  
    private float waveStartTime;  
     
    public override void SetShaderProperties()
    {  
        //计算波纹移动的距离，根据enable到目前的时间*速度求解  
        float curWaveDistance = (Time.time - waveStartTime) * waveSpeed;  
        //设置一系列参数  
        mat.SetFloat("_distanceFactor", distanceFactor);  
        mat.SetFloat("_timeFactor", timeFactor);  
        mat.SetFloat("_totalFactor", totalFactor);  
        mat.SetFloat("_waveWidth", waveWidth);  
        mat.SetFloat("_curWaveDis", curWaveDistance);  
    }  
  
    void OnEnable()  
    {  
        //设置startTime  
        waveStartTime = Time.time;  
    }  
}
