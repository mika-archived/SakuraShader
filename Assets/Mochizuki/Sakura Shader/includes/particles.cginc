/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

// #include "core.cginc"

float4 _Color;
int    _ArrayEnabled;
UNITY_DECLARE_TEX2DARRAY(_ArrayTexture);
int    _ArrayIndexSource;
int    _ArraySize;

#if defined(SHADER_CUSTOM_VERTEX)

struct streams
{
    float4 vertex   : POSITION;
    // float3 normal   : NORMAL;
    float4 color    : COLOR;
    float3 texCoord : TEXCOORD0;
};

struct v2f
{
    float4 vertex   : SV_POSITION;
    float2 texCoord : TEXCOORD0;
    float  vertexId : TEXCOORD1;
    float4 color    : COLOR;
};

v2f vs(const streams v)
{
    v2f o;

    o.vertex   = UnityObjectToClipPos(v.vertex);
    o.texCoord = TRANSFORM_TEX(v.texCoord, _MainTex);
    o.vertexId = v.texCoord.z;
    o.color    = v.color;

    return o;
}

float4 SampleTexture(float2 uv, float id)
{
    if (_ArrayEnabled)
    {
        const float  vertexId = clamp(id % _ArraySize, 0, _ArraySize - 1);
        const float4 color    = UNITY_SAMPLE_TEX2DARRAY(_ArrayTexture, float3(uv, floor(vertexId)));
        return _Color * color;
    }

    return _Color * tex2D(_MainTex, uv);
}

#endif // SHADER_CUSTOM_VERTEX

float4 fs(const v2f i) : SV_TARGET
{
    const float4 baseColor  = SampleTexture(i.texCoord, i.vertexId);
    const float4 mixedColor = baseColor * i.color;

    return mixedColor;
}