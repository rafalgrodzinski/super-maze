//
//  default.metal
//  Super Maze
//
//  Created by Rafał Grodziński on 19.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <metal_stdlib>
#import <metal_graphics>
#import <metal_matrix>
#import <metal_geometric>
#import <metal_math>
#import <metal_texture>

#import "Uniforms.h"

using namespace metal;


struct VertexOut
{
    float4 position [[position]];
    float4 color;
};


vertex VertexOut default_vert(device   float3   *vertexBuffer [[buffer(0)]],
                              device   float4   *colorBuffer  [[buffer(1)]],
                              constant float4x4 *modelMatrix  [[buffer(2)]],
                              constant Uniforms *uniforms     [[buffer(3)]],
                              uint               vid          [[vertex_id]])
{
    VertexOut out;
    out.position = uniforms->projectionMatrix * uniforms->viewMatrix * *modelMatrix * float4(vertexBuffer[vid], 1.0);
    out.color = colorBuffer[vid];
    
    return out;
}


fragment float4 default_frag(VertexOut vertexOut [[stage_in]])
{
    return vertexOut.color;
}
