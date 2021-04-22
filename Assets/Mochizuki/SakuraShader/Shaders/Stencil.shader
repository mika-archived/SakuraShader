/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/StencilWrite"
{
    Properties
    {
        // #region

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

            #define SHADER_STENCIL_WRITE
            #define SHADER_OUTLINE

            #include "includes/core.cginc"

            ENDCG
        }
    }

    CustomEditor "Mochizuki.SakuraShader.StencilWriteGui"
}