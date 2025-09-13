using UnityEngine;
using UnityEngine.Events;

public class PumpkinStats : MonoBehaviour
{
    public UnityEvent endGameEvent;
    public Room[] rooms;
    public static PumpkinStats Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
    }

    private void Start()
    {
        for (int i = 0; i < rooms.Length; i++)
        {
            rooms[i].CheckRoomStatus();
        }
    }

    public static int totalCandles = 0;
    public static int activeCandles = 0;

    public void RegisterCandle()
    {
        totalCandles++;
        activeCandles++;
    }

    public void CandleExtinguished()
    {
        activeCandles--;
        if (activeCandles <= 0)
        {
            activeCandles = 0;
            endGameEvent.Invoke();
        }
        
        for (int i = 0; i < rooms.Length; i++)
        {
            rooms[i].CheckRoomStatus();
        }
         
    }

    public void CandleRelit()
    {
        activeCandles++;
    }
}
