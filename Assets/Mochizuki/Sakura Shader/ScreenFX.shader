/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Sakura Shader/ScreenFX"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        // #region Brightness

        [MaterialToggle]
        _Brightness_Enabled  ("Enable Brightness",                Int) = 0
        _Brightness_Strength ("Brightness Strength", Range(-1.0, 1.0)) = 0.0

        // #endregion

        // #region Cinemascope

        [MaterialToggle]
        _Cinemascope_Enabled ("Enable Cinemascope",            Int) = 0
        _Cinemascope_Color   ("Cinemascope Color",           Color) = (0, 0, 0, 1)
        _Cinemascope_Width   ("Cinemascope Width", Range(0.0, 1.0)) = 0.0

        // #endregion

        // #region Color Overlay

        [MaterialToggle]
        _ColorOverlay_Enabled ("Enable Color Overlay",            Int) = 0
        _ColorOverlay_R       ("Color Overlay Red",   Range(0.0, 1.0)) = 0.0
        _ColorOverlay_G       ("Color Overlay Green", Range(0.0, 1.0)) = 0.0
        _ColorOverlay_B       ("Color Overlay Blue",  Range(0.0, 1.0)) = 0.0

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
}
