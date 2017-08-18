using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PhosphorMonitor : MonoBehaviour {
    private Shader shader;
    private Material material;
    [Range(0.0f, 1.0f)]
    public float vignette = 0.35f;
    [Range(0.0f, 1.0f)]
    public float green = 0.5f;
    [Range(0.0f, 1.0f)]
    public float white = 0.8f;

    public void Start() {
        shader = new Shader();
        shader = Shader.Find("Hidden/PhosphorMonitor");
        material = new Material(shader);

        if (!SystemInfo.supportsImageEffects) {
            enabled = false;
            return;
        }

        if (!shader && !shader.isSupported) {
            enabled = false;
        }
    }

    public void OnRenderImage(RenderTexture inTexture, RenderTexture outTexture) {
        if (shader != null) {
            material.SetInt("_Scanline", Screen.height);
            material.SetFloat("_Vignette", vignette);
            material.SetFloat("_Green", green);
            material.SetFloat("_White", white);
            Graphics.Blit(inTexture, outTexture, material);
        }
        else {
            Graphics.Blit(inTexture, outTexture);
        }
    }
}
