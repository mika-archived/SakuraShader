/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Avatars"
{
    Properties
    {
        _MainTex                 ("Texture",                       2D) = "white" {}
        _Color                   ("Main Color",                 Color) = (0, 0, 0, 1)
        _Alpha                   ("Alpha Transparent",    Range(0, 1)) = 1

        // #region Mesh Clipping

        [SSToggleWithoutKeyword]
        _EnableMeshClipping      ("Enable Mesh Clipping",         Int) = 0
        [Enum(Mochizuki.SakuraShader.ClippingMode)]
        _MeshClippingMode        ("Mesh Clipping Mode",           Int) = 0
        _MeshClippingWidth       ("Mesh Clipping Width",  Range(0, 1)) = 1
        _MeshClippingOffset      ("Mesh Clipping Offset", Range(0, 1)) = 0

        // #endregion

        // #region TriangleHolograph

        [SSToggleWithoutKeyword]
        _EnableTriangleHolograph ("Enable Triangle Holograph",    Int) = 0
        _TriangleHolographHeight ("Tris Holograph Height",      Float) = 0
        _TriangleHolographAlpha  ("Tris Holograph Alpha", Range(0, 1)) = 1

        // #endregion

        // #region Voxelization

        [SSToggleWithoutKeyword]
        _EnableVoxelization      ("Enable Voxelization",          Int) = 1
        [Enum(Mochizuki.SakuraShader.VoxelSource)]
        _VoxelSource             ("Voxel Source",                 Int) = 1
        _VoxelMinSize            ("Voxel Minimal Size",         Float) = 0
        _VoxelSize               ("Voxel Size",                 Float) = 0.0125
        _VoxelOffsetN            ("Voxel offset Normal",        Float) = 0
        _VoxelOffsetX            ("Voxel Offset X",             Float) = 0
        _VoxelOffsetY            ("Voxel Offset Y",             Float) = 0
        _VoxelOffsetZ            ("Voxel Offset X",             Float) = 0
        [SSToggleWithoutKeyword]
        _VoxelAnimation          ("Enable Voxel Animation",       Int) = 1
        [Enum(Mochizuki.SakuraShader.UvSamplingSource)]
        _VoxelUVSamplingSource   ("UV Sampling Source",           Int) = 0

        // #endregion

        // #region ThinOut

        [SSToggleWithoutKeyword]
        _EnableThinOut          ("Enable ThinOut",               Int) = 0
        [Enum(Mochizuki.SakuraShader.ThinOutSource)]
        _ThinOutSource          ("ThinOut Source",               Int) = 0
        [NoScaleOffset]
        _ThinOutMaskTex         ("ThinOut Mask Texture",          2D) = "white" {}
        [NoScaleOffset]
        _ThinOutNoiseTex        ("ThinOut Noise Texture",         2D) = "white" {}
        _ThinOutNoiseThresholdR ("ThinOut Noise Threshold R",  Float) = 1
        _ThinOutNoiseThresholdG ("ThinOut Noise Threshold G",  Float) = 1
        _ThinOutNoiseThresholdB ("ThinOut Noise Threshold B",  Float) = 1
        _ThinOutMinSize         ("ThinOut Minimal Size",       Float) = 1

        // #endregion

        // #region Wireframe

        [SSToggleWithoutKeyword]
        _EnableWireframe        ("Enable Wireframe",            Int) = 0
        _WireframeColor         ("Wireframe Color",           Color) = (0, 0, 0, 1)
        _WireframeThickness     ("Wireframe Thickness", Range(0, 1)) = 0.125
        // #endregion

        // #region Stencil

        _StencilRef              ("Stencil Reference",           Int) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)]
        _StencilCompare          ("Stencil Compare",             Int) = 8
        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilPass             ("Stencil Pass",                Int) = 0

        // #endregion

        // #region Metadata
        [Enum(Mochizuki.SakuraShader.BlendMode)]
        _BlendMode               ("Blend Mode",                  Int) = 0

        // #endregion

        [Enum(UnityEngine.Rendering.BlendMode)]
        [HideInInspector]
        _BlendSrcFactor          ("Blend Src Factor",            Int) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        [HideInInspector]
        _BlendDestFactor         ("Blend Dest Factor",           Int) = 10
        [Enum(UnityEngine.Rendering.CullMode)]
        _Culling                 ("Culling",                     Int) = 2
        [Enum(Off, 0, On, 1)]
        _ZWrite                  ("ZWrite",                      Int) = 1
    }

    SubShader
    {
        LOD 0

        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
            "IgnoreProjector" = "False"
            "DisableBatching" = "True"
        }

        CGINCLUDE

        #pragma require  geometry
        #pragma target   4.5
        #pragma vertex   vs
        #pragma geometry gs
        #pragma fragment fs

        #define SHADER_AVATARS

        ENDCG

        Pass
        {
            Name "Avatars Voxel Geometry"

            Blend  [_BlendSrcFactor] [_BlendDestFactor]
            Cull   [_Culling]
            ZWrite [_ZWrite]

            Stencil
            {
                Ref  [_StencilRef]
                Comp [_StencilCompare]
                Pass [_StencilPass]
            }

            CGPROGRAM

            #define SHADER_AVATARS_VG

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name "Avatars Wireframe"

            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   Off
            ZWrite [_ZWrite]

            Stencil
            {
                Ref  [_StencilRef]
                Comp [_StencilCompare]
                Pass [_StencilPass]
            }

            CGPROGRAM

            #define SHADER_AVATARS_WF

            #include "includes/core.cginc"

            ENDCG

        }

        Pass
        {
            Name "Avatars Triangle Holograph"

            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   Off
            ZWrite [_ZWrite]

            Stencil
            {
                Ref  [_StencilRef]
                Comp [_StencilCompare]
                Pass [_StencilPass]
            }

            CGPROGRAM

            #define SHADER_AVATARS_TH

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name "Avatars ShadowCaster"

            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            ZWrite On

            CGPROGRAM

            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog

            #define SHADER_AVATARS_VG
            #define SHADER_AVATARS_SC

            #include "includes/core.cginc"

            ENDCG
        }

    }

    CustomEditor "Mochizuki.SakuraShader.AvatarsGui"
}