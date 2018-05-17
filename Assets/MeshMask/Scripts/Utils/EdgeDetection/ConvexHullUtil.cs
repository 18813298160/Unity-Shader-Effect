/* ==============================================================================
 * 功能描述：计算凸包点集
 * 创 建 者：shuchangliu
 * ==============================================================================*/

using System.Linq;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ConvexHullUtil{

    public static List<Vector2> GetPoints(Texture2D t2d)
    {
        List<Vector2> ret = new List<Vector2>();
        for (int i = 0; i < t2d.width; i++)
        {
            for (int j = 0; j < t2d.height; j++)
            {
                if(t2d.GetPixel(i,j).a > 0)
                    ret.Add(new Vector2(i,j));
            }
        }
        ret = CreateOutside(ret);
        return ret;
    }

    private static List<Vector2> CreateOutside(List<Vector2> corners)
    {
        List<Vector2> orderedCorners = new List<Vector2>();
        List<Vector2> indexs = corners.OrderBy(a => a.x).ToList();
        Vector2 cur = indexs[0];
        Vector2 next = Vector2.zero;
        Vector2 start = cur;
        float minAngle;
        Vector2 vector = new Vector2(0, 1);
        Vector2 tmpVector = Vector2.zero;

        float lastAngle = 0;
        float curAngle = 0;

        orderedCorners.Add(cur);
        //生成外围边
        do
        {
            minAngle = 360;
            //查找外围边
            foreach (var temp in corners)
            {
                if (temp == cur) continue;
                tmpVector.x = temp.x - cur.x;
                tmpVector.y = temp.y - cur.y;

                float tmpAngle = Vector3.Angle(vector, tmpVector);
                if (tmpAngle < minAngle)
                {
                    minAngle = tmpAngle;
                    next = temp;
                }
            }

            if (orderedCorners.Count >= 2)
            {
                vector = next - orderedCorners[orderedCorners.Count - 2];
                tmpVector = orderedCorners[orderedCorners.Count - 1] - orderedCorners[orderedCorners.Count - 2];

                curAngle = Vector3.Angle(vector, tmpVector);
                //找到新顶点的角度与上次迭代的顶点角度相同，说明两顶点共边，可以删除上次迭代的顶点
                if (curAngle == 0)
                {
                    orderedCorners.RemoveAt(orderedCorners.Count - 1);
                }
            }
            //加入新顶点
            orderedCorners.Add(next);
            //
            vector.x = next.x - cur.x;
            vector.y = next.y - cur.y;
            cur = next;
            next = Vector2.zero;
        } while (cur != start);

        return orderedCorners;
    }


}
