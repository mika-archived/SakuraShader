/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

int    _Brightness_Enabled;
float  _Brightness_Strength;

int    _Cinemascope_Enabled;
float4 _Cinemascope_Color;
float  _Cinemascope_Width;

int    _ColorOverlay_Enabled;
float  _ColorOverlay_R;
float  _ColorOverlay_G;
float  _ColorOverlay_B;

inline float4 ApplyBrightness(float4 color)
{
    color.rgb += fixed3(_Brightness_Strength, _Brightness_Strength, _Brightness_Strength);
    color.a    = abs(_Brightness_Strength);

    return color;
}

inline float4 ApplyCinemascope(const v2f i, float4 color)
{
    const float height  = (_ScreenParams.y / 2) * _Cinemascope_Width;
    const float tPixels = _ScreenParams.y - height;
    const float bPixels = height;

    color = lerp(color, _Cinemascope_Color, step(i.vertex.y, bPixels));
    color = lerp(color, _Cinemascope_Color, 1.0 - step(i.vertex.y, tPixels));

    return color;
}

inline float4 ApplyColorOverlay(float4 color)
{
    color += fixed4(_ColorOverlay_R, _ColorOverlay_G, _ColorOverlay_B, 0);
    color.a += (_ColorOverlay_R + _ColorOverlay_G + _ColorOverlay_B) / 3;

    return color;
}

float4 fs(const v2f i) : SV_TARGET
{
    float4 color = float4(1, 1, 1, 0);

    if (_Brightness_Enabled)
    {
        color = ApplyBrightness(color);
    }

    if (_Cinemascope_Enabled)
    {
        color = ApplyCinemascope(i, color);
    }

    if (_ColorOverlay_Enabled)
    {
        color = ApplyColorOverlay(color);
    }

    return color;
}