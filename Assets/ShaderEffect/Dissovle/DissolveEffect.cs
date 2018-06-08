using UnityEngine;

/// <summary>
/// Chicken死亡溶解控制
/// </summary>
public class DissolveEffect : MonoBehaviour 
{
    /// <summary>
    /// 新的shader
    /// </summary>
    public Shader curShader = null;
    /// <summary>
    /// 噪声贴图
    /// </summary>
    public Texture noiseTexture;
	/// <summary>
	/// 溶解控制值
	/// </summary>
	private float amount;

    private Material mat;
	private int DissolveID;
	private int noiseTexID;
    private bool StartDissolve;

    void Awake()
    {
        amount = 0;
        StartDissolve = false;
		DissolveID = Shader.PropertyToID("_Amount");
		noiseTexID = Shader.PropertyToID("_NoiseTex");

		mat = GetComponentInChildren<SkinnedMeshRenderer>().sharedMaterial;
        mat.shader = curShader ? curShader : Shader.Find("Effect/Dissolve");
        if (!noiseTexture)
        {
            Debug.LogError("还没选择溶解（噪声）贴图！");
            return;
        }
        mat.SetTexture(noiseTexID, noiseTexture);
    }

    void Update()
    {
        if (!StartDissolve || !noiseTexture) return;
        amount += 0.02f;
        amount = Mathf.Clamp01(amount);
        mat.SetFloat(DissolveID, amount);
    }

    /// <summary>
    /// 执行溶解
    /// </summary>
    void CommitDissolve()
    {
        StartDissolve = true;
    }

    void OnDisable()
    {
		mat.SetFloat(DissolveID, 0);
	}

    private void OnGUI()
    {
        if(GUI.Button(new Rect(100, 100, 100, 50),"溶解测试"))
        {
            CommitDissolve();
        }
    }

}
