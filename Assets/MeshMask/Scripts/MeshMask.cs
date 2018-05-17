/* ==============================================================================
 * 功能描述：无需使用Mask，修改Image顶点实现遮罩
 * 创 建 者：shuchangliu
 * ==============================================================================*/

using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using System.Collections;
using UnityEngine.Sprites;
using UnityEngine.UI;
using System;

[RequireComponent(typeof(Image))]
public class MeshMask : BaseMeshEffect, ICanvasRaycastFilter
{
    [Tooltip("把图片拖进来就可以，获得图片名后会自动清空字段")]
    public Texture2D maskSource;
    [Tooltip("重要！根据该字段获取面片数据")]
    public string maskSourceName;
    [Tooltip("是否启用遮罩")]
    public bool enableMask = true;
    [Tooltip("是否判断点击")]
    public bool enableRaycastDetect = true;

    private Image _image;

    private List<UIVertex> _uiVertices = new List<UIVertex>();

    private Type _t;
    private List<Vector3> _vertices;
    private List<Vector3> _orderedVertices;
    private List<int> _triangles;

    public void Awake()
    {
        _image = this.GetComponent<Image>();
        InitData();
    }

    public override void ModifyMesh(VertexHelper vh)
    {
        UpdateData();

        if (this.enabled && enableMask)
        {
            if (_vertices != null && _triangles != null)
            {
                vh.Clear();
                _uiVertices.Clear();

                float tw = _image.rectTransform.rect.width;
                float th = _image.rectTransform.rect.height;
                Vector4 uv = _image.overrideSprite != null ? DataUtility.GetOuterUV(_image.overrideSprite) : Vector4.zero;
                float uvCenterX = (uv.x + uv.z) * 0.5f;
                float uvCenterY = (uv.y + uv.w) * 0.5f;
                float uvScaleX = (uv.z - uv.x) / tw;
                float uvScaleY = (uv.w - uv.y) / th;

                for (int i = 0; i < _vertices.Count; i++)
                {
                    UIVertex v = new UIVertex();
                    v.color = _image.color;
                    v.position = new Vector2(_vertices[i].x * tw, _vertices[i].y * th);
                    v.uv0 = new Vector2(v.position.x * uvScaleX + uvCenterX, v.position.y * uvScaleY + uvCenterY);
                    _uiVertices.Add(v);
                }

                vh.AddUIVertexStream(_uiVertices, _triangles);
            }
        }
    }

    private void UpdateData()
    {
        if (maskSource != null)
        {
            maskSourceName = maskSource.name;
            maskSource = null;

            InitData();
        }

    }

    private void InitData()
    {
        if (maskSourceName != null)
        {
            _t = Assembly.GetExecutingAssembly().GetType("CustomizedMaskData_" + maskSourceName);
            if (_t != null)
            {
                _vertices = _t.GetMethod("Vertices").Invoke(null, null) as List<Vector3>;
                _orderedVertices = _t.GetMethod("OrderedVertices").Invoke(null, null) as List<Vector3>;
                _triangles = _t.GetMethod("Triangles").Invoke(null, null) as List<int>;
            }
            else
            {
                _vertices = null;
                _orderedVertices = null;
                _triangles = null;
            }
        }
    }

    #region ICanvasRaycastFilter
    public virtual bool IsRaycastLocationValid(Vector2 screenPoint, Camera eventCamera)
    {
        if (enableRaycastDetect)
        {
            Sprite sprite = _image.overrideSprite;
            if (sprite == null)
                return true;

            Vector2 local;
            RectTransformUtility.ScreenPointToLocalPointInRectangle(_image.rectTransform, screenPoint, eventCamera, out local);

            local = new Vector2(local.x / _image.rectTransform.rect.width, local.y / _image.rectTransform.rect.height);

            return ImageUtil.Contains(local, _orderedVertices);
        }
        else
        {
            return true;
        }
    }
    #endregion

}
