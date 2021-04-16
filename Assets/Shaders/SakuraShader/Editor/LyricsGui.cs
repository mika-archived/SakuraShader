/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/
using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class LyricsGui : ShaderGUI
    {
        private bool _isInitialized;

        public override void OnGUI(MaterialEditor me, MaterialProperty[] properties)
        {
            var material = (Material) me.target;

            _MainTex = FindProperty(nameof(_MainTex), properties);
            _Color = FindProperty(nameof(_Color), properties);
            _AnimEnabled = FindProperty(nameof(_AnimEnabled), properties);
            _AnimSpriteTex = FindProperty(nameof(_AnimSpriteTex), properties);
            _AnimSpriteSplit = FindProperty(nameof(_AnimSpriteSplit), properties);
            _AnimUpdateRate = FindProperty(nameof(_AnimUpdateRate), properties);
            _OutlineEnabled = FindProperty(nameof(_OutlineEnabled), properties);
            _OutlineColor = FindProperty(nameof(_OutlineColor), properties);
            _OutlineWidth = FindProperty(nameof(_OutlineWidth), properties);
            _OutlineTex = FindProperty(nameof(_OutlineTex), properties);
            _RotationEnabled = FindProperty(nameof(_RotationEnabled), properties);
            _RotationAngle = FindProperty(nameof(_RotationAngle), properties);
            _SlideModeEnabled = FindProperty(nameof(_SlideModeEnabled), properties);
            _SlideFrom = FindProperty(nameof(_SlideFrom), properties);
            _SlideWidth = FindProperty(nameof(_SlideWidth), properties);

            _Culling = FindProperty(nameof(_Culling), properties);
            _ZWrite = FindProperty(nameof(_ZWrite), properties);

            using (new EditorGUILayout.VerticalScope())
            {
                EditorStyles.label.wordWrap = true;

                using (new ShaderUtility.Section("Lyrics Shader"))
                    EditorGUILayout.LabelField("Lyrics Shader - Part of Sakura Shader by Natsuneko");
            }

            OnInitialize(material);

            OnMainGui(me);
            OnAnimationGui(me);
            OnOutlineGui(me);
            OnRotationGui(me);
            OnSlideMode(me);
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

        private void OnAnimationGui(MaterialEditor me)
        {
            ShaderUtility.OnToggleGui(me, "Animation", _AnimEnabled, "Enable Shader Animation", () =>
            {
                me.TexturePropertySingleLine(new GUIContent("Animation Sprite Texture"), _AnimSpriteTex);
                me.ShaderProperty(_AnimSpriteSplit, "Sprite Split Horizontal");
                me.ShaderProperty(_AnimUpdateRate, "Sprite Animation Update Rate");
            });
        }

        private void OnOutlineGui(MaterialEditor me)
        {
            ShaderUtility.OnToggleGui(me, "Outline", _OutlineEnabled, "Enable Outline", () =>
            {
                me.TexturePropertySingleLine(new GUIContent("Outline Texture"), _OutlineTex);
                me.ShaderProperty(_OutlineColor, "Outline Color");
                me.ShaderProperty(_OutlineWidth, "Outline Width");
            });
        }

        private void OnRotationGui(MaterialEditor me)
        {
            ShaderUtility.OnToggleGui(me, "Rotation", _RotationEnabled, "Enable Rotation", () =>
            {
                //
                me.ShaderProperty(_RotationAngle, "Rotation Angle");
            });
        }

        private void OnSlideMode(MaterialEditor me)
        {
            ShaderUtility.OnToggleGui(me, "Slide", _SlideModeEnabled, "Enable Slide Animation", () =>
            {
                me.ShaderProperty(_SlideFrom, "Slide Mode");
                me.ShaderProperty(_SlideWidth, "Slide Width");
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

        private new static MaterialProperty FindProperty(string name, MaterialProperty[] properties)
        {
            return FindProperty(name, properties, false);
        }

        // ReSharper disable InconsistentNaming

        private MaterialProperty _MainTex;
        private MaterialProperty _Color;
        private MaterialProperty _AnimEnabled;
        private MaterialProperty _AnimSpriteTex;
        private MaterialProperty _AnimSpriteSplit;
        private MaterialProperty _AnimUpdateRate;
        private MaterialProperty _OutlineEnabled;
        private MaterialProperty _OutlineColor;
        private MaterialProperty _OutlineWidth;
        private MaterialProperty _OutlineTex;
        private MaterialProperty _RotationEnabled;
        private MaterialProperty _RotationAngle;
        private MaterialProperty _SlideModeEnabled;
        private MaterialProperty _SlideFrom;
        private MaterialProperty _SlideWidth;

        private MaterialProperty _Culling;
        private MaterialProperty _ZWrite;

        // ReSharper restore InconsistentNaming
    }
}