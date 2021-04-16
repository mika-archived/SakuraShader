/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

// #include "core.cginc"

float4 _Color;

int       _AnimEnabled;
sampler2D _AnimSpriteTex;
float     _AnimUpdateRate;

int       _SlideModeEnabled;
int       _SlideFrom;
float     _SlideWidth;

int       _OutlineEnabled;
float4    _OutlineColor;
float     _OutlineWidth;
sampler2D _OutlineTex;

int       _RotationEnabled;
float     _RotationAngle;

#if defined(SHADER_CUSTOM_VERTEX)

struct v2f
{
    float4 vertex   : SV_POSITION;
    float2 texCoord : TEXCOORD0;
    float3 localPos : TEXCOORD1;
};

inline float4 RotateYByDegree(const float4 vertex, const float degree)
{
    const float    rot = degree * UNITY_PI / 180.0;
    const float    s   = sin(rot);
    const float    c   = cos(rot);
    const float2x2 m   = float2x2(c, -s, s, c);
    
    return float4(mul(m, vertex.xz), vertex.yz).xzyw;
}

v2f vs(const appdata_full v)
{
    v2f o;

    const float3 normal = normalize(mul((float3x3) UNITY_MATRIX_IT_MV, v.vertex.xyz));
    const float2 offset = TransformViewToProjection(normal.xy);

    if (_RotationEnabled)
    {
        o.vertex = RotateYByDegree(v.vertex, _RotationAngle);
        o.vertex = UnityObjectToClipPos(o.vertex);
    }
    else
    {
        o.vertex    = UnityObjectToClipPos(v.vertex);
    }

#if defined(SHADER_OUTLINE)
    if (_OutlineEnabled)
    {
#if defined(SHADER_OUTLINE_REVERSE)
        o.vertex.xy -= offset * _OutlineWidth;
#else
        o.vertex.xy += offset * _OutlineWidth;
#endif // SHADER_OUTLINE_REVERSE
    }
#endif // SHADER_OUTLINE

    o.texCoord = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.localPos = v.vertex.xyz;

    return o;
}


#endif // SHADER_CUSTOM_VERTEX

float4 SampleTexture(float2 uv)
{
    if (_AnimEnabled)
    {
        int a = floor(_Time.y / _AnimUpdateRate) % 2 == 0;
        return _Color * (a == 0 ? tex2D(_MainTex, uv) : tex2D(_AnimSpriteTex, uv));
    }

    return _Color * tex2D(_MainTex, uv);
}

float4 fs(const v2f i) : SV_TARGET
{
#if defined(SHADER_OUTLINE)
    float4 color = _OutlineColor * tex2D(_OutlineTex, i.texCoord);
#else
    float4 color = SampleTexture(i.texCoord);
#endif // SHADER_OUTLINE

    if (_SlideModeEnabled)
    {
        if (_SlideFrom == 0)
        {
            clip(lerp(-1, 1, step(i.localPos.x + 0.5 - _SlideWidth, 0)));
        }
        else if (_SlideFrom == 1)
        {
            clip(lerp(-1, 1, step(abs(i.localPos.x) - _SlideWidth * 0.5, 0)));
        }
        else if (_SlideFrom == 2)
        {
            clip(i.localPos.x - 0.5 + _SlideWidth);
        }
        else if (_SlideFrom == 3)
        {
            clip(i.localPos.y - 0.5 + _SlideWidth);
        }
        else if (_SlideFrom == 4)
        {
            clip(lerp(-1, 1, step(i.localPos.y + 0.5 - _SlideWidth, 0)));
        }
    }

    return color;
}