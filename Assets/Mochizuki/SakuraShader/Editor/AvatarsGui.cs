/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

using UnityEditor;

using UnityEngine;

namespace Mochizuki.SakuraShader
{
    public class AvatarsGui : SakuraShaderGui
    {
        public override void OnGUI(MaterialEditor me, MaterialProperty[] properties)
        {
            var material = (Material) me.target;

            _MainTex = FindProperty(nameof(_MainTex), properties);
            _Color = FindProperty(nameof(_Color), properties);
            _Alpha = FindProperty(nameof(_Alpha), properties);
            _EnableMeshClipping = FindProperty(nameof(_EnableMeshClipping), properties);
            _MeshClippingMode = FindProperty(nameof(_MeshClippingMode), properties);
            _MeshClippingWidth = FindProperty(nameof(_MeshClippingWidth), properties);
            _MeshClippingOffset = FindProperty(nameof(_MeshClippingOffset), properties);
            _EnableTriangleHolograph = FindProperty(nameof(_EnableTriangleHolograph), properties);
            _TriangleHolographHeight = FindProperty(nameof(_TriangleHolographHeight), properties);
            _TriangleHolographAlpha = FindProperty(nameof(_TriangleHolographAlpha), properties);
            _EnableVoxelization = FindProperty(nameof(_EnableVoxelization), properties);
            _VoxelSource = FindProperty(nameof(_VoxelSource), properties);
            _VoxelMinSize = FindProperty(nameof(_VoxelMinSize), properties);
            _VoxelSize = FindProperty(nameof(_VoxelSize), properties);
            _VoxelOffsetN = FindProperty(nameof(_VoxelOffsetN), properties);
            _VoxelOffsetX = FindProperty(nameof(_VoxelOffsetX), properties);
            _VoxelOffsetY = FindProperty(nameof(_VoxelOffsetY), properties);
            _VoxelOffsetZ = FindProperty(nameof(_VoxelOffsetZ), properties);
            _VoxelAnimation = FindProperty(nameof(_VoxelAnimation), properties);
            _VoxelUVSamplingSource = FindProperty(nameof(_VoxelUVSamplingSource), properties);
            _EnableThinOut = FindProperty(nameof(_EnableThinOut), properties);
            _ThinOutSource = FindProperty(nameof(_ThinOutSource), properties);
            _ThinOutMaskTex = FindProperty(nameof(_ThinOutMaskTex), properties);
            _ThinOutNoiseTex = FindProperty(nameof(_ThinOutNoiseTex), properties);
            _ThinOutNoiseThresholdR = FindProperty(nameof(_ThinOutNoiseThresholdR), properties);
            _ThinOutNoiseThresholdG = FindProperty(nameof(_ThinOutNoiseThresholdG), properties);
            _ThinOutNoiseThresholdB = FindProperty(nameof(_ThinOutNoiseThresholdB), properties);
            _ThinOutMinSize = FindProperty(nameof(_ThinOutMinSize), properties);
            _EnableWireframe = FindProperty(nameof(_EnableWireframe), properties);
            _WireframeColor = FindProperty(nameof(_WireframeColor), properties);
            _WireframeThickness = FindProperty(nameof(_WireframeThickness), properties);
            _StencilRef = FindProperty(nameof(_StencilRef), properties);
            _StencilCompare = FindProperty(nameof(_StencilCompare), properties);
            _StencilPass = FindProperty(nameof(_StencilPass), properties);
            _BlendMode = FindProperty(nameof(_BlendMode), properties);
            _BlendSrcFactor = FindProperty(nameof(_BlendSrcFactor), properties);
            _BlendDestFactor = FindProperty(nameof(_BlendDestFactor), properties);

            _Culling = FindProperty(nameof(_Culling), properties);
            _ZWrite = FindProperty(nameof(_ZWrite), properties);

            OnHeaderGui("Avatars Shader");
            OnInitialize(material);

            OnMainGui(me, material);
            OnMeshClippingGui(me);
            OnTriangleHolographGui(me);
            OnVoxelizationGui(me);
            OnThinOutGui(me);
            OnWireframeGui(me);
            OnStencilGui(me);
            OnOthersGui(me, _Culling, _ZWrite);
        }

        private void OnMainGui(MaterialEditor me, Material mat)
        {
            using (new Section("Main"))
            {
                me.TexturePropertySingleLine(new GUIContent("Main Texture"), _MainTex);
                me.TextureScaleOffsetProperty(_MainTex);

                me.ShaderProperty(_Color, "Color");

                me.ShaderProperty(_BlendMode, "Blending Mode");

                if (IsEqualsTo(_BlendMode, (int) BlendMode.Opaque))
                {
                    mat.SetOverrideTag("RenderType", "Opaque");
                    mat.SetInt(nameof(_BlendSrcFactor), (int) UnityEngine.Rendering.BlendMode.One);
                    mat.SetInt(nameof(_BlendDestFactor), (int) UnityEngine.Rendering.BlendMode.Zero);
                }
                /*
                else if (IsEqualsTo(_BlendMode, (int) BlendMode.Cutout))
                {
                    mat.SetOverrideTag("RenderType", "TransparentCutoff");
                    mat.SetInt(nameof(_BlendSrcFactor), (int) UnityEngine.Rendering.BlendMode.One);
                    mat.SetInt(nameof(_BlendDstFactor), (int) UnityEngine.Rendering.BlendMode.Zero);
                }
                */
                else if (IsEqualsTo(_BlendMode, (int) BlendMode.Transparent))
                {
                    mat.SetOverrideTag("RenderType", "Transparent");
                    mat.SetInt(nameof(_BlendSrcFactor), (int) UnityEngine.Rendering.BlendMode.SrcAlpha);
                    mat.SetInt(nameof(_BlendDestFactor), (int) UnityEngine.Rendering.BlendMode.OneMinusSrcAlpha);
                }

                using (new EditorGUI.DisabledGroupScope(!IsEqualsTo(_BlendMode, (int) BlendMode.Transparent)))
                    me.ShaderProperty(_Alpha, "Alpha Transparency");
            }
        }

        private void OnMeshClippingGui(MaterialEditor me)
        {
            OnToggleGui(me, "Mesh Clipping", _EnableMeshClipping, "Enable Mesh Clipping", () =>
            {
                me.ShaderProperty(_MeshClippingMode, "Mode");
                me.ShaderProperty(_MeshClippingWidth, "Width");
                me.ShaderProperty(_MeshClippingOffset, "Offset");
            });
        }

        private void OnTriangleHolographGui(MaterialEditor me)
        {
            OnToggleGui(me, "Triangle Holograph", _EnableTriangleHolograph, "Enable Triangle Holograph", () =>
            {
                me.ShaderProperty(_TriangleHolographHeight, "Height");
                me.ShaderProperty(_TriangleHolographAlpha, "Alpha Transparency");
            });
        }

        private void OnVoxelizationGui(MaterialEditor me)
        {
            OnToggleGui(me, "Voxelization", _EnableVoxelization, "Enable Voxelization", () =>
            {
                me.ShaderProperty(_VoxelSource, "Voxel Calculation Source");
                me.ShaderProperty(_VoxelUVSamplingSource, "UV Sampling Source");

                using (new EditorGUI.DisabledGroupScope(!IsEqualsTo(_VoxelSource, (int) VoxelSource.Vertex)))
                    me.ShaderProperty(_VoxelMinSize, "Minimal Size");
                using (new EditorGUI.DisabledGroupScope(!IsEqualsTo(_VoxelSource, (int) VoxelSource.ShaderProperty)))
                    me.ShaderProperty(_VoxelSize, "Size");

                me.ShaderProperty(_VoxelOffsetN, "Offset Normal");
                me.ShaderProperty(_VoxelOffsetX, "Offset X");
                me.ShaderProperty(_VoxelOffsetY, "Offset Y");
                me.ShaderProperty(_VoxelOffsetZ, "Offset Z");

                me.ShaderProperty(_VoxelAnimation, "Enable Voxel Animation");
            });
        }

        private void OnThinOutGui(MaterialEditor me)
        {
            OnToggleGui(me, "Thin Out", _EnableThinOut, "Enable Thin Out", () =>
            {
                me.ShaderProperty(_ThinOutSource, "ThinOut Source");

                using (new EditorGUI.DisabledGroupScope(!IsEqualsTo(_ThinOutSource, (int) ThinOutSource.MaskTexture)))
                    me.TexturePropertySingleLine(new GUIContent("Mask Texture"), _ThinOutMaskTex);

                using (new EditorGUI.DisabledGroupScope(!IsEqualsTo(_ThinOutSource, (int) ThinOutSource.NoiseTexture)))
                {
                    me.TexturePropertySingleLine(new GUIContent("Noise Texture *"), _ThinOutNoiseTex);
                    me.ShaderProperty(_ThinOutNoiseThresholdR, "Noise Threshold R *");
                    me.ShaderProperty(_ThinOutNoiseThresholdG, "Noise Threshold G *");
                    me.ShaderProperty(_ThinOutNoiseThresholdB, "Noise Threshold B *");
                }

                using (new EditorGUI.DisabledGroupScope(!IsEqualsTo(_ThinOutSource, (int) ThinOutSource.ShaderProperty)))
                    me.ShaderProperty(_ThinOutMinSize, "Voxel Minimal Size *");
            });
        }

        private void OnWireframeGui(MaterialEditor me)
        {
            OnToggleGui(me, "Wireframe", _EnableWireframe, "Enable Wireframe", () =>
            {
                me.ShaderProperty(_WireframeColor, "Color");
                me.ShaderProperty(_WireframeThickness, "Thickness");
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
        private MaterialProperty _Alpha;
        private MaterialProperty _EnableMeshClipping;
        private MaterialProperty _MeshClippingMode;
        private MaterialProperty _MeshClippingWidth;
        private MaterialProperty _MeshClippingOffset;
        private MaterialProperty _EnableTriangleHolograph;
        private MaterialProperty _TriangleHolographHeight;
        private MaterialProperty _TriangleHolographAlpha;
        private MaterialProperty _EnableVoxelization;
        private MaterialProperty _VoxelSource;
        private MaterialProperty _VoxelMinSize;
        private MaterialProperty _VoxelSize;
        private MaterialProperty _VoxelOffsetN;
        private MaterialProperty _VoxelOffsetX;
        private MaterialProperty _VoxelOffsetY;
        private MaterialProperty _VoxelOffsetZ;
        private MaterialProperty _VoxelAnimation;
        private MaterialProperty _VoxelUVSamplingSource;
        private MaterialProperty _EnableThinOut;
        private MaterialProperty _ThinOutSource;
        private MaterialProperty _ThinOutMaskTex;
        private MaterialProperty _ThinOutNoiseTex;
        private MaterialProperty _ThinOutNoiseThresholdR;
        private MaterialProperty _ThinOutNoiseThresholdG;
        private MaterialProperty _ThinOutNoiseThresholdB;
        private MaterialProperty _ThinOutMinSize;
        private MaterialProperty _EnableWireframe;
        private MaterialProperty _WireframeColor;
        private MaterialProperty _WireframeThickness;
        private MaterialProperty _StencilRef;
        private MaterialProperty _StencilCompare;
        private MaterialProperty _StencilPass;
        private MaterialProperty _BlendMode;
        private MaterialProperty _BlendSrcFactor;
        private MaterialProperty _BlendDestFactor;

        private MaterialProperty _Culling;
        private MaterialProperty _ZWrite;

        // ReSharper restore InconsistentNaming
    }
}