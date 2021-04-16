/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/ScreenFX"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        // #region Brightness

        [MaterialToggle]
        _BrightnessEnabled  ("Enable Brightness",                Int) = 0
        _BrightnessStrength ("Brightness Strength", Range(-1.0, 1.0)) = 0.0

        // #endregion

        // #region Cinemascope

        [MaterialToggle]
        _CinemascopeEnabled ("Enable Cinemascope",            Int) = 0
        _CinemascopeColor   ("Cinemascope Color",           Color) = (0, 0, 0, 1)
        _CinemascopeWidth   ("Cinemascope Width", Range(0.0, 1.0)) = 0.0

        // #endregion

        // #region Color Overlay

        [MaterialToggle]
        _ColorOverlayEnabled ("Enable Color Overlay",            Int) = 0
        _ColorOverlayR       ("Color Overlay Red",   Range(0.0, 1.0)) = 0.0
        _ColorOverlayG       ("Color Overlay Green", Range(0.0, 1.0)) = 0.0
        _ColorOverlayB       ("Color Overlay Blue",  Range(0.0, 1.0)) = 0.0

        // #endregion
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Overlay"
            "Queue" = "Overlay"
            "IgnoreProjector" = "False"
        }

        CGINCLUDE

        #pragma target   4.5
        #pragma vertex   vs
        #pragma fragment fs

        ENDCG

        Pass
        {
            Name  "ScreenFX"

            Blend  SrcAlpha OneMinusSrcAlpha
            Cull   Off
            ZTest  Always
            ZWrite On

            CGPROGRAM

            #define SHADER_SCREEN_FX

            #include "includes/core.cginc"

            ENDCG
        }
    }

    CustomEditor "Mochizuki.SakuraShader.ScreenFxGui"
}
