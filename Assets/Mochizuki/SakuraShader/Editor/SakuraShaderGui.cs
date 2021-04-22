using System;

using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class SakuraShaderGui : ShaderGUI
    {
        private bool _isInitialized;

        protected SakuraShaderGui()
        {
            _isInitialized = false;
        }

        protected void OnHeaderGui(string title)
        {
            EditorStyles.label.wordWrap = true;

            using (new Section(title))
                EditorGUILayout.LabelField($"{title} - Part of Sakura Shader by Natsuneko");

            EditorStyles.label.wordWrap = false;
        }

        protected void OnInitialize(Material material)
        {
            if (_isInitialized)
                return;
            _isInitialized = true;

            foreach (var keyword in material.shaderKeywords)
                material.DisableKeyword(keyword);
        }

        protected void OnOthersGui(MaterialEditor me, MaterialProperty culling, MaterialProperty zw)
        {
            using (new Section("Others"))
            {
                if (culling != null)
                    me.ShaderProperty(culling, "Culling");
                if (zw != null)
                    me.ShaderProperty(zw, "ZWrite");

                me.RenderQueueField();
                me.DoubleSidedGIField();
            }
        }

        protected void OnToggleGui(MaterialEditor me, string sectionTitle, MaterialProperty toggleProperty, string toggleTitle, Action callback)
        {
            using (new Section(sectionTitle))
            {
                me.ShaderProperty(toggleProperty, toggleTitle);

                using (new EditorGUI.DisabledGroupScope(IsEqualsTo(toggleProperty, false)))
                using (new EditorGUI.IndentLevelScope())
                    callback.Invoke();
            }
        }

        protected static bool IsEqualsTo(MaterialProperty a, int b)
        {
            return b - 0.5 < a.floatValue && a.floatValue <= b + 0.5;
        }

        protected static bool IsEqualsTo(MaterialProperty a, bool b)
        {
            return IsEqualsTo(a, b ? 1 : 0);
        }

        protected new static MaterialProperty FindProperty(string name, MaterialProperty[] properties)
        {
            return FindProperty(name, properties, false);
        }

        protected class Section : IDisposable
        {
            private readonly IDisposable _disposable;

            public Section(string title)
            {
                GUILayout.Label(title, EditorStyles.boldLabel);
                _disposable = new EditorGUILayout.VerticalScope(GUI.skin.box);
            }

            public void Dispose()
            {
                _disposable.Dispose();
            }
        }
    }
}