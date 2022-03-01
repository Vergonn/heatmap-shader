using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

[ExecuteAlways]
public class HeatmapManager : MonoBehaviour
{
    public Button playButton;
    public TextMeshProUGUI interpolationText;
    public TextMeshProUGUI heatmapText;
    public TextMeshProUGUI heatmap2Text;
    public RawImage heatmapImage;
    public RawImage heatmap2Image;
    public Slider slider;

    public MeshRenderer heatmapRenderer;
    public Texture[] texture;

    public Button[] colorSchemesButtons;
    public Texture[] colorSchemes;

    void Start()
    {
        slider.maxValue = texture.Length - 1;
        slider.onValueChanged.AddListener((value) => OnSliderValueChange(value));
        playButton.onClick.AddListener(() => StartCoroutine(HeatmapAnimation()));

        HeatMapUI(texture[0], texture[1]);

        for (int i = 0; i < colorSchemesButtons.Length; i++)
        {
            int x = i;
            colorSchemesButtons[i].onClick.AddListener(() => { heatmapRenderer.sharedMaterial.SetTexture("_ColorSchemeTex", colorSchemes[x]); });
        }
    }

    private void OnSliderValueChange(float interpolation)
    {
        if (interpolation < texture.Length - 1)
        {
            int currentTexture = (int)(interpolation);
            heatmapRenderer.sharedMaterial.SetTexture("_MainTex", texture[currentTexture]);
            heatmapRenderer.sharedMaterial.SetTexture("_MainTex2", texture[currentTexture + 1]);

            float progress = interpolation % 1;
            heatmapRenderer.sharedMaterial.SetFloat("_Interpolation", progress);
            interpolationText.text = interpolation.ToString();
            HeatMapUI(texture[currentTexture], texture[currentTexture + 1]);
        }
    }

    private IEnumerator HeatmapAnimation()
    {
        float interpolation = 0f;
        int length = texture.Length - 1;

        while (interpolation < length)
        {
            interpolation += Time.deltaTime;
            slider.value = interpolation;

            yield return null;
        }
    }

    private void HeatMapUI(Texture tex1, Texture tex2)
    {
        heatmapText.text = tex1.name;
        heatmapImage.texture = tex1;
        heatmap2Text.text = tex2.name;
        heatmap2Image.texture = tex2;
    }
}
