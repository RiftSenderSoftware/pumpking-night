using UnityEngine;
using UnityEngine.UI;

public class PumpkinCandle : MonoBehaviour
{
    public float maxCandleTime = 60f;
    private float currentTime;
    public Slider candleSlider;

    public bool isLit = true;

    void Start()
    {
        currentTime = maxCandleTime;

        if (candleSlider != null)
        {
            candleSlider.maxValue = maxCandleTime;
            candleSlider.value = currentTime;
        }

        PumpkinStats.Instance.RegisterCandle();
    }

    void Update()
    {
        if (isLit)
        {
            currentTime -= Time.deltaTime;

            if (candleSlider != null)
                candleSlider.value = currentTime;

            if (currentTime <= 0)
            {
                currentTime = 0;
                isLit = false;
                PumpkinStats.Instance.CandleExtinguished();
            }
        }
    }

    public void RefreshCandle()
    {
        currentTime = maxCandleTime;
        isLit = true;

        if (candleSlider != null)
            candleSlider.value = currentTime;
    }
}
