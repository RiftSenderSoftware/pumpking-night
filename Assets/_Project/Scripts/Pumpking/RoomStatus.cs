using UnityEngine;

public class RoomStatus : MonoBehaviour
{
    public PumkingEvent[] pumkingEvent;
    public bool roomState;

    public void CheckStatus()
    {
        roomState = false;

        for (int i = 0; i < pumkingEvent.Length; i++)
        {
            if (pumkingEvent[i].GetState())
            {
                roomState = true;
                break;
            }
        }
    }
}
