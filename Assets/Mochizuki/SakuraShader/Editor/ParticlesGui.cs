using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class ParticlesGui : SakuraShaderGui
    {
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

            OnHeaderGui("Particles Shader");
            OnInitialize(material);

            OnMainGui(me);
            OnArrayGui(me);
            OnOthersGui(me, _Culling, _ZWrite);
        }

        private void OnMainGui(MaterialEditor me)
        {
            using (new Section("Main"))
            {
                me.TexturePropertySingleLine(new GUIContent("Main Texture"), _MainTex);
                me.TextureScaleOffsetProperty(_MainTex);

                me.ShaderProperty(_Color, "Color");
            }
        }

        private void OnArrayGui(MaterialEditor me)
        {
            OnToggleGui(me, "Texture Array (Sprite)", _ArrayEnabled, "Enable Texture Array", () =>
            {
                me.TexturePropertySingleLine(new GUIContent("Texture Array"), _ArrayTexture);

                me.ShaderProperty(_ArrayIndexSource, "Array Index Source");
                me.ShaderProperty(_ArraySize, "Size of Texture Array");

                EditorGUILayout.Space();
                EditorGUILayout.HelpBox("Texture Array replaces Main Texture", MessageType.Info);
            });
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