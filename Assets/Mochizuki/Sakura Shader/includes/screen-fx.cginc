/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

// #include "core.cginc"

int    _BrightnessEnabled;
float  _BrightnessStrength;

int    _CinemascopeEnabled;
float4 _CinemascopeColor;
float  _CinemascopeWidth;

int    _ColorOverlayEnabled;
float  _ColorOverlayR;
float  _ColorOverlayG;
float  _ColorOverlayB;

inline float4 ApplyBrightness(float4 color)
{
    color.rgb += fixed3(_BrightnessStrength, _BrightnessStrength, _BrightnessStrength);
    color.a    = abs(_BrightnessStrength);

    return color;
}

inline float4 ApplyCinemascope(const v2f i, float4 color)
{
    const float height  = (_ScreenParams.y / 2) * _CinemascopeWidth;
    const float tPixels = _ScreenParams.y - height;
    const float bPixels = height;

    color = lerp(color, _CinemascopeColor, step(i.vertex.y, bPixels));
    color = lerp(color, _CinemascopeColor, 1.0 - step(i.vertex.y, tPixels));

    return color;
}

inline float4 ApplyColorOverlay(float4 color)
{
    color += fixed4(_ColorOverlayR, _ColorOverlayG, _ColorOverlayB, 0);
    color.a += (_ColorOverlayR + _ColorOverlayG + _ColorOverlayB) / 3;

    return color;
}

float4 fs(const v2f i) : SV_TARGET
{
    float4 color = float4(1, 1, 1, 0);

    if (_BrightnessEnabled)
    {
        color = ApplyBrightness(color);
    }

    if (_CinemascopeEnabled)
    {
        color = ApplyCinemascope(i, color);
    }

    if (_ColorOverlayEnabled)
    {
        color = ApplyColorOverlay(color);
    }

    return color;
}