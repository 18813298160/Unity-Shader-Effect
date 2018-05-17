using UnityEngine;  
using UnityEditor;  
using System.Collections;  
  
public class CubeMapGen : ScriptableWizard
{
	[MenuItem("Tool/Render Cubemap")]
	static void RenderCubemap()
	{
		ScriptableWizard.DisplayWizard("Render CubeMap", typeof(CubeMapGen), "Render!");
	}

	public Transform renderPosition;
	public Cubemap cubemap;

	void OnWizardUpdate()
	{
		if (renderPosition != null && cubemap != null)
		{
			isValid = true;
		}
		else
		{
			isValid = false;
		}
	}

	void OnWizardCreate()
	{
		GameObject go = new GameObject("CubeCam", typeof(Camera));

		go.transform.position = renderPosition.position;
		go.transform.rotation = Quaternion.identity;

        go.GetComponent<Camera>().RenderToCubemap(cubemap);

		DestroyImmediate(go);
	}
}