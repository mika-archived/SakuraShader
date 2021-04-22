using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class ScreenFxGui : SakuraShaderGui
    {
        public override void OnGUI(MaterialEditor me, MaterialProperty[] properties)
        {
            var material = (Material) me.target;

            _BrightnessEnabled = FindProperty(nameof(_BrightnessEnabled), properties);
            _BrightnessStrength = FindProperty(nameof(_BrightnessStrength), properties);
            _CinemascopeEnabled = FindProperty(nameof(_CinemascopeEnabled), properties);
            _CinemascopeColor = FindProperty(nameof(_CinemascopeColor), properties);
            _CinemascopeWidth = FindProperty(nameof(_CinemascopeWidth), properties);
            _ColorOverlayEnabled = FindProperty(nameof(_ColorOverlayEnabled), properties);
            _ColorOverlayR = FindProperty(nameof(_ColorOverlayR), properties);
            _ColorOverlayG = FindProperty(nameof(_ColorOverlayG), properties);
            _ColorOverlayB = FindProperty(nameof(_ColorOverlayB), properties);

            OnHeaderGui("ScreenFX Shader");
            OnInitialize(material);

            OnBrightnessGui(me);
            OnCinemascopeGui(me);
            OnColorOverlayGui(me);
            OnOthersGui(me, null, null);
        }

        private void OnBrightnessGui(MaterialEditor me)
        {
            OnToggleGui(me, "Brightness", _BrightnessEnabled, "Enable Brightness", () =>
            {
                //
                me.ShaderProperty(_BrightnessStrength, "Strength");
            });
        }

        private void OnCinemascopeGui(MaterialEditor me)
        {
            OnToggleGui(me, "Cinemascope", _CinemascopeEnabled, "Enable Cinemascope", () =>
            {
                me.ColorProperty(_CinemascopeColor, "Color");
                me.ShaderProperty(_CinemascopeWidth, "Width");
            });
        }

        private void OnColorOverlayGui(MaterialEditor me)
        {
            OnToggleGui(me, "Color Overlay", _ColorOverlayEnabled, "Enable Color Overlay", () =>
            {
                me.ShaderProperty(_ColorOverlayR, "Red");
                me.ShaderProperty(_ColorOverlayG, "Green");
                me.ShaderProperty(_ColorOverlayB, "Blue");
            });
        }

        // ReSharper disable InconsistentNaming

        private MaterialProperty _BrightnessEnabled;
        private MaterialProperty _BrightnessStrength;
        private MaterialProperty _CinemascopeColor;
        private MaterialProperty _CinemascopeEnabled;
        private MaterialProperty _CinemascopeWidth;
        private MaterialProperty _ColorOverlayEnabled;
        private MaterialProperty _ColorOverlayR;
        private MaterialProperty _ColorOverlayG;
        private MaterialProperty _ColorOverlayB;

        // ReSharper restore InconsistentNaming
    }
}