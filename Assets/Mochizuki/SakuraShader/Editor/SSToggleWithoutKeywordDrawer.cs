/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/
using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    // ReSharper disable once InconsistentNaming
    public class SSToggleWithoutKeywordDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();

            var value = EditorGUI.Toggle(position, label, prop.floatValue >= 0.5f);

            if (EditorGUI.EndChangeCheck())
                prop.floatValue = value ? 1.0f : 0.0f;
        }
    }
}