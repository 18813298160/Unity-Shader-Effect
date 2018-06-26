using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using System;

public class Turn : MonoBehaviour
{
    private Material cardMat;
    private float curAngle = 0;
    private RectTransform appendages;
    private Sequence seq;

    void Awake()
    {
        cardMat = transform.GetChild(0).GetComponent<Image>().material;
        cardMat.SetFloat("_Angle", 0);
        appendages = transform.GetChild(1) as RectTransform;
        appendages.localScale *= 0;
    }

    private void Positive()
    {
        appendages.localScale *= 0;
        curAngle = cardMat.GetFloat("_Angle");
        if (curAngle > 2) return;
        seq = DOTween.Sequence().SetRecyclable() ;
        seq.Append(cardMat.DOFloat(180, "_Angle", 3f));
        seq.Insert(1.5f, appendages.DOScale(1, 0.5f));
    }

    private void Negative()
    {
        appendages.localScale *= 0;
        curAngle = cardMat.GetFloat("_Angle");
        if (curAngle < 178) return;
        cardMat.DOFloat(0, "_Angle", 3f);
    }


    private void OnGUI()
    {
        if(GUI.Button(new Rect(100,100,100,100), "TestPositive"))
        {
            Positive();
        }

        if (GUI.Button(new Rect(100, 200, 100, 100), "TestNegative"))
        {           
            Negative();   
        }
    }
}