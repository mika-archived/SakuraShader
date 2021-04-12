/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Unlit"
{
    Properties
    {
        _MainTex           ("Texture",                  2D) = "white" {}
        _Color             ("Main Color",            Color) = (0, 0, 0, 1)
        _Alpha             ("Alpha Blend", Range(0.0, 1.0)) = 1.0

        [Enum(UnityEngine.Rendering.CullMode)]
        _Culling           ("Culling",                 Int) = 2
        [Enum(Off, 0, On, 1)]
        _ZWrite            ("ZWrite",                  Int) = 1

    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
        }

        CGINCLUDE

        #pragma target   4.5
        #pragma vertex   vs
        #pragma fragment fs

        ENDCG

        Pass
        {
            Name   "Lyrics"

            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   [_Culling]
            ZWrite [_ZWrite]

            CGPROGRAM

            #define SHADER_UNLIT

            #include "includes/core.cginc"

            ENDCG
        }
    }
}