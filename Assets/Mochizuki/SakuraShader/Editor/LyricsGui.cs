/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class LyricsGui : SakuraShaderGui
    {
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
            _StencilRef = FindProperty(nameof(_StencilRef), properties);
            _StencilCompare = FindProperty(nameof(_StencilCompare), properties);
            _StencilPass = FindProperty(nameof(_StencilPass), properties);

            _Culling = FindProperty(nameof(_Culling), properties);
            _ZWrite = FindProperty(nameof(_ZWrite), properties);

            OnHeaderGui("Lyrics Shader");
            OnInitialize(material);

            OnMainGui(me);
            OnAnimationGui(me);
            OnOutlineGui(me);
            OnRotationGui(me);
            OnSlideMode(me);
            OnStencilGui(me);
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

        private void OnAnimationGui(MaterialEditor me)
        {
            OnToggleGui(me, "Animation", _AnimEnabled, "Enable Shader Animation", () =>
            {
                me.TexturePropertySingleLine(new GUIContent("Animation Sprite Texture"), _AnimSpriteTex);
                me.ShaderProperty(_AnimSpriteSplit, "Sprite Split Horizontal");
                me.ShaderProperty(_AnimUpdateRate, "Sprite Animation Update Rate");
            });
        }

        private void OnOutlineGui(MaterialEditor me)
        {
            OnToggleGui(me, "Outline", _OutlineEnabled, "Enable Outline", () =>
            {
                me.TexturePropertySingleLine(new GUIContent("Outline Texture"), _OutlineTex);
                me.ShaderProperty(_OutlineColor, "Outline Color");
                me.ShaderProperty(_OutlineWidth, "Outline Width");
            });
        }

        private void OnRotationGui(MaterialEditor me)
        {
            OnToggleGui(me, "Rotation", _RotationEnabled, "Enable Rotation", () =>
            {
                //
                me.ShaderProperty(_RotationAngle, "Rotation Angle");
            });
        }

        private void OnSlideMode(MaterialEditor me)
        {
            OnToggleGui(me, "Slide", _SlideModeEnabled, "Enable Slide Animation", () =>
            {
                me.ShaderProperty(_SlideFrom, "Slide Mode");
                me.ShaderProperty(_SlideWidth, "Slide Width");
            });
        }

        private void OnStencilGui(MaterialEditor me)
        {
            using (new Section("Stencil"))
            {
                me.ShaderProperty(_StencilRef, "Reference");
                me.ShaderProperty(_StencilCompare, "Compare Function");
                me.ShaderProperty(_StencilPass, "Pass");
            }
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
        private MaterialProperty _StencilRef;
        private MaterialProperty _StencilCompare;
        private MaterialProperty _StencilPass;

        private MaterialProperty _Culling;
        private MaterialProperty _ZWrite;

        // ReSharper restore InconsistentNaming
    }
}