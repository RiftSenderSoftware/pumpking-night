using UnityEngine;
using UnityEngine.Events;

public class Room : MonoBehaviour
{
    public PumpkinCandle[] pumkingEvents;
    public UnityEvent startEvent;
    public UnityEvent halfEvent;
    public UnityEvent endEvent;

    public void CheckRoomStatus()
    {
        if (pumkingEvents == null || pumkingEvents.Length == 0) return;

        int falseCount = 0;
        foreach (var pe in pumkingEvents)
        {
            if (pe != null && !pe.isLit)
                falseCount++;
        }

        int total = pumkingEvents.Length;

        if (falseCount == 0)
        {
            Debug.Log("Start event");
            startEvent?.Invoke();
        }
        else if (falseCount >= total / 2 && falseCount < total)
        {
            Debug.Log("Half event");
            halfEvent?.Invoke();
        }
        else if (falseCount >= total)
        {
            Debug.Log("End event");
            endEvent?.Invoke();
        }
    }
}
