/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

sampler2D _MainTex;
float4    _MainTex_ST;

struct v2f
{
    float4 vertex   : SV_POSITION;
    float2 texCoord : TEXCOORD0;
    float3 localPos : TEXCOORD1;
};

#if defined(SHADER_CUSTOM_VERTEX)

#else

v2f vs(const appdata_full v)
{
    v2f o;

    o.vertex   = UnityObjectToClipPos(v.vertex);
    o.texCoord = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.localPos = v.vertex.xyz;

    return o;
}

#endif // SHADER_CUSTOM_VERTEX

// includes

#if defined(SHADER_SCREEN_FX)

#include "screen-fx.cginc"

#elif defined(SHADER_LYRICS)

#include "lyrics.cginc"

#elif defined(SHADER_UNLIT)

#include "unlit.cginc"

#elif defined(SHADER_SKYBOX)

#include "skybox.cginc"

#endif