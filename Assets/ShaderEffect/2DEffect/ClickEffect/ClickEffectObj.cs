using UnityEngine;

[RequireComponent(typeof(SpriteRenderer))]
[RequireComponent(typeof(Collider2D))]
public class ClickEffectObj : MonoBehaviour
{

	SpriteRenderer mSpriteRenderer;
	Collider2D mCircleCollider;

	void Awake()
	{
		mSpriteRenderer = transform.GetComponent<SpriteRenderer>();
		mCircleCollider = transform.GetComponent<Collider2D>();
	}
	// Use this for initialization
	void Start()
	{
		Invoke("UnEnbaleTrigger", 0.05f);

		mSpriteRenderer.material.SetFloat("_StartTime", Time.time);

		float animationTime = mSpriteRenderer.material.GetFloat("_AnimationTime");
		float destroyTime = animationTime;
		//需要减去起始位置所需要消耗的时间
		destroyTime -= mSpriteRenderer.material.GetFloat("_StartWidth") * animationTime;
		//Destroy(transform.gameObject, destroyTime);
	}

    private void UnEnbaleTrigger()
	{
		mCircleCollider.enabled = false;
	}

	public void OnTriggerEnter2D(Collider2D collision)
	{

	}

}