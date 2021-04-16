/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

// #include "core.cginc"

float4  _Color;
float   _Alpha;

float4 fs(const v2f i) : SV_TARGET
{
    float4 color =  tex2D(_MainTex, i.texCoord) * _Color * float4(1, 1, 1, _Alpha);

    return color;
}