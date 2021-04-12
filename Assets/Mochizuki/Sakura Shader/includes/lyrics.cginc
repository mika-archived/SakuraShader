/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

float4 _Color;

int       _SlideMode_Enabled;
int       _SlideFrom;
float     _SlideWidth;

int       _Outline_Enabled;
float4    _Outline_Color;
float     _Outline_Width;
sampler2D _Outline_Tex;

int       _Rotation_Enabled;
float     _Rotation_Angle;

#if defined(SHADER_CUSTOM_VERTEX)

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

    if (_Rotation_Enabled)
    {
        o.vertex = RotateYByDegree(v.vertex, _Rotation_Angle);
        o.vertex = UnityObjectToClipPos(o.vertex);
    }
    else
    {
        o.vertex    = UnityObjectToClipPos(v.vertex);
    }

#if defined(SHADER_OUTLINE)
    if (_Outline_Enabled)
    {
#if defined(SHADER_OUTLINE_REVERSE)
        o.vertex.xy -= offset * _Outline_Width;
#else
        o.vertex.xy += offset * _Outline_Width;
#endif // SHADER_OUTLINE_REVERSE
    }
#endif // SHADER_OUTLINE

    o.texCoord = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.localPos = v.vertex.xyz;

    return o;
}


#endif // SHADER_CUSTOM_VERTEX

float4 fs(const v2f i) : SV_TARGET
{
#if defined(SHADER_OUTLINE)
    float4 color = _Outline_Color * tex2D(_Outline_Tex, i.texCoord);
#else
    float4 color = _Color * tex2D(_MainTex, i.texCoord);
#endif // SHADER_OUTLINE

    if (_SlideMode_Enabled)
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