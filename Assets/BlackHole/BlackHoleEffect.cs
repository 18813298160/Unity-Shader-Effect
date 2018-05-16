using UnityEngine;

/// <summary>
/// 黑洞效果（结合BlackHole.shader）
/// </summary>
public class BlackHoleEffect : MonoBehaviour
{
    /// <summary>
    /// 黑洞物体
    /// </summary>
    public Transform blackHole;

    /// <summary>
    /// 使用球体进行测试，所以有半径
    /// </summary>
    private float radius;

    /// <summary>
    /// 附加的材料
    /// </summary>
    private Material mat;
    /// <summary>
    /// shader中的属性
    /// </summary>
	private static int TopYID = -1;
	private static int BottlmYID = -1;
	private static int ControlID = -1;
	private static int BlackHolePosID = -1;

    private Vector4 blackHolePos = new Vector4();

    private float ctrl = 0;

    void Awake()
    {
        mat = GetComponent<MeshRenderer>().material;
        if (mat == null)
        { 
            Debug.LogError("no material");
            return; 
        }

		TopYID = Shader.PropertyToID("_TopY");
		BottlmYID = Shader.PropertyToID("_BottomY");
		ControlID = Shader.PropertyToID("_Control");
		BlackHolePosID = Shader.PropertyToID("_BlackHolePos");

        radius = GetComponent<SphereCollider>().radius;
		float topPosY = transform.position.y + radius;
		float bottomPosY = transform.position.y - radius;

		mat.SetFloat(TopYID, topPosY);
		mat.SetFloat(BottlmYID, bottomPosY);

        if (blackHole != null)
        {
            blackHolePos = blackHole.transform.position;
            blackHolePos.w = 1;
            mat.SetVector(BlackHolePosID, blackHolePos);
        }
    }

	void Update ()
    {
		if (mat == null)
		{
			return;
		}

        if (ctrl <= 2)
        {
            ctrl += Time.deltaTime;
            mat.SetFloat(ControlID, ctrl);
        }
	}

}
