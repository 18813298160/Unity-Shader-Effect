using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Cooling : MonoBehaviour {

    public bool isUi = true;
    private Material mat;
    private float angle = 0;
	// Use this for initialization
	void Awake ()
    {
        if(!isUi)
            mat = GetComponent<MeshRenderer>().material;
        else
            mat = GetComponent<Image>().material;
        angle = 0;
    }

    // Update is called once per frame
    void Update ()
    {
        angle += 1f;
        if (angle > 359) angle = 0;
        mat.SetFloat("_Angle", angle);
    }
}
