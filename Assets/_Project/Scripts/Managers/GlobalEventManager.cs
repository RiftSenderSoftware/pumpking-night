using UnityEngine;
using System;

public class GlobalEventManager : MonoBehaviour
{
    public static GlobalEventManager Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        Instance = this;
    }

    public static event Action OnGameEnd;
    public static event Action<string, bool> pumpKingStateEvent;

    public static void SendGameEnd()
    {
        OnGameEnd?.Invoke();
    }

    public static void SendPumpkingEvent(string name, bool status)
    {
        pumpKingStateEvent?.Invoke(name, status);
    }

}
