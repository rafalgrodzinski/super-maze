//
//  Uniforms.h
//  Super Maze
//
//  Created by Rafał Grodziński on 31.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <simd/simd.h>


typedef struct {
    simd::float4x4 projectionMatrix;
    simd::float4x4 viewMatrix;
} Uniforms;
