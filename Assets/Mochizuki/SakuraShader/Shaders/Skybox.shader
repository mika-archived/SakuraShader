/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/Skybox"
{
    Properties
    {
        [HideInInspector]
        [NoScaleOffset]
        _MainTex  ("Main Texture",         2D) = "gray" {}
    
        [NoScaleOffset]
        _FrontTex ("Front Texture [+Z]",   2D) = "grey" {}
        [NoScaleOffset]
        _BackTex  ("Back Texture  [-Z]",   2D) = "grey" {}
        [NoScaleOffset]
        _LeftTex  ("Left Texture [+X]",    2D) = "grey" {}
        [NoScaleOffset]
        _RightTex ("Right Texture [-X]",   2D) = "grey" {}
        [NoScaleOffset]
        _UpTex    ("Up Texture [+Y]",      2D) = "gray" {}
        [NoScaleOffset]
        _DownTex  ("Down Texture [-Y]",    2D) = "grey" {}

    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Background"
            "Queue" = "Background"
            "PreviewType" = "Skybox"
            "IgnoreProjector" = "True"
        }

        Cull   Off
        ZWrite Off

        CGINCLUDE

        #pragma target   4.5
        #pragma vertex   vs
        #pragma fragment fs

        #define SHADER_SKYBOX
        #define SHADER_SINGLE_PASS_RENDERING

        ENDCG

        Pass
        {
            Name   "Skybox Front"

            CGPROGRAM

            #define  SHADER_SAMPLER     _FrontTex
            #define  SHADER_SAMPLER_HDR _FrontTex_HDR

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name   "Skybox Back"

            CGPROGRAM

            #define  SHADER_SAMPLER     _BackTex
            #define  SHADER_SAMPLER_HDR _BackTex_HDR

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name   "Skybox Left"

            CGPROGRAM

            #define  SHADER_SAMPLER     _LeftTex
            #define  SHADER_SAMPLER_HDR _LeftTex_HDR

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name   "Skybox Right"

            CGPROGRAM

            #define  SHADER_SAMPLER     _RightTex
            #define  SHADER_SAMPLER_HDR _RightTex_HDR

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name   "Skybox Up"

            CGPROGRAM

            #define  SHADER_SAMPLER     _UpTex
            #define  SHADER_SAMPLER_HDR _UpTex_HDR

            #include "includes/core.cginc"

            ENDCG
        }

        Pass
        {
            Name   "Skybox Down"

            CGPROGRAM

            #define  SHADER_SAMPLER     _DownTex
            #define  SHADER_SAMPLER_HDR _DownTex_HDR

            #include "includes/core.cginc"

            ENDCG
        }
    }

    CustomEditor "Mochizuki.SakuraShader.SkyboxGui"
}