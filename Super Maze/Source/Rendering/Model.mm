//
//  Model.m
//  Super Maze
//
//  Created by Rafał Grodziński on 31.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import "Model.h"
#import <simd/simd.h>


@implementation Model

#pragma mark - Initialization
- (instancetype)initMazeModelWithDevice:(id<MTLDevice>)device_ maze:(Maze *)maze_;
{
    self = [super init];
    if(self == nil)
        return nil;
    
    self.vertexCount = 36;
    
    simd::float3 *verticesBuffer = (simd::float3 *)malloc(sizeof(simd::float3) * 36);
    
    //front
    verticesBuffer[0]  = {-0.5, -0.5, -0.5};
    verticesBuffer[1]  = {-0.5, +0.5, -0.5};
    verticesBuffer[2]  = {+0.5, +0.5, -0.5};
    
    verticesBuffer[3]  = {-0.5, -0.5, -0.5};
    verticesBuffer[4]  = {+0.5, +0.5, -0.5};
    verticesBuffer[5]  = {+0.5, -0.5, -0.5};
    
    //right
    verticesBuffer[6]  = {+0.5, -0.5, -0.5};
    verticesBuffer[7]  = {+0.5, +0.5, -0.5};
    verticesBuffer[8]  = {+0.5, +0.5, +0.5};
    
    verticesBuffer[9]  = {+0.5, -0.5, -0.5};
    verticesBuffer[10] = {+0.5, +0.5, +0.5};
    verticesBuffer[11] = {+0.5, -0.5, +0.5};
    
    //back
    verticesBuffer[12] = {-0.5, -0.5, +0.5};
    verticesBuffer[13] = {-0.5, +0.5, +0.5};
    verticesBuffer[14] = {+0.5, +0.5, +0.5};
    
    verticesBuffer[15] = {-0.5, -0.5, +0.5};
    verticesBuffer[16] = {+0.5, +0.5, +0.5};
    verticesBuffer[17] = {+0.5, -0.5, +0.5};
    
    //left
    verticesBuffer[18] = {-0.5, -0.5, -0.5};
    verticesBuffer[19] = {-0.5, +0.5, -0.5};
    verticesBuffer[20] = {-0.5, +0.5, +0.5};
    
    verticesBuffer[21] = {-0.5, -0.5, -0.5};
    verticesBuffer[22] = {-0.5, +0.5, +0.5};
    verticesBuffer[23] = {-0.5, -0.5, +0.5};
    
    //top
    verticesBuffer[24] = {-0.5, +0.5, -0.5};
    verticesBuffer[25] = {-0.5, +0.5, +0.5};
    verticesBuffer[26] = {+0.5, +0.5, -0.5};
    
    verticesBuffer[27] = {+0.5, +0.5, -0.5};
    verticesBuffer[28] = {-0.5, +0.5, +0.5};
    verticesBuffer[29] = {+0.5, +0.5, +0.5};
    
    //bottom
    verticesBuffer[30] = {-0.5, -0.5, -0.5};
    verticesBuffer[31] = {-0.5, -0.5, +0.5};
    verticesBuffer[32] = {+0.5, -0.5, -0.5};
    
    verticesBuffer[33] = {+0.5, -0.5, -0.5};
    verticesBuffer[34] = {-0.5, -0.5, +0.5};
    verticesBuffer[35] = {+0.5, -0.5, +0.5};
    
    self.vertexBuffer = [device_ newBufferWithBytes:verticesBuffer length:36*sizeof(simd::float3) options:0];
    
    simd::float4 *colors = (simd::float4 *)malloc(sizeof(simd::float4) * 36);
    
    //front
    colors[0]  = {1.0, 0.0, 0.0, 1.0};
    colors[1]  = {1.0, 0.0, 0.0, 1.0};
    colors[2]  = {1.0, 0.0, 0.0, 1.0};
    
    colors[3]  = {1.0, 0.0, 0.0, 1.0};
    colors[4]  = {1.0, 0.0, 0.0, 1.0};
    colors[5]  = {1.0, 0.0, 0.0, 1.0};
    
    //right
    colors[6]  = {0.0, 1.0, 0.0, 1.0};
    colors[7]  = {0.0, 1.0, 0.0, 1.0};
    colors[8]  = {0.0, 1.0, 0.0, 1.0};
    
    colors[9]  = {0.0, 1.0, 0.0, 1.0};
    colors[10] = {0.0, 1.0, 0.0, 1.0};
    colors[11] = {0.0, 1.0, 0.0, 1.0};
    
    //back
    colors[12] = {0.0, 0.0, 1.0, 1.0};
    colors[13] = {0.0, 0.0, 1.0, 1.0};
    colors[14] = {0.0, 0.0, 1.0, 1.0};
    
    colors[15] = {0.0, 0.0, 1.0, 1.0};
    colors[16] = {0.0, 0.0, 1.0, 1.0};
    colors[17] = {0.0, 0.0, 1.0, 1.0};
    
    //left
    colors[18] = {0.0, 1.0, 1.0, 1.0};
    colors[19] = {0.0, 1.0, 1.0, 1.0};
    colors[20] = {0.0, 1.0, 1.0, 1.0};
    
    colors[21] = {0.0, 1.0, 1.0, 1.0};
    colors[22] = {0.0, 1.0, 1.0, 1.0};
    colors[23] = {0.0, 1.0, 1.0, 1.0};
    
    //top
    colors[24] = {1.0, 1.0, 1.0, 1.0};
    colors[25] = {1.0, 1.0, 1.0, 1.0};
    colors[26] = {1.0, 1.0, 1.0, 1.0};
    
    colors[27] = {1.0, 1.0, 1.0, 1.0};
    colors[28] = {1.0, 1.0, 1.0, 1.0};
    colors[29] = {1.0, 1.0, 1.0, 1.0};
    
    //bottom
    colors[30] = {1.0, 0.0, 1.0, 1.0};
    colors[31] = {1.0, 0.0, 1.0, 1.0};
    colors[32] = {1.0, 0.0, 1.0, 1.0};
    
    colors[33] = {1.0, 0.0, 1.0, 1.0};
    colors[34] = {1.0, 0.0, 1.0, 1.0};
    colors[35] = {1.0, 0.0, 1.0, 1.0};
    
    self.colorBuffer = [device_ newBufferWithBytes:colors length:36*sizeof(simd::float4) options:0];
    
    return self;
}


- (instancetype)initBallModelWithDevice:(id<MTLDevice>)device_ diameter:(CGFloat)diameter_;
{
    self = [super init];
    if(self == nil)
        return nil;
    
    return self;
}

@end
