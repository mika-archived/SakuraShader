/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

sampler2D _MainTex;
float4    _MainTex_ST;

#if defined(SHADER_SINGLE_PASS_RENDERING)

struct appdata
{
    float4 vertex   : POSITION;
    float3 normal   : NORMAL;
    float2 texcoord : TEXCOORD0;

    UNITY_VERTEX_INPUT_INSTANCE_ID
};

#endif // SHADER_SINGLE_PASS_RENDERING

#if defined(SHADER_CUSTOM_VERTEX)

#else

struct v2f
{
    float4 vertex   : SV_POSITION;
    float3 normal   : NORMAL;
    float2 texCoord : TEXCOORD0;
    float3 worldPos : TEXCOORD1;
    float3 localPos : TEXCOORD2;

#if defined(SHADER_SINGLE_PASS_RENDERING)
    UNITY_VERTEX_OUTPUT_STEREO
#endif // SHADER_SINGLE_PASS_RENDERING
};

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
    o.normal   = UnityObjectToWorldNormal(v.normal);
    o.texCoord = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    o.localPos = v.vertex.xyz;

    return o;
}

#endif // SHADER_CUSTOM_VERTEX

// includes

#if defined(SHADER_SCREEN_FX)

#include "screen-fx.cginc"

#elif defined(SHADER_LYRICS)

#include "lyrics.cginc"

#elif defined(SHADER_PARTICLES)

#include "particles.cginc"

#elif defined(SHADER_UNLIT)

#include "unlit.cginc"

#elif defined(SHADER_SKYBOX)

#include "skybox.cginc"

#elif defined(SHADER_STENCIL_WRITE)

#include "stencil-write.cginc"

#elif defined(SHADER_AVATARS)

#include "avatars.cginc"

#endif