using UnityEngine;
using UnityEngine.SceneManagement; // ����� ���������� ���� namespace

public class SceneController : MonoBehaviour
{
    public static SceneController Instance { get; private set; }

    private void Awake()
    {
        // ������ Singleton, ����� �������� ��� �������� �����
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // ��������� ��� ����� ����
        }
        else
        {
            Destroy(gameObject);
        }
    }

    /// <summary>
    /// ��������� ����� �� �����
    /// </summary>
    public void LoadScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }

    /// <summary>
    /// ��������� ����� �� ������� (�� Build Settings)
    /// </summary>
    public void LoadScene(int sceneIndex)
    {
        SceneManager.LoadScene(sceneIndex);
    }

    /// <summary>
    /// ������������� ������� �����
    /// </summary>
    public void ReloadCurrentScene()
    {
        Scene current = SceneManager.GetActiveScene();
        SceneManager.LoadScene(current.name);
    }

    /// <summary>
    /// ��������� ��������� ����� (�� Build Index)
    /// </summary>
    public void LoadNextScene()
    {
        int nextIndex = SceneManager.GetActiveScene().buildIndex + 1;

        if (nextIndex < SceneManager.sceneCountInBuildSettings)
        {
            SceneManager.LoadScene(nextIndex);
        }
        else
        {
            Debug.LogWarning("��������� ����� ���!");
        }
    }

    /// <summary>
    /// ����� �� ����
    /// </summary>
    public void QuitGame()
    {
        Debug.Log("����� �� ����...");
        Application.Quit();

#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false; // ����� �������� � ���������
#endif
    }
}
