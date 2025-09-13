using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using SUPERCharacter;

[RequireComponent(typeof(Collider))]
public class Interactable : MonoBehaviour, IInteractable
{
    public UnityEvent OnInteract;
    public string interactText;
    public bool Interact(){
        Debug.Log("Interact object");
        OnInteract.Invoke();
        return true;
    }
    public void SetInteractText(string text) {  interactText = text; }
    public string GetInteractText()=> interactText;
    public void DestroySelf(){
        Destroy(gameObject);
    }
}
