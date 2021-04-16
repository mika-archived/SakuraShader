using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class ParticlesGui : ShaderGUI
    {
        private bool _isInitialized;

        public override void OnGUI(MaterialEditor me, MaterialProperty[] properties)
        {
            var material = (Material) me.target;

            _MainTex = FindProperty(nameof(_MainTex), properties, false);
            _Color = FindProperty(nameof(_Color), properties, false);
            _ArrayEnabled = FindProperty(nameof(_ArrayEnabled), properties, false);
            _ArrayTexture = FindProperty(nameof(_ArrayTexture), properties, false);
            _ArrayIndexSource = FindProperty(nameof(_ArrayIndexSource), properties, false);
            _ArraySize = FindProperty(nameof(_ArraySize), properties, false);

            _Culling = FindProperty(nameof(_Culling), properties, false);
            _ZWrite = FindProperty(nameof(_ZWrite), properties, false);

            using (new EditorGUILayout.VerticalScope())
            {
                EditorStyles.label.wordWrap = true;

                using (new ShaderUtility.Section("Particles Shader"))
                    EditorGUILayout.LabelField("Particles Shader - Part of Sakura Shader by Natsuneko");
            }

            OnInitialize(material);

            OnMainGui(me);
            OnArrayGui(me);
            OnOthersGui(me);
        }

        private void OnInitialize(Material material)
        {
            if (_isInitialized)
                return;
            _isInitialized = true;

            foreach (var keyword in material.shaderKeywords)
                material.DisableKeyword(keyword);
        }

        private void OnMainGui(MaterialEditor me)
        {
            using (new ShaderUtility.Section("Main"))
            {
                me.TexturePropertySingleLine(new GUIContent("Main Texture"), _MainTex);
                me.TextureScaleOffsetProperty(_MainTex);

                me.ShaderProperty(_Color, "Color");
            }
        }

        private void OnArrayGui(MaterialEditor me)
        {
            ShaderUtility.OnToggleGui(me, "Texture Array (Sprite)", _ArrayEnabled, "Enable Texture Array", () =>
            {
                me.TexturePropertySingleLine(new GUIContent("Texture Array"), _ArrayTexture);

                me.ShaderProperty(_ArrayIndexSource, "Array Index Source");
                me.ShaderProperty(_ArraySize, "Size of Texture Array");

                EditorGUILayout.Space();
                EditorGUILayout.HelpBox("Texture Array replaces Main Texture", MessageType.Info);
            });
        }

        private void OnOthersGui(MaterialEditor me)
        {
            using (new ShaderUtility.Section("Others"))
            {
                me.ShaderProperty(_Culling, "Culling");
                me.ShaderProperty(_ZWrite, "ZWrite");
                me.RenderQueueField();
                me.DoubleSidedGIField();
            }
        }

        // ReSharper disable InconsistentNaming

        private MaterialProperty _MainTex;
        private MaterialProperty _Color;
        private MaterialProperty _ArrayEnabled;
        private MaterialProperty _ArrayTexture;
        private MaterialProperty _ArrayIndexSource;
        private MaterialProperty _ArraySize;

        private MaterialProperty _Culling;
        private MaterialProperty _ZWrite;

        // ReSharper restore InconsistentNaming
    }
}