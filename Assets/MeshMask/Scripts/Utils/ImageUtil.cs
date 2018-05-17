/* ==============================================================================
 * 功能描述：
 * 创 建 者：shuchangliu
 * ==============================================================================*/

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ImageUtil {

    /// <summary>
    /// 使用RayCrossing算法判断点击点是否在封闭多边形里
    /// https://www.zhihu.com/question/26551754
    /// </summary>
    /// <param name="p"></param>
    /// <param name="vertices"></param>
    /// <param name="crossNumber"></param>
    public static bool Contains(Vector2 p, List<Vector3> vertices)
    {
        int crossNumber = 0;

        for (int i = 0, count = vertices.Count; i < count; i++)
        {
            var v1 = vertices[i];
            var v2 = vertices[(i + 1) % count];

            //点击点水平线必须与两顶点线段相交
            if (((v1.y <= p.y) && (v2.y > p.y))
                || ((v1.y > p.y) && (v2.y <= p.y)))
            {
                //只考虑点击点右侧方向，点击点水平线与线段相交，且交点x > 点击点x，则crossNumber+1
                if (p.x < v1.x + (p.y - v1.y) / (v2.y - v1.y) * (v2.x - v1.x))
                {
                    crossNumber += 1;
                }
            }
        }

        if ((crossNumber & 1) == 1)
        {
            Debug.Log("");
        }

        return (crossNumber & 1) == 1;
    }

    //public static bool Contains(Vector3 p, List<Vector3> vertices)
    //{
    //    var n = vertices.Count;
    //    bool c = false;
    //    for (int i = 0, j = n - 1; i < n; j = i++)
    //    {
    //        if (vertices[i] == p) return true;
    //        if (
    //            ((vertices[i].y > p.y) != (vertices[j].y > p.y)) &&
    //            (p.x < (vertices[j].x - vertices[i].x) * (p.y - vertices[i].y) / (vertices[j].y - vertices[i].y) + vertices[i].x)
    //        )
    //        {
    //            c = !c;
    //        }
    //    }
    //    // c == true means odd, c == false means even
    //    return c;
    //}



}
