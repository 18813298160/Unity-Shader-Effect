/* ==============================================================================
 * 功能描述：德洛内三角剖分工具
 * 创 建 者：shuchangliu
 * ==============================================================================*/

using System.Collections.Generic;
using UnityEngine;
using mattatz.Triangulation2DSystem;

public class TriangulationUtil {

    public static Triangulation2D GetTriangulation(List<Vector2> points)
    {
        points = Utils2D.Constrain(points, 0.1f);
        var polygon = Polygon2D.Contour(points.ToArray());

        var vertices = polygon.Vertices;
        if (vertices.Length < 3) return null; // error

        var triangulation = new Triangulation2D(polygon, 1, 0.5f);

        return triangulation;
    }
}
