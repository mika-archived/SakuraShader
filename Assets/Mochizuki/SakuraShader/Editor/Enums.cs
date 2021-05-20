/*-------------------------------------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the Proprietary License. See https://docs.mochizuki.moe/unity/sakura-shader/terms for more information.
 *-----------------------------------------------------------------------------------------------------------------------*/

namespace Mochizuki.SakuraShader
{
    public enum IndexSource
    {
        TexCoordZ,

        TexCoordW
    }

    public enum ThinOutSource
    {
        MaskTexture,

        NoiseTexture,

        ShaderProperty
    }

    public enum VoxelSource
    {
        Vertex,

        ShaderProperty
    }

    public enum UvSamplingSource
    {
        Center,

        First,

        Second,

        Last
    }
}