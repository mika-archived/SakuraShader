/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

// #include "core.cginc"

float4 _Color;
float  _Alpha;

int       _BlendMode;
int       _EnableMeshClipping;
int       _MeshClippingMode;
float     _MeshClippingWidth;
float     _MeshClippingOffset;
int       _EnableTriangleHolograph;
float     _TriangleHolographHeight;
float     _TriangleHolographAlpha;
int       _EnableVoxelization;
int       _VoxelSource;
float     _VoxelMinSize;
float     _VoxelSize;
float     _VoxelOffsetN;
float     _VoxelOffsetX;
float     _VoxelOffsetY;
float     _VoxelOffsetZ;
int       _VoxelAnimation;
int       _VoxelUVSamplingSource;
int       _EnableThinOut;
int       _ThinOutSource;
sampler2D _ThinOutMaskTex;
sampler2D _ThinOutNoiseTex;
float     _ThinOutNoiseThresholdR;
float     _ThinOutNoiseThresholdG;
float     _ThinOutNoiseThresholdB;
float     _ThinOutMinSize;
int       _EnableWireframe;
float4    _WireframeColor;
float     _WireframeThickness;


struct g2f
{
#if defined(SHADER_AVATARS_SC)
    V2F_SHADOW_CASTER;
#else
    float4 pos      : SV_POSITION;
    float3 normal   : NORMAL;
    float2 uv       : TEXCOORD0;
    float3 worldPos : TEXCOORD1;
    float3 localPos : TEXCOORD2;
    float3 bary     : TEXCOORD3;
#endif // SHADER_AVATARS_SC
};

inline float3 getVertexPosFromIndex(v2f i[3], uint index)
{
    v2f v = i[index];
    return v.worldPos.xyz;
}

inline float2 getVertexUVFromIndex(v2f i[3], uint index)
{
    v2f v = i[index];
    return v.texCoord;
}

inline float2 getUV(float2 a, float2 b, float2 c)
{
    if (_VoxelUVSamplingSource == 0) return (a + b + c) / 3;
    if (_VoxelUVSamplingSource == 1) return a;
    if (_VoxelUVSamplingSource == 2) return b;
    if (_VoxelUVSamplingSource == 3) return c;

    return float2(0.0, 0.0);
}

inline float getMaxDistanceFor(float a, float b, float c)
{
    if (_VoxelSource == 0) {
        const float s = max(max(distance(a, b), distance(b, c)), distance(a, c));
        return s < _VoxelMinSize ? _VoxelMinSize : s;
    } else {
        return _VoxelSize;
    }
}

inline float getRandom(float2 st, int seed)
{
    return frac(sin(dot(st.xy, float2(12.9898, 78.233)) + seed) * 43758.5453123); 
}

inline float3 calcNormal(float3 a, float3 b, float3 c)
{
    return normalize(cross(b - a, c - a));
}

inline float3 getVertex(float3 center, float x, float y, float z)
{
    return center + mul(unity_ObjectToWorld, float4(x, y, z, 0.0)).xyz;
}

inline float3 getMovedVertex1(float3 vertex, float3 normal)
{
    const float3 offset = mul(unity_ObjectToWorld, float4(_VoxelOffsetX, _VoxelOffsetY, _VoxelOffsetZ, 0.0)).xyz;

    return float3(
        vertex.x + offset.x + normal.x * _VoxelOffsetN,
        vertex.y + offset.y + normal.y * _VoxelOffsetN,
        vertex.z + offset.z + normal.z * _VoxelOffsetN
    );
}

inline float3 getMovedVertex2(float3 vertex, float3 normal, float3 localPos)
{
    const float wave     = _Time.x - floor(_Time.x) - 0.5; // sawtooth wave
    const float diff     = -localPos.y - wave;
    const float height   = 0 <= diff && diff <= 0.1 ? cos((diff - 0.05) * 30) * _TriangleHolographHeight : 0;
    const float multiply = height < 0 ? 0 : height;

    return float3(
        vertex.x + normal.x * multiply,
        vertex.y + normal.y * multiply,
        vertex.z + normal.z * multiply
    );
}

inline g2f getStreamData1(float3 vertex, float3 normal, float2 uv, float3 oNormal)
{
    g2f o = (g2f) 0;

#if defined(SHADER_AVATARS_SC)
    const float3 pos1 = getMovedVertex1(vertex, oNormal);
    const float  cos  = dot(normal, normalize(UnityWorldSpaceLightDir(pos1)));
    const float3 pos2 = pos1 - normal * unity_LightShadowBias.z * sqrt(1 - cos * cos);
    o.pos = UnityApplyLinearShadowBias(UnityWorldToClipPos(float4(pos2, 1)));
#else
    const float3 moved = getMovedVertex1(vertex, oNormal);

    o.pos      = UnityWorldToClipPos(moved);
    o.normal   = normal;
    o.uv       = uv;
    o.worldPos = moved;
    o.localPos = mul(unity_WorldToObject, float4(moved, 1.0));

#endif // SHADER_AVATARS_SC

    return o;
}

inline g2f getStreamData2(float3 vertex, float3 normal, float2 uv, float3 localPos)
{
    g2f o = (g2f) 0;

#if defined(SHADER_AVATARS_TH)
    const float3 moved = getMovedVertex2(vertex, normal, localPos);

    o.pos      = UnityWorldToClipPos(moved);
    o.normal   = normal;
    o.uv       = uv;
    o.worldPos = moved;
    o.localPos = mul(unity_WorldToObject, moved);
#endif // SHADER_AVATARS_TH

    return o;
}

inline g2f getStreamData3(float3 vertex, float3 normal, float2 uv, float3 localPos)
{
    g2f o = (g2f) 0;

#if defined(SHADER_AVATARS_SC)
    const float  cos = dot(normal, normalize(UnityWorldSpaceLightDir(vertex)));
    const float3 pos = vertex - normal * unity_LightShadowBias.z * sqrt(1 - cos * cos);
    o.pos = UnityApplyLinearShadowBias(UnityWorldToClipPos(float4(pos, 1)));
#else
    o.pos      = UnityWorldToClipPos(vertex);
    o.normal   = normal;
    o.uv       = uv;
    o.worldPos = vertex;
    o.localPos = mul(unity_WorldToObject, vertex);
#endif

    return o;
}

inline g2f getStreamData4(float3 vertex, float3 normal, float3 bary)
{
    g2f o = (g2f) 0;

#if defined(SHADER_AVATARS_WF)

    o.pos      = UnityWorldToClipPos(vertex);
    o.normal   = normal;
    o.worldPos = vertex;
    o.localPos = mul(unity_WorldToObject, vertex);
    o.bary     = bary;

#endif // SHADER_AVATARS_WF

    return o;
}

[maxvertexcount(24)]
void gs(const triangle v2f i[3], const uint id : SV_PRIMITIVEID, inout TriangleStream<g2f> stream)
{
#if defined(SHADER_AVATARS_VG)
    if (_EnableVoxelization == 0)
    {
        [unroll]
        for (int j = 0; j < 3; j++)
        {
            const float3 vertex = getVertexPosFromIndex(i, j);
            const float2 uv     = getVertexUVFromIndex(i, j);
            const float3 normal = i[j].normal;

            stream.Append(getStreamData3(vertex, normal, uv, i[j].localPos));
        }

        return;
    }

    const float2 u1 = getVertexUVFromIndex(i, 0);
    const float2 u2 = getVertexUVFromIndex(i, 0);
    const float2 u3 = getVertexUVFromIndex(i, 0);

    const float2 uv = getUV(u1, u2, u3);

    if (_EnableThinOut == 1) {
        if (_ThinOutSource == 0) {
            const float4 m = tex2Dlod(_ThinOutMaskTex, float4(uv, 0.0, 0.0));
            if (m.r <= 0.5) {
                return;
            }
        }
        if (_ThinOutSource == 1) {
            const float4 n = tex2Dlod(_ThinOutNoiseTex, float4(uv, 0.0, 0.0));
            if (n.r < _ThinOutNoiseThresholdR && n.g < _ThinOutNoiseThresholdG && n.b < _ThinOutNoiseThresholdB) {
                return;
            }
        }
    }

    const float3 p1 = getVertexPosFromIndex(i, 0);
    const float3 p2 = getVertexPosFromIndex(i, 1);
    const float3 p3 = getVertexPosFromIndex(i, 2);
    
    const float3 center = (p1 + p2 + p3) / 3;

    const float x = getMaxDistanceFor(p1.x, p2.x, p3.x);
    const float y = getMaxDistanceFor(p1.y, p2.y, p3.y);
    const float z = getMaxDistanceFor(p1.z, p2.z, p3.z);

    if (_EnableThinOut == 1 && _ThinOutSource == 2) {
        if (x + y + z <= _ThinOutMinSize) {
            return;
        }
    }

    const float r1 = getRandom(i[0].texCoord, id);
    const float r2 = getRandom(i[1].texCoord, id);
    const float r3 = getRandom(i[2].texCoord, id);

    const float3 o = calcNormal(p1, p2, p3);

    const float3 dirs[3] = {
        float3(1.0, 0.0, 0.0),
        float3(0.0, 1.0, 0.0),
        float3(0.0, 0.0, 1.0),
    };

    const float signs[2] = { 1, -1 };

    const float3 d1 = dirs[0] * r1;
    const float3 d2 = dirs[1] * r2;
    const float3 d3 = dirs[2] * r3;

    const float  t = _SinTime.w * r1 + _CosTime.w * r3;
    const float3 f = _VoxelAnimation ? (t / 250) * o * (d1 + d2 + d3) * signs[round(r2)] : 0;

    const float s = _VoxelSource == 0 ? 0 : 0;

    const float hx = x / 2 + s;
    const float hy = y / 2 + s;
    const float hz = z / 2 + s;

    // top
    {
        const float3 a = getVertex(center,  hx, hy,  hz);
        const float3 b = getVertex(center,  hx, hy, -hz);
        const float3 c = getVertex(center, -hx, hy,  hz);
        const float3 d = getVertex(center, -hx, hy, -hz);

        const float3 n = calcNormal(a, b, c);

        stream.Append(getStreamData1(a + f, n, uv, o));
        stream.Append(getStreamData1(b + f, n, uv, o));
        stream.Append(getStreamData1(c + f, n, uv, o));
        stream.Append(getStreamData1(d + f, n, uv, o));
        stream.RestartStrip();
    }

    // bottom
    {
        const float3 a = getVertex(center,  hx, -hy,  hz);
        const float3 b = getVertex(center, -hx, -hy,  hz);
        const float3 c = getVertex(center,  hx, -hy, -hz);
        const float3 d = getVertex(center, -hx, -hy, -hz);

        const float3 n = calcNormal(a, b, c);

        stream.Append(getStreamData1(a + f, n, uv, o));
        stream.Append(getStreamData1(b + f, n, uv, o));
        stream.Append(getStreamData1(c + f, n, uv, o));
        stream.Append(getStreamData1(d + f, n, uv, o));
        stream.RestartStrip();
    }

    // left side
    {
        const float3 a = getVertex(center, hx,  hy,  hz);
        const float3 b = getVertex(center, hx, -hy,  hz);
        const float3 c = getVertex(center, hx,  hy, -hz);
        const float3 d = getVertex(center, hx, -hy, -hz);

        const float3 n = calcNormal(a, b, c);

        stream.Append(getStreamData1(a + f, n, uv, o));
        stream.Append(getStreamData1(b + f, n, uv, o));
        stream.Append(getStreamData1(c + f, n, uv, o));
        stream.Append(getStreamData1(d + f, n, uv, o));
        stream.RestartStrip();
    }

    // right side
    {
        const float3 a = getVertex(center, -hx,  hy,  hz);
        const float3 b = getVertex(center, -hx,  hy, -hz);
        const float3 c = getVertex(center, -hx, -hy,  hz);
        const float3 d = getVertex(center, -hx, -hy, -hz);

        const float3 n = calcNormal(a, b, c);

        stream.Append(getStreamData1(a + f, n, uv, o));
        stream.Append(getStreamData1(b + f, n, uv, o));
        stream.Append(getStreamData1(c + f, n, uv, o));
        stream.Append(getStreamData1(d + f, n, uv, o));
        stream.RestartStrip();
    }

    // foreground
    {
        const float3 a = getVertex(center,  hx,  hy, hz);
        const float3 b = getVertex(center, -hx,  hy, hz);
        const float3 c = getVertex(center,  hx, -hy, hz);
        const float3 d = getVertex(center, -hx, -hy, hz);

        const float3 n = calcNormal(a, b, c);

        stream.Append(getStreamData1(a + f, n, uv, o));
        stream.Append(getStreamData1(b + f, n, uv, o));
        stream.Append(getStreamData1(c + f, n, uv, o));
        stream.Append(getStreamData1(d + f, n, uv, o));
        stream.RestartStrip();
    }

    // background
    {
        const float3 a = getVertex(center,  hx,  hy, -hz);
        const float3 b = getVertex(center,  hx, -hy, -hz);
        const float3 c = getVertex(center, -hx,  hy, -hz);
        const float3 d = getVertex(center, -hx, -hy, -hz);

        const float3 n = calcNormal(a, b, c);

        stream.Append(getStreamData1(a + f, n, uv, o));
        stream.Append(getStreamData1(b + f, n, uv, o));
        stream.Append(getStreamData1(c + f, n, uv, o));
        stream.Append(getStreamData1(d + f, n, uv, o));
        stream.RestartStrip();
    }
#elif defined(SHADER_AVATARS_TH)
    if (_EnableTriangleHolograph == 0)
    {
        return;
    }

    const float3 normal = (i[0].normal + i[1].normal + i[2].normal) / 3;
    const float3 localPos = (i[0].localPos + i[1].localPos + i[2].localPos) / 3;

    [unroll]
    for (int j = 0; j < 3; j++)
    {
        const float3 vertex   = getVertexPosFromIndex(i, j);
        const float2 uv       = getVertexUVFromIndex(i, j);

        stream.Append(getStreamData2(vertex, normal, uv, localPos));
    }


    return;

#elif defined(SHADER_AVATARS_WF)
    if (_EnableWireframe == 0)
    {
        return;
    }

    const v2f vert1 = i[0];
    const v2f vert2 = i[1];
    const v2f vert3 = i[2];

    stream.Append(getStreamData4(vert1.worldPos.xyz, vert1.normal, float3(1, 0, 0)));
    stream.Append(getStreamData4(vert2.worldPos.xyz, vert2.normal, float3(0, 1, 0)));
    stream.Append(getStreamData4(vert3.worldPos.xyz, vert3.normal, float3(0, 0, 1)));
    stream.RestartStrip();

#endif // SHADER_AVATARS_VG

}

float4 fs(g2f i) : SV_TARGET
{
#if defined(SHADER_AVATARS_SC)
    SHADOW_CASTER_FRAGMENT(i)
#elif defined(SHADER_AVATARS_WF)

    const float3 deltas = fwidth(i.bary) * 1 * _WireframeThickness;
    const float3 baries = smoothstep(deltas, 2 * deltas, i.bary);
    const float  bary   = min(baries.x, min(baries.y, baries.z));

    clip(bary > 0.5 ? -1 : 0);

    if (_EnableMeshClipping)
    {
        if (_MeshClippingMode == 0)
        {
            clip(lerp(1, -1, step(i.localPos.x + _MeshClippingOffset - _MeshClippingWidth, 0)));
        }
        else if (_MeshClippingMode == 1)
        {
            clip(lerp(1, -1, step(abs(i.localPos.x) - _MeshClippingWidth * 0.5, 0)));
        }
        else if (_MeshClippingMode == 2)
        {
            clip((i.localPos.x - _MeshClippingOffset + _MeshClippingWidth) * -1);
        }
        else if (_MeshClippingMode == 3)
        {
            clip((i.localPos.y - _MeshClippingOffset + _MeshClippingWidth) * -1);
        }
        else if (_MeshClippingMode == 4)
        {
            clip(lerp(1, -1, step(i.localPos.y + _MeshClippingOffset - _MeshClippingWidth, 0)));
        }
    }


    return _WireframeColor;

#else

    if (_EnableMeshClipping)
    {
        if (_MeshClippingMode == 0)
        {
            clip(lerp(-1, 1, step(i.localPos.x + _MeshClippingOffset - _MeshClippingWidth, 0)));
        }
        else if (_MeshClippingMode == 1)
        {
            clip(lerp(-1, 1, step(abs(i.localPos.x) - _MeshClippingWidth * 0.5, 0)));
        }
        else if (_MeshClippingMode == 2)
        {
            clip(i.localPos.x - _MeshClippingOffset + _MeshClippingWidth);
        }
        else if (_MeshClippingMode == 3)
        {
            clip(i.localPos.y - _MeshClippingOffset + _MeshClippingWidth);
        }
        else if (_MeshClippingMode == 4)
        {
            clip(lerp(-1, 1, step(i.localPos.y + _MeshClippingOffset - _MeshClippingWidth, 0)));
        }
    }

#if defined(SHADER_AVATARS_TH)
    return float4(tex2D(_MainTex, i.uv).rgb, _TriangleHolographAlpha);
#else
    return float4(tex2D(_MainTex, i.uv).rgb, _BlendMode == 0 ? 1 : _Alpha);
#endif // SHADER_AVATARS_SH
#endif // SHADER_AVATARS_SC
}