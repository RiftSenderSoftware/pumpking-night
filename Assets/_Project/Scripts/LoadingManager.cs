using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadingManager : MonoBehaviour
{
    public static LoadingManager Instance { get; private set; }

    [Header("UI Elements")]
    [SerializeField] private GameObject loadingScreen;
    [SerializeField] private Image fadeImage;
    [SerializeField] private Slider progressBar;
    [SerializeField] private TextMeshProUGUI loadingText;
    [SerializeField] private TextMeshProUGUI percentageText;
    [SerializeField] private TMP_FontAsset font;

    [Header("Settings")]
    [SerializeField] private float fadeSpeed = 1f;
    [SerializeField] private float minLoadingTime = 1f; // минимальное время показа экрана загрузки
    [SerializeField]
    private string[] loadingTips =
    {
        "Загрузка...",
        "Подготовка мира...",
        "Инициализация систем...",
        "Почти готово..."
    };

    private bool isLoading = false;

    private void Awake()
    {
        // Singleton pattern
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
            InitializeUI();
        }
        else
        {
            Destroy(gameObject);
        }
    }

    private void InitializeUI()
    {
        // Создаем Canvas для экрана загрузки, если его нет
        if (loadingScreen == null)
        {
            CreateLoadingUI();
        }

        // Убеждаемся, что экран загрузки изначально отключен
        if (loadingScreen != null)
        {
            loadingScreen.SetActive(false);
            fadeImage.gameObject.SetActive(false);
        }
    }

    private void CreateLoadingUI()
    {
        // Создаем Canvas
        GameObject canvasGO = new GameObject("LoadingCanvas");
        DontDestroyOnLoad(canvasGO);
        canvasGO.transform.SetParent(transform);

        Canvas canvas = canvasGO.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        canvas.sortingOrder = 999;

        CanvasScaler scaler = canvasGO.AddComponent<CanvasScaler>();
        scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        scaler.referenceResolution = new Vector2(1920, 1080);

        canvasGO.AddComponent<GraphicRaycaster>();

        // Создаем фоновое изображение для затемнения
        GameObject fadeGO = new GameObject("FadeImage");
        fadeGO.transform.SetParent(canvasGO.transform, false);
        fadeImage = fadeGO.AddComponent<Image>();
        fadeImage.color = Color.black;

        RectTransform fadeRect = fadeImage.GetComponent<RectTransform>();
        fadeRect.anchorMin = Vector2.zero;
        fadeRect.anchorMax = Vector2.one;
        fadeRect.sizeDelta = Vector2.zero;

        // Создаем основной экран загрузки
        loadingScreen = new GameObject("LoadingScreen");
        loadingScreen.transform.SetParent(canvasGO.transform, false);

        RectTransform loadingRect = loadingScreen.AddComponent<RectTransform>();
        loadingRect.anchorMin = Vector2.zero;
        loadingRect.anchorMax = Vector2.one;
        loadingRect.sizeDelta = Vector2.zero;

        // Прогресс бар
        CreateProgressBar();

        // Текст загрузки
        CreateLoadingText();

        // Процентный текст
        CreatePercentageText();
    }

    private void CreateProgressBar()
    {
        GameObject sliderGO = new GameObject("ProgressBar");
        sliderGO.transform.SetParent(loadingScreen.transform, false);

        progressBar = sliderGO.AddComponent<Slider>();
        progressBar.minValue = 0f;
        progressBar.maxValue = 1f;

        RectTransform sliderRect = sliderGO.GetComponent<RectTransform>();
        sliderRect.anchorMin = new Vector2(0.2f, 0.3f);
        sliderRect.anchorMax = new Vector2(0.8f, 0.35f);
        sliderRect.sizeDelta = Vector2.zero;

        // Background
        GameObject bgGO = new GameObject("Background");
        bgGO.transform.SetParent(sliderGO.transform, false);
        Image bgImage = bgGO.AddComponent<Image>();
        bgImage.color = new Color(0.2f, 0.2f, 0.2f, 0.8f);

        RectTransform bgRect = bgImage.GetComponent<RectTransform>();
        bgRect.anchorMin = Vector2.zero;
        bgRect.anchorMax = Vector2.one;
        bgRect.sizeDelta = Vector2.zero;

        progressBar.targetGraphic = bgImage;

        // Fill Area
        GameObject fillAreaGO = new GameObject("Fill Area");
        fillAreaGO.transform.SetParent(sliderGO.transform, false);

        RectTransform fillAreaRect = fillAreaGO.AddComponent<RectTransform>();
        fillAreaRect.anchorMin = Vector2.zero;
        fillAreaRect.anchorMax = Vector2.one;
        fillAreaRect.sizeDelta = Vector2.zero;

        // Fill
        GameObject fillGO = new GameObject("Fill");
        fillGO.transform.SetParent(fillAreaGO.transform, false);
        Image fillImage = fillGO.AddComponent<Image>();
        fillImage.color = new Color(0.3f, 0.7f, 1f, 1f);

        RectTransform fillRect = fillImage.GetComponent<RectTransform>();
        fillRect.anchorMin = Vector2.zero;
        fillRect.anchorMax = Vector2.one;
        fillRect.sizeDelta = Vector2.zero;

        progressBar.fillRect = fillRect;
    }

    private void CreateLoadingText()
    {
        GameObject textGO = new GameObject("LoadingText");
        textGO.transform.SetParent(loadingScreen.transform, false);

        loadingText = textGO.AddComponent<TextMeshProUGUI>();
        loadingText.text = "Загрузка...";
        loadingText.font = font;
        loadingText.fontSize = 36;
        loadingText.color = Color.white;
        loadingText.alignment = TextAlignmentOptions.Midline;

        RectTransform textRect = loadingText.GetComponent<RectTransform>();
        textRect.anchorMin = new Vector2(0f, 0.5f);
        textRect.anchorMax = new Vector2(1f, 0.6f);
        textRect.sizeDelta = Vector2.zero;
    }

    private void CreatePercentageText()
    {
        GameObject percentGO = new GameObject("PercentageText");
        percentGO.transform.SetParent(loadingScreen.transform, false);

        percentageText = percentGO.AddComponent<TextMeshProUGUI>();
        percentageText.text = "0%";
        percentageText.font = font;
        percentageText.fontSize = 24;
        percentageText.color = Color.white;
        percentageText.alignment = TextAlignmentOptions.Midline;

        RectTransform percentRect = percentageText.GetComponent<RectTransform>();
        percentRect.anchorMin = new Vector2(0f, 0.2f);
        percentRect.anchorMax = new Vector2(1f, 0.25f);
        percentRect.sizeDelta = Vector2.zero;
    }

    /// <summary>
    /// Загружает сцену по имени с плавным переходом
    /// </summary>
    public void LoadScene(string sceneName)
    {
        if (!isLoading)
        {
            StartCoroutine(LoadSceneAsync(sceneName));
        }
    }

    /// <summary>
    /// Загружает сцену по индексу с плавным переходом
    /// </summary>
    public void LoadScene(int sceneIndex)
    {
        if (!isLoading)
        {
            StartCoroutine(LoadSceneAsync(sceneIndex));
        }
    }

    /// <summary>
    /// Перезапускает текущую сцену
    /// </summary>
    public void ReloadCurrentScene()
    {
        if (!isLoading)
        {
            Scene current = SceneManager.GetActiveScene();
            StartCoroutine(LoadSceneAsync(current.name));
        }
    }

    /// <summary>
    /// Загружает следующую сцену
    /// </summary>
    public void LoadNextScene()
    {
        if (!isLoading)
        {
            int nextIndex = SceneManager.GetActiveScene().buildIndex + 1;
            if (nextIndex < SceneManager.sceneCountInBuildSettings)
            {
                StartCoroutine(LoadSceneAsync(nextIndex));
            }
            else
            {
                Debug.LogWarning("Следующей сцены нет!");
            }
        }
    }

    /// <summary>
    /// Асинхронная загрузка сцены с визуальными эффектами
    /// </summary>
    private IEnumerator LoadSceneAsync(string sceneName)
    {
        isLoading = true;

        // Фазы загрузки:
        // 1. Плавное затемнение
        yield return StartCoroutine(FadeIn());

        // 2. Показываем экран загрузки
        ShowLoadingScreen();

        // 3. Начинаем загрузку сцены
        AsyncOperation asyncOperation = SceneManager.LoadSceneAsync(sceneName);
        asyncOperation.allowSceneActivation = false;

        float timer = 0f;
        int tipIndex = 0;

        // 4. Обновляем прогресс
        while (!asyncOperation.isDone)
        {
            timer += Time.unscaledDeltaTime;

            // Обновляем прогресс (90% - это загрузка, остальное - активация)
            float progress = Mathf.Clamp01(asyncOperation.progress / 0.9f);
            UpdateProgress(progress);

            // Меняем советы загрузки
            if (timer > (tipIndex + 1) * 0.8f && tipIndex < loadingTips.Length - 1)
            {
                tipIndex++;
                loadingText.text = loadingTips[tipIndex];
            }

            // Если загрузка завершена и прошло минимальное время
            if (asyncOperation.progress >= 0.9f && timer >= minLoadingTime)
            {
                UpdateProgress(1f);
                yield return new WaitForSecondsRealtime(0.3f);
                asyncOperation.allowSceneActivation = true;
            }

            yield return null;
        }

        // 5. Скрываем экран загрузки и плавно появляемся
        yield return StartCoroutine(FadeOut());
        HideLoadingScreen();

        isLoading = false;
    }

    /// <summary>
    /// Асинхронная загрузка сцены по индексу
    /// </summary>
    private IEnumerator LoadSceneAsync(int sceneIndex)
    {
        isLoading = true;

        yield return StartCoroutine(FadeIn());
        ShowLoadingScreen();

        AsyncOperation asyncOperation = SceneManager.LoadSceneAsync(sceneIndex);
        asyncOperation.allowSceneActivation = false;

        float timer = 0f;
        int tipIndex = 0;

        while (!asyncOperation.isDone)
        {
            timer += Time.unscaledDeltaTime;

            float progress = Mathf.Clamp01(asyncOperation.progress / 0.9f);
            UpdateProgress(progress);

            if (timer > (tipIndex + 1) * 0.8f && tipIndex < loadingTips.Length - 1)
            {
                tipIndex++;
                loadingText.text = loadingTips[tipIndex];
            }

            if (asyncOperation.progress >= 0.9f && timer >= minLoadingTime)
            {
                UpdateProgress(1f);
                yield return new WaitForSecondsRealtime(0.3f);
                asyncOperation.allowSceneActivation = true;
            }

            yield return null;
        }

        yield return StartCoroutine(FadeOut());
        HideLoadingScreen();

        isLoading = false;
    }

    /// <summary>
    /// Плавное затемнение экрана
    /// </summary>
    private IEnumerator FadeIn()
    {
        fadeImage.gameObject.SetActive(true);
        float elapsedTime = 0f;
        Color startColor = new Color(0, 0, 0, 0);
        Color endColor = Color.black;

        while (elapsedTime < fadeSpeed)
        {
            elapsedTime += Time.unscaledDeltaTime;
            float t = elapsedTime / fadeSpeed;
            fadeImage.color = Color.Lerp(startColor, endColor, t);
            yield return null;
        }

        fadeImage.color = endColor;
    }

    /// <summary>
    /// Плавное осветление экрана
    /// </summary>
    private IEnumerator FadeOut()
    {
        float elapsedTime = 0f;
        Color startColor = Color.black;
        Color endColor = new Color(0, 0, 0, 0);

        while (elapsedTime < fadeSpeed)
        {
            elapsedTime += Time.unscaledDeltaTime;
            float t = elapsedTime / fadeSpeed;
            fadeImage.color = Color.Lerp(startColor, endColor, t);
            yield return null;
        }

        fadeImage.color = endColor;
        fadeImage.gameObject.SetActive(false);
    }

    /// <summary>
    /// Показывает экран загрузки
    /// </summary>
    private void ShowLoadingScreen()
    {
        if (loadingScreen != null)
        {
            fadeImage.gameObject.SetActive(true);
            loadingScreen.SetActive(true);
            UpdateProgress(0f);
            loadingText.text = loadingTips[0];
        }
    }

    /// <summary>
    /// Скрывает экран загрузки
    /// </summary>
    private void HideLoadingScreen()
    {
        if (loadingScreen != null)
        {
            loadingScreen.SetActive(false);
        }
    }

    /// <summary>
    /// Обновляет прогресс загрузки
    /// </summary>
    private void UpdateProgress(float progress)
    {
        if (progressBar != null)
        {
            progressBar.value = progress;
        }

        if (percentageText != null)
        {
            percentageText.text = Mathf.RoundToInt(progress * 100f) + "%";
        }
    }

    /// <summary>
    /// Выход из игры с плавным затемнением
    /// </summary>
    public void QuitGame()
    {
        StartCoroutine(QuitGameCoroutine());
    }

    private IEnumerator QuitGameCoroutine()
    {
        yield return StartCoroutine(FadeIn());

        Debug.Log("Выход из игры...");
        Application.Quit();

#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }

    /// <summary>
    /// Проверяет, идет ли сейчас загрузка
    /// </summary>
    public bool IsLoading()
    {
        return isLoading;
    }
}