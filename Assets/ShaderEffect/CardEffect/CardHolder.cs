using System.Collections;
using UnityEngine;
using System;

public class CardHolder : MonoBehaviour
{
    private Material mat;
    private float percent = -0.3f;
    public float waitTime = 2;
    void Awake()
    {
        StartCoroutine(wait(() =>
        {
            mat = GetComponent<Renderer>().material;
        }));
	}

    IEnumerator wait(Action cb = null)
    {
        yield return new WaitForSeconds(waitTime);
        if (cb != null)
            cb.Invoke();
    }
	
	// Update is called once per frame
	void Update () 
    {
        if (!mat) return;
        percent += 0.03f * (1 - percent);
        percent = Mathf.Clamp(percent, 0, 1);
        mat.SetFloat("_percent", percent);        
	}
}
