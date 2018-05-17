/* ==============================================================================
 * 功能描述：自定义MeshMask生成器
 * 创 建 者：shuchangliu
 * ==============================================================================*/

using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using mattatz.Triangulation2DSystem;
using mattatz.Utils;
using UnityEditor.VersionControl;
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class MeshMaskMakerWizard : ScriptableWizard
{
    [MenuItem("Window/MeshMaskMaker")]
    public static void CreateWindow()
    {
        ScriptableWizard.DisplayWizard<MeshMaskMakerWizard>("MeshMaskMaker", "生成");
    }

    /// <summary>
    /// 有序顶点集（用于点击判断）
    /// </summary>
    private List<Vector3> orderedVertices;
    /// <summary>
    /// 顶点集
    /// </summary>
    private List<Vector3> vertices;
    /// <summary>
    /// 三角面片集
    /// </summary>
    private List<int> triangles;

    private Texture2D sourceT2d;
    private Texture2D targetT2d;

    protected override bool DrawWizardGUI()
    {
       // base.DrawWizardGUI();

		GUILayout.Label ("在Project面板选中图片制作MeshMask");

        if (GUILayout.Button("处理选中图片"))
        {
            Object[] objs = Selection.GetFiltered(typeof(Texture), SelectionMode.DeepAssets);
            

            if (objs.Length == 1)
            {
                sourceT2d = objs[0] as Texture2D;

                string path = AssetDatabase.GetAssetPath(sourceT2d.GetInstanceID());

                Regex regex = new Regex(@"^[A-Za-z0-9_]+$$");
                Match ret = regex.Match(sourceT2d.name);
                if (!ret.Success)
                {
                    Debug.LogError("图片名字不符合规范，只能包含英文数字和下划线，请重新命名");
                    return false;
                }
                if (path.IndexOf("MeshMask/RawRes/") == -1)
                {
                    Debug.LogError("请把图片放入MeshMask/RawRes路径内");
                    return false;
                }


                TextureImporter textureImporter = AssetImporter.GetAtPath(path) as TextureImporter;
                TextureImporterSettings cacheSettings = new TextureImporterSettings();
                textureImporter.ReadTextureSettings(cacheSettings);

                //将Texture临时设置为可读写
                TextureImporterSettings tmp = new TextureImporterSettings();
                textureImporter.ReadTextureSettings(tmp);
                tmp.readable = true;
                textureImporter.SetTextureSettings(tmp);
                AssetDatabase.ImportAsset(path);

                SobelEdgeDetection sobel = new SobelEdgeDetection();
                targetT2d = sobel.Detect(sourceT2d);

                List<Vector2> points = EdgeUtil.GetPoints(targetT2d);

                orderedVertices = points.Select(p => { return new Vector3(p.x, p.y, 0); }).ToList();

                Triangulation2D result = TriangulationUtil.GetTriangulation(points);
                vertices = result.GetVertices();
                triangles = result.GetTriangleIndices();

                //顶点归一化
                for (int i = 0; i < vertices.Count; i++)
                {
                    Vector3 vec = vertices[i];
                    vec.x -= targetT2d.width*0.5f;
                    vec.y -= targetT2d.height*0.5f;
                    vec.x /= targetT2d.width;
                    vec.y /= targetT2d.height;
                    vertices[i] = vec;
                }
                for (int i = 0; i < orderedVertices.Count; i++)
                {
                    Vector3 vec = orderedVertices[i];
                    vec.x -= targetT2d.width * 0.5f;
                    vec.y -= targetT2d.height * 0.5f;
                    vec.x /= targetT2d.width;
                    vec.y /= targetT2d.height;
                    orderedVertices[i] = vec;
                }

                //画出预览图
                for (int i = 0; i < sourceT2d.width; i++)
                {
                    for (int j = 0; j < sourceT2d.height; j++)
                    {
                        if (targetT2d.GetPixel(i, j) == Color.clear && sourceT2d.GetPixel(i, j) != Color.clear)
                            targetT2d.SetPixel(i, j, sourceT2d.GetPixel(i, j));
                    }
                }
                targetT2d.Apply();

                //恢复Texture设置
                textureImporter.SetTextureSettings(cacheSettings);
                AssetDatabase.ImportAsset(path);
                AssetDatabase.Refresh();

                Debug.Log("预处理完成");
            }
            else
            {
                Debug.LogError("没有选中任何图片");
            }
        }

        if (targetT2d != null)
        {
            Texture2D atlasTex = EditorGUILayout.ObjectField(targetT2d, typeof(Texture2D), GUILayout.Width(400), GUILayout.Height(400 * targetT2d.height / targetT2d.width)) as Texture2D;
            if (atlasTex != null)
            {
                GUILayout.Label(atlasTex.width + " X " + atlasTex.height);
            }
        }

        return true;
    }

    void OnWizardCreate()
    {
        TextAsset ta = Resources.Load<TextAsset>("TemplatePolygonData");
        
        string directory = AssetDatabase.GetAssetPath(ta) + "/../../Scripts/CustomizedMaskData/";
        
        string script = ta.text;
        script = script.Replace("$TemplatePolygonData", "CustomizedMaskData_" + sourceT2d.name);

        StringBuilder s = new StringBuilder();
        for (int i = 0; i < vertices.Count; i++)
        {
            s.Append(string.Format("new Vector3({0}f,{1}f,{2}f), ", vertices[i].x, vertices[i].y, vertices[i].z));
        }
        string verticesStr = "new Vector3[]{" + s + "}";

        s.Remove(0, s.Length);
        for (int i = 0; i < orderedVertices.Count; i++)
        {
            s.Append(string.Format("new Vector3({0}f,{1}f,{2}f), ", orderedVertices[i].x, orderedVertices[i].y, orderedVertices[i].z));
        }
        string orderVerticesStr = "new Vector3[]{" + s + "}";
        
        s.Remove(0, s.Length);
        for (int i = 0; i < triangles.Count; i++)
        {
            s.Append(string.Format("{0}, ", triangles[i]));
        }
        string trisStr = "new int[]{" + s + "}";

        script = script.Replace("$VerticesRawData", verticesStr);
        script = script.Replace("$TriangleIndicesRawData", trisStr);
        script = script.Replace("$OrderedVerticesRawData", orderVerticesStr);

        File.WriteAllText(directory + "/" + "CustomizedMaskData_" + sourceT2d.name + ".cs", script);
    }

}
