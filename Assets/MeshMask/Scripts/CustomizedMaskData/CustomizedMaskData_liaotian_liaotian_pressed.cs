/* ==============================================================================
 * 功能描述：
 * 创 建 者：shuchangliu
 * ==============================================================================*/

using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using System.Collections;

public class CustomizedMaskData_liaotian_liaotian_pressed {

    private static List<Vector3> _vertices;
    public static List<Vector3> Vertices()
    {
        if (_vertices == null)
        {
            _vertices = VerticesRawData().ToList();
        }
        return _vertices;
    }

    private static List<Vector3> _orderedVertices;
    public static List<Vector3> OrderedVertices()
    {
        if (_orderedVertices == null)
        {
            _orderedVertices = OrderedVerticesRawData().ToList();
        }
        return _orderedVertices;
    }

    private static List<int> _triangles;
    public static List<int> Triangles()
    {
        if (_triangles == null)
        {
            _triangles = TriangleIndicesRawData().ToList();
        }
        return _triangles;
    }

#region RawData
	public static Vector3[] VerticesRawData()
    {
        return new Vector3[]{new Vector3(-0.5f,-0.3405797f,0f), new Vector3(-0.5f,0.326087f,0f), new Vector3(-0.4855072f,0.326087f,0f), new Vector3(-0.4855072f,0.384058f,0f), new Vector3(-0.4710145f,0.384058f,0f), new Vector3(-0.4710145f,0.3985507f,0f), new Vector3(-0.4565217f,0.3985507f,0f), new Vector3(-0.4565217f,0.4275362f,0f), new Vector3(-0.442029f,0.4275362f,0f), new Vector3(-0.442029f,0.442029f,0f), new Vector3(-0.4130435f,0.442029f,0f), new Vector3(-0.4130435f,0.4565217f,0f), new Vector3(-0.3985507f,0.4565217f,0f), new Vector3(-0.3985507f,0.4710145f,0f), new Vector3(-0.3405797f,0.4710145f,0f), new Vector3(-0.3405797f,0.4855072f,0f), new Vector3(0.326087f,0.4855072f,0f), new Vector3(0.326087f,0.4710145f,0f), new Vector3(0.384058f,0.4710145f,0f), new Vector3(0.384058f,0.4565217f,0f), new Vector3(0.3985507f,0.4565217f,0f), new Vector3(0.3985507f,0.442029f,0f), new Vector3(0.4275362f,0.442029f,0f), new Vector3(0.4275362f,0.4275362f,0f), new Vector3(0.442029f,0.4275362f,0f), new Vector3(0.442029f,0.3985507f,0f), new Vector3(0.4565217f,0.3985507f,0f), new Vector3(0.4565217f,0.384058f,0f), new Vector3(0.4710145f,0.384058f,0f), new Vector3(0.4710145f,0.326087f,0f), new Vector3(0.4855072f,0.326087f,0f), new Vector3(0.4855072f,-0.3405797f,0f), new Vector3(0.4710145f,-0.3405797f,0f), new Vector3(0.4710145f,-0.3985507f,0f), new Vector3(0.4565217f,-0.3985507f,0f), new Vector3(0.4565217f,-0.4130435f,0f), new Vector3(0.442029f,-0.4130435f,0f), new Vector3(0.442029f,-0.442029f,0f), new Vector3(0.4275362f,-0.442029f,0f), new Vector3(0.4275362f,-0.4565217f,0f), new Vector3(0.3985507f,-0.4565217f,0f), new Vector3(0.3985507f,-0.4710145f,0f), new Vector3(0.384058f,-0.4710145f,0f), new Vector3(0.384058f,-0.4855072f,0f), new Vector3(0.326087f,-0.4855072f,0f), new Vector3(0.326087f,-0.5f,0f), new Vector3(-0.3405797f,-0.5f,0f), new Vector3(-0.3405797f,-0.4855072f,0f), new Vector3(-0.3985507f,-0.4855072f,0f), new Vector3(-0.3985507f,-0.4710145f,0f), new Vector3(-0.4130435f,-0.4710145f,0f), new Vector3(-0.4130435f,-0.4565217f,0f), new Vector3(-0.442029f,-0.4565217f,0f), new Vector3(-0.442029f,-0.442029f,0f), new Vector3(-0.4565217f,-0.442029f,0f), new Vector3(-0.4565217f,-0.4130435f,0f), new Vector3(-0.4710145f,-0.4130435f,0f), new Vector3(-0.4710145f,-0.3985507f,0f), new Vector3(-0.4855072f,-0.3985507f,0f), new Vector3(-0.4855072f,-0.3405797f,0f), new Vector3(-0.4927536f,-0.3405797f,0f), new Vector3(-0.5f,-0.007246377f,0f), };
    }
    public static int[] TriangleIndicesRawData()
    {
        return new int[]{2, 3, 4, 2, 4, 6, 4, 5, 6, 6, 7, 8, 6, 8, 10, 8, 9, 10, 10, 11, 12, 2, 6, 14, 6, 10, 14, 10, 12, 14, 12, 13, 14, 14, 15, 16, 14, 16, 17, 17, 18, 19, 19, 21, 17, 19, 20, 21, 21, 22, 23, 21, 25, 17, 21, 23, 25, 23, 24, 25, 25, 26, 27, 25, 29, 17, 25, 27, 29, 27, 28, 29, 29, 30, 31, 31, 32, 29, 32, 33, 34, 32, 34, 36, 34, 35, 36, 36, 37, 38, 32, 36, 40, 38, 40, 36, 38, 39, 40, 40, 41, 42, 32, 40, 44, 40, 42, 44, 42, 43, 44, 44, 45, 46, 46, 47, 44, 47, 48, 49, 49, 51, 47, 49, 50, 51, 51, 52, 53, 51, 55, 47, 51, 53, 55, 53, 54, 55, 55, 56, 57, 55, 59, 47, 55, 57, 59, 57, 58, 59, 14, 61, 2, 14, 17, 61, 17, 29, 61, 29, 32, 61, 32, 44, 61, 44, 47, 61, 47, 59, 61, 60, 0, 61, 1, 2, 61, 59, 60, 61, };
    }
    public static Vector3[] OrderedVerticesRawData()
    {
        return new Vector3[]{new Vector3(-0.5f,-0.3405797f,0f), new Vector3(-0.5f,0.326087f,0f), new Vector3(-0.4855072f,0.326087f,0f), new Vector3(-0.4855072f,0.384058f,0f), new Vector3(-0.4710145f,0.384058f,0f), new Vector3(-0.4710145f,0.3985507f,0f), new Vector3(-0.4565217f,0.3985507f,0f), new Vector3(-0.4565217f,0.4275362f,0f), new Vector3(-0.442029f,0.4275362f,0f), new Vector3(-0.442029f,0.442029f,0f), new Vector3(-0.4130435f,0.442029f,0f), new Vector3(-0.4130435f,0.4565217f,0f), new Vector3(-0.3985507f,0.4565217f,0f), new Vector3(-0.3985507f,0.4710145f,0f), new Vector3(-0.3405797f,0.4710145f,0f), new Vector3(-0.3405797f,0.4855072f,0f), new Vector3(0.326087f,0.4855072f,0f), new Vector3(0.326087f,0.4710145f,0f), new Vector3(0.384058f,0.4710145f,0f), new Vector3(0.384058f,0.4565217f,0f), new Vector3(0.3985507f,0.4565217f,0f), new Vector3(0.3985507f,0.442029f,0f), new Vector3(0.4275362f,0.442029f,0f), new Vector3(0.4275362f,0.4275362f,0f), new Vector3(0.442029f,0.4275362f,0f), new Vector3(0.442029f,0.3985507f,0f), new Vector3(0.4565217f,0.3985507f,0f), new Vector3(0.4565217f,0.384058f,0f), new Vector3(0.4710145f,0.384058f,0f), new Vector3(0.4710145f,0.326087f,0f), new Vector3(0.4855072f,0.326087f,0f), new Vector3(0.4855072f,-0.3405797f,0f), new Vector3(0.4710145f,-0.3405797f,0f), new Vector3(0.4710145f,-0.3985507f,0f), new Vector3(0.4565217f,-0.3985507f,0f), new Vector3(0.4565217f,-0.4130435f,0f), new Vector3(0.442029f,-0.4130435f,0f), new Vector3(0.442029f,-0.442029f,0f), new Vector3(0.4275362f,-0.442029f,0f), new Vector3(0.4275362f,-0.4565217f,0f), new Vector3(0.3985507f,-0.4565217f,0f), new Vector3(0.3985507f,-0.4710145f,0f), new Vector3(0.384058f,-0.4710145f,0f), new Vector3(0.384058f,-0.4855072f,0f), new Vector3(0.326087f,-0.4855072f,0f), new Vector3(0.326087f,-0.5f,0f), new Vector3(-0.3405797f,-0.5f,0f), new Vector3(-0.3405797f,-0.4855072f,0f), new Vector3(-0.3985507f,-0.4855072f,0f), new Vector3(-0.3985507f,-0.4710145f,0f), new Vector3(-0.4130435f,-0.4710145f,0f), new Vector3(-0.4130435f,-0.4565217f,0f), new Vector3(-0.442029f,-0.4565217f,0f), new Vector3(-0.442029f,-0.442029f,0f), new Vector3(-0.4565217f,-0.442029f,0f), new Vector3(-0.4565217f,-0.4130435f,0f), new Vector3(-0.4710145f,-0.4130435f,0f), new Vector3(-0.4710145f,-0.3985507f,0f), new Vector3(-0.4855072f,-0.3985507f,0f), new Vector3(-0.4855072f,-0.3405797f,0f), new Vector3(-0.5f,-0.3405797f,0f), };
    }
#endregion

}
