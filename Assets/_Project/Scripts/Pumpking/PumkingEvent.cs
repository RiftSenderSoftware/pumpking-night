using UnityEngine;
using UnityEngine.Events;

public class PumkingEvent : MonoBehaviour
{
    public string pumpkingName;
    public bool state;
    
    public void SendState()
    {
        GlobalEventManager.SendPumpkingEvent(pumpkingName, state);
    }
    public bool GetState()=> state;
}
