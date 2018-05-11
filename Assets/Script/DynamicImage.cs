using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Collections;


    public class DynamicImage : MonoBehaviour
    {
        public float ScaleDuration = 1;
        public float CycleInterval = 5;
        public float ScaleRatio = 0.5f;
        private Canvas ParentCanvas;

        private Image[] images;
        private Vector4[] meshSizes;
        private int currentScaleIdx = -1;

        private Coroutine playingCoroutine;

        public Shader s;
        private static Material UIExpandMat = null;
        private static int VertexParamsID = -1;
        private static int TimeOffsetID = -1;
        private static int TimeScaleID = -1;
        private static int ScaleRatioID = -1;
        private static int TestID = -1;

        void Awake()
        {
            //初始化静态变量
            if (UIExpandMat == null)
            {
                UIExpandMat = new Material(s);
                VertexParamsID = Shader.PropertyToID("_VertexParmas");
                TimeOffsetID = Shader.PropertyToID("_TimeOffset");
                TimeScaleID = Shader.PropertyToID("_TimeScale");
                ScaleRatioID = Shader.PropertyToID("_ScaleRatio");
                TestID = Shader.PropertyToID("_Test");
            }

            UIExpandMat.SetFloat(TimeScaleID, 1 / ScaleDuration);
            UIExpandMat.SetFloat(ScaleRatioID, ScaleRatio);

		    ParentCanvas = GetComponentInParent<Canvas>();

		if (ParentCanvas == null || ParentCanvas.worldCamera == null)
            {
                Debug.LogError("The parent canvas of UIAutoExpand could not be empty!");
                return;
            }
            images = GetComponentsInChildren<Image>();
            if (images.Length > 0)
            {
                meshSizes = new Vector4[images.Length];
            }
            Vector2 tempPos;
            for (int i = 0; i < images.Length; ++i)
            {
                Image img = images[i];
                tempPos.x = 0;
                tempPos.y = 0;
  

 /*vert函数中需要获取字体的中心点和长宽大小，然后进行缩放计算，也就是参数_VertexParmas的内容。经过测试，在ugui中，顶点的位置信息worldPosition是其相对于Canvas的位置信息，因此这里需要在C#中进行计算，计算过程借助RectTransformUtility的ScreenPointToLocalPointInRectangle函数*/
           RectTransformUtility.ScreenPointToLocalPointInRectangle(ParentCanvas.transform as RectTransform,
                    ParentCanvas.worldCamera.WorldToScreenPoint(img.transform.position),
                    ParentCanvas.worldCamera, out tempPos);
                meshSizes[i].x = tempPos.x;
                meshSizes[i].y = tempPos.y;
                meshSizes[i].z = 0;
                meshSizes[i].w = 0;
            }
        }

        private void OnEnable()
        {
            playingCoroutine = StartCoroutine(PlayExpandAni());
        }

        private void OnDisable()
        {
            if (playingCoroutine != null)
            {
                StopCoroutine(playingCoroutine);
            }
        }

        private void OnDestroy()
        {
            StartScaleImage(-1);
            if (playingCoroutine != null)
            {
                StopCoroutine(playingCoroutine);
            }
        }

        private void StartScaleImage(int idx)
        {
            if (images == null)
            {
                return;
            }
            if (currentScaleIdx > -1 && currentScaleIdx < images.Length)
            {
                Image preImg = images[currentScaleIdx];
                preImg.material = null;
            }
            if (idx < 0 || idx >= images.Length)
            {

                return;
            }
            currentScaleIdx = idx;
            Image curImg = images[idx];

            UIExpandMat.SetVector(VertexParamsID, meshSizes[idx]);
            curImg.material = UIExpandMat;
        }

        private IEnumerator PlayExpandAni()
        {
            while (true)
            {
                for (int i = 0; i < images.Length; ++i)
                {
                    UIExpandMat.SetFloat(TimeOffsetID, Time.timeSinceLevelLoad);
                    StartScaleImage(i);
				//yield return Yielders.GetWaitForSeconds(ScaleDuration);
                    yield return new WaitForSeconds(ScaleDuration);
			    }
                StartScaleImage(-1);
                //yield return Yielders.GetWaitForSeconds(CycleInterval);
                yield return new WaitForSeconds(CycleInterval);
            }
        }
    }