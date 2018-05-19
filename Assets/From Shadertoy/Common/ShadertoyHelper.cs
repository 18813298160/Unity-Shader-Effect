using UnityEngine;

/// <summary>
/// Shadertoy 的帮助类，用于传递鼠标数据.
/// </summary>
public class ShadertoyHelper : MonoBehaviour 
{

    private Material _material = null;

    private bool _isDragging = false;

    void Start () 
    {
        Renderer render  = GetComponent<Renderer>();
        if (render != null) 
        {
            _material = render.material;
        }

        _isDragging = false;
    }

    void Update () 
    {
        Vector3 mousePosition = Vector3.zero;
        if (_isDragging) 
        {
            mousePosition = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 1.0f);
        }

        else 
        {
            mousePosition = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0.0f);
        }

        if (_material != null) 
        {
            _material.SetVector("iMouse", mousePosition);
        }
    }

    void OnMouseDown() 
    {
        _isDragging = true;
    }

    void OnMouseUp()
    {
        _isDragging = false;
    }
}