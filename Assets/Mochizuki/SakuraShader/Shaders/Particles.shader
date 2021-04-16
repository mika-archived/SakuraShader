/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Particles"
{
    Properties
    {
        _MainTex           ("Texture",                          2D) = "white" {}
        _Color             ("Base Color",                    Color) = (0, 0, 0, 1)

        [SSToggleWithoutKeyword]
        _ArrayEnabled      ("Enabled Texture Array",           Int) = 0
        [NoScaleOffset]
        _ArrayTexture      ("Array Texture",               2DArray) = "white" {}
        [Enum(Mochizuki.SakuraShader.IndexSource)]
        _ArrayIndexSource  ("Array Index Source",              Int) = 0
        _ArraySize         ("Array Size of Texture",           Int) = 0

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
            Name   "Particles"

            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   [_Culling]
            ZWrite [_ZWrite]

            CGPROGRAM

            #define SHADER_PARTICLES
            #define SHADER_CUSTOM_VERTEX

            #include "includes/core.cginc"

            ENDCG
        }
    }

    CustomEditor "Mochizuki.SakuraShader.ParticlesGui"
}