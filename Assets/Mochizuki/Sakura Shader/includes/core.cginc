/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

sampler2D _MainTex;
float4    _MainTex_ST;

#if defined(SHADER_SINGLE_PASS_RENDERING)

struct appdata
{
    float4 vertex   : POSITION;
    float2 texcoord : TEXCOORD0;

    UNITY_VERTEX_INPUT_INSTANCE_ID
};

#endif // SHADER_SINGLE_PASS_RENDERING

struct v2f
{
    float4 vertex   : SV_POSITION;
    float2 texCoord : TEXCOORD0;
    float3 localPos : TEXCOORD1;

#if defined(SHADER_SINGLE_PASS_RENDERING)
    UNITY_VERTEX_OUTPUT_STEREO
#endif // SHADER_SINGLE_PASS_RENDERING
};

#if defined(SHADER_CUSTOM_VERTEX)

#else

#if defined(SHADER_SINGLE_PASS_RENDERING)
v2f vs(const appdata v)
#else
v2f vs(const appdata_full v)
#endif // SHADER_SINGLE_PASS_RENDERING
{
    v2f o;

#if defined(SHADER_SINGLE_PASS_RENDERING)
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
#endif // SHADER_SINGLE_PASS_RENDERING

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