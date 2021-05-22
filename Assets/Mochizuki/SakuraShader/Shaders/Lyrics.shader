/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Lyrics"
{
    Properties
    {
        _MainTex           ("Texture",                           2D) = "white" {}
        _Color             ("Main Color",                     Color) = (0, 0, 0, 1)

        // #region Animation

        [MaterialToggle]
        _AnimEnabled      ("Enable Texture Animation",         Int) = 0
        [NoScaleOffset]
        _AnimSpriteTex    ("Shader ANimation Sprite Texture",   2D) = "while" {}
        _AnimSpriteSplit  ("Shader Animation Sprite Split",    Int) = 1
        _AnimUpdateRate   ("Texture Animation Update Rate",  Float) = 0.0

        // #endregion

        // #region Outline

        [MaterialToggle]
        _OutlineEnabled   ("Enable Outline",                   Int) = 0
        _OutlineColor     ("Outline Color",                  Color) = (0, 0, 0, 1)
        _OutlineWidth     ("Outline Width",       Range(0.0, 20.0)) = 0
        [NoScaleOffset]
        _OutlineTex       ("Outline Texture",                   2D) = "white" {}

        // #endregion

        // #region RotationZ

        [MaterialToggle]
        _RotationEnabled  ("Enable Rotation",                  Int) = 0
        _RotationAngle    ("Rotation Angle",  Range(-180.0, 180.0)) = 0

        // #endregion

        // #region SlideMode

        [MaterialToggle]
        _SlideModeEnabled ("Enable Slide Mode",                Int) = 0
        [Enum(Mochizuki.SakuraShader.ClippingMode)]
        _SlideFrom         ("Slide From",                      Int) = 0
        _SlideWidth        ("Slide Width",         Range(0.0, 1.0)) = 0.0

        // #endregion

        // #region Stencil

        _StencilRef        ("Stencil Reference",               Int) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)]
        _StencilCompare    ("Stencil Compare",                 Int) = 8
        [Enum(UnityEngine.Rendering.StencilOp)]
        _StencilPass       ("Stencil Pass",                    Int) = 0

        // #endregion

        [Enum(UnityEngine.Rendering.CullMode)]
        _Culling           ("Culling",                         Int) = 2
        [Enum(Off, 0, On, 1)]
        _ZWrite            ("ZWrite",                          Int) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
            "IgnoreProjector" = "True"
            "DisableBatching" = "True"
        }

        CGINCLUDE

        #pragma target   4.5
        #pragma vertex   vs
        #pragma fragment fs

        ENDCG

        Pass
        {
            Name   "Lyrics Outline 1"
            
            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   Front
            ZWrite On

            Stencil
            {
                Ref  [_StencilRef]
                Comp [_StencilCompare]
                Pass [_StencilPass]
            }

            CGPROGRAM

            #define SHADER_LYRICS
            #define SHADER_OUTLINE
            #define SHADER_CUSTOM_VERTEX

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name   "Lyrics Outline 2"
            
            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   Front
            ZWrite On

            Stencil
            {
                Ref  [_StencilRef]
                Comp [_StencilCompare]
                Pass [_StencilPass]
            }

            CGPROGRAM

            #define SHADER_LYRICS
            #define SHADER_OUTLINE
            #define SHADER_OUTLINE_REVERSE
            #define SHADER_CUSTOM_VERTEX

            #include "includes/core.cginc"

            ENDCG

        }

        Pass
        {
            Name   "Lyrics"

            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   [_Culling]
            ZWrite [_ZWrite]

            Stencil
            {
                Ref  [_StencilRef]
                Comp [_StencilCompare]
                Pass [_StencilPass]
            }

            CGPROGRAM

            #define SHADER_LYRICS
            #define SHADER_CUSTOM_VERTEX

            #include "includes/core.cginc"

            ENDCG
        }
    }

    CustomEditor "Mochizuki.SakuraShader.LyricsGui"
}