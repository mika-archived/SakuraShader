/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

sampler2D _FrontTex;
float4    _FrontTex_HDR;
sampler2D _BackTex;
float4    _BackTex_HDR;
sampler2D _LeftTex;
float4    _LeftTex_HDR;
sampler2D _RightTex;
float4    _RightTex_HDR;
sampler2D _UpTex;
float4    _UpTex_HDR;
sampler2D _DownTex;
float4    _DownTex_HDR;

float4 fs(const v2f i) : SV_TARGET
{
    const float4 tex   = tex2D(SHADER_SAMPLER, i.texCoord);
    const float3 color = DecodeHDR(tex, SHADER_SAMPLER_HDR);

    return float4(color, 1);
}