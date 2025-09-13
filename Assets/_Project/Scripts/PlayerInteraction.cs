using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class PlayerInteraction : MonoBehaviour
{
    public float interactDistance = 3f;
    public Camera playerCamera;
    public Image crosshair;
    public GameObject interactMenu;
    public TextMeshProUGUI interactionText;
    public Color defaultColor = Color.white;
    public Color interactColor = Color.red;

    void Update()
    {
        Ray ray = new Ray(playerCamera.transform.position, playerCamera.transform.forward);
        RaycastHit hit;

        crosshair.color = defaultColor;
        interactMenu.SetActive(false);

        if (Physics.Raycast(ray, out hit, interactDistance))
        {
            Interactable interactable = hit.collider.GetComponentInParent<Interactable>();
            if (interactable != null)
            {
                crosshair.color = interactColor;
                interactMenu.SetActive(true);
                interactionText.text = "[E] " + interactable.GetInteractText();

                if (Input.GetKeyDown(KeyCode.E))
                {
                    interactable.Interact();
                }
            }
        }
    }

    public void ToggleMouseCursor(bool state)
    {
        if (state)
        {
            Cursor.visible = true;
            Cursor.lockState = CursorLockMode.None;
        }
        else
        {
            Cursor.visible = false;
            Cursor.lockState = CursorLockMode.Locked;
        }
    }
}
