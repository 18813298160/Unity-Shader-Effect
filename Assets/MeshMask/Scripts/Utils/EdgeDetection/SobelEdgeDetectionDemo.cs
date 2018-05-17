using System;
using System.Collections.Generic;
using System.IO;
using mattatz.Triangulation2DSystem;
using mattatz.Triangulation2DSystem.Example;
using UnityEngine;
using System.Collections;
using UnityEngine.SocialPlatforms;
using UnityEngine.UI;

public class SobelEdgeDetectionDemo : MonoBehaviour
{
    public float alphaThreshold = 0.9f;

    public Texture2D sourceTexture;
    [HideInInspector]
    public Texture2D targetTexture;



    private List<Vector2> convexHull;

    public bool debug;

	// Use this for initialization
	void Start ()
	{
        SobelEdgeDetection sobel = new SobelEdgeDetection();
        targetTexture = sobel.Detect(sourceTexture, alphaThreshold);

        byte[] bytes = targetTexture.EncodeToPNG();
        File.WriteAllBytes(Application.dataPath + "/Resources/Textures/target_texture" + ".png", bytes);

        convexHull = EdgeUtil.GetPoints(targetTexture);
        this.GetComponent<Demo>().SetPointsAndBuild(convexHull);

        GameObject.DestroyImmediate(targetTexture);
	}

    void Update()
    {
        if (debug)
        {
            if (convexHull != null)
            {
                int j;
                for (int i = 0; i < convexHull.Count; i++)
                {
                    j = (i + 1) % convexHull.Count;
                    Debug.DrawLine(new Vector3(convexHull[i].x, convexHull[i].y, 0), new Vector3(convexHull[j].x, convexHull[j].y, 0), Color.red);
                }
            }
        }
        
    }

}
