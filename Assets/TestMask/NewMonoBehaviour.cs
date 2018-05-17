using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class NewMonoBehaviour : MonoBehaviour
{
    public Shader curShader;
    private Material mat = null;
	// Use this for initialization
	void Awake()
	{
        if (curShader != null)
            mat = new Material(curShader);
        GetComponent<Image>().material = mat;
        Texture2D curTex = GetComponent<Image>().overrideSprite.texture;
        mat.SetTexture("_MainTex", curTex);
	}

	// Update is called once per frame
	void Update()
	{
			
	}
}
