using UnityEngine;
using UnityEngine.SceneManagement; // важно подключить этот namespace

public class SceneController : MonoBehaviour
{
    public static SceneController Instance { get; private set; }

    private void Awake()
    {
        // Делаем Singleton, чтобы менеджер был доступен везде
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // сохраняем при смене сцен
        }
        else
        {
            Destroy(gameObject);
        }
    }

    /// <summary>
    /// Загружает сцену по имени
    /// </summary>
    public void LoadScene(string sceneName)
    {
        SceneManager.LoadScene(sceneName);
    }

    /// <summary>
    /// Загружает сцену по индексу (из Build Settings)
    /// </summary>
    public void LoadScene(int sceneIndex)
    {
        SceneManager.LoadScene(sceneIndex);
    }

    /// <summary>
    /// Перезапускает текущую сцену
    /// </summary>
    public void ReloadCurrentScene()
    {
        Scene current = SceneManager.GetActiveScene();
        SceneManager.LoadScene(current.name);
    }

    /// <summary>
    /// Загружает следующую сцену (по Build Index)
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
            Debug.LogWarning("Следующей сцены нет!");
        }
    }

    /// <summary>
    /// Выход из игры
    /// </summary>
    public void QuitGame()
    {
        Debug.Log("Выход из игры...");
        Application.Quit();

#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false; // чтобы работало в редакторе
#endif
    }
}
