using System.Collections.Generic;

namespace UnityEngine.UI
{
    [AddComponentMenu("UI/Effect/PolyGonImage")]
    [RequireComponent(typeof(Image))]
	/*增加顶点数来降低无用填充
	两点优化:
	1）可以将精灵打包得更紧凑=>减少纹理的内存使用量
	2）减少overdraw =>提高游戏性能

    应注意的点：
	顶点的转换通常由CPU完成。添加更多顶点会增加CPU时间。
	但网格减少了绘制像素的数量。所以这是一种控制GPU和CPU之间工作负载分配的方法。
    顶点应该在一定范围内增加，维护cpu与gpu的工作分配关系
	*/
	public class PolyImage : BaseMeshEffect
    {
        private static Vector3[] fourCorners = new Vector3[4];
        private static UIVertex vertice = new UIVertex();
        private RectTransform recTransform = null;
        private Image image = null;

        protected PolyImage()
        {}

        public override void ModifyMesh(VertexHelper vh)
        {
            if (!isActiveAndEnabled) return;

            if (!recTransform)
                recTransform = GetComponent<RectTransform>();
            
            if (!image)
                image = GetComponent<Image>();

            //目前仅支持优化普通模式的image
            if (image.type != Image.Type.Simple) return;

			//注意此处是overrideSprite
			Sprite sprite = image.overrideSprite;

            //只有两个三角形，不用进行优化
			if (sprite == null || sprite.triangles.Length == 6) return;

            if (vh.currentVertCount != 4) return;

			recTransform.GetLocalCorners(fourCorners);

			//重新计算sprite的顶点数据
			int len = sprite.vertices.Length;
			var vertices = new List<UIVertex>(len);
			Vector2 Center = sprite.bounds.center;
			Vector2 invExtend = new Vector2(1 / sprite.bounds.size.x, 1 / sprite.bounds.size.y);
            for (int i = 0; i < len; i++)
            {
                // normalize
                float x = (sprite.vertices[i].x - Center.x) * invExtend.x + 0.5f;
                float y = (sprite.vertices[i].y - Center.y) * invExtend.y + 0.5f;
                // lerp to position
                vertice.position = new Vector2(Mathf.Lerp(fourCorners[0].x, fourCorners[2].x, x), Mathf.Lerp(fourCorners[0].y, fourCorners[2].y, y));
                vertice.color = image.color;
                vertice.uv0 = sprite.uv[i];
                vertices.Add(vertice);
            }
            len = sprite.triangles.Length;
			var triangles = new List<int>(len);

            for (int i = 0; i < len; i++)
            {
                //根据sprite的顶点进行三角形的绘制
                triangles.Add(sprite.triangles[i]);
            }

            vh.Clear();
			vh.AddUIVertexStream(vertices, triangles);
        }
    }
}
