//
//  default.metal
//  Super Maze
//
//  Created by Rafał Grodziński on 19.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct VertexOut
{
    float4 position [[position]];
};


vertex VertexOut default_vert()
{
    VertexOut out;
    out.position = float4(0.0, 0.0, 0.0, 1.0);
    
    return out;
}


fragment float4 default_frag()
{
    return float4(0.0, 1.0, 0.0, 1.0);
}
