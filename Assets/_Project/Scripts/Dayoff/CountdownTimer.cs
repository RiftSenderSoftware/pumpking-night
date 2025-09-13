using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using System.Collections;
using TMPro;

public class CountdownTimer : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI countdownText;
    [SerializeField] private int countdownTime = 3;

    public UnityEvent onCountdownFinished;

    private void Start()
    {
        StartCoroutine(StartCountdown());
    }

    private IEnumerator StartCountdown()
    {
        int time = countdownTime;

        while (time > 0)
        {
            if (countdownText != null)
                countdownText.text = time.ToString();

            yield return new WaitForSeconds(1f);
            time--;
        }

        if (countdownText != null)
            countdownText.text = "GO!";

        onCountdownFinished?.Invoke();
    }
}
