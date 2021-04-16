/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/
using System;

using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    internal static class ShaderUtility
    {
        public static void OnToggleGui(MaterialEditor me, string section, MaterialProperty toggleProperty, string toggleTitle, Action callback)
        {
            using (new Section(section))
            {
                me.ShaderProperty(toggleProperty, toggleTitle);

                using (new EditorGUI.DisabledGroupScope(IsEqualsTo(toggleProperty, false)))
                using (new EditorGUI.IndentLevelScope())
                    callback.Invoke();
            }
        }

        public static bool IsEqualsTo(MaterialProperty a, int b)
        {
            return b - 0.5 < a.floatValue && a.floatValue <= b + 0.5;
        }

        public static bool IsEqualsTo(MaterialProperty a, bool b)
        {
            return IsEqualsTo(a, b ? 1 : 0);
        }

        public class Section : IDisposable
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