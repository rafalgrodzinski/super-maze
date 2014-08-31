//
//  Model.h
//  Super Maze
//
//  Created by Rafał Grodziński on 31.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

#import "Uniforms.h"


@class Maze;


@interface Model : NSObject

@property (nonatomic, assign) NSInteger vertexCount;

@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLBuffer> colorBuffer;
@property (nonatomic, strong) id<MTLBuffer> modelMatrixBuffer;

@property (nonatomic, assign) simd::float4x4 modelMatrix;

//Initialization
- (instancetype)initMazeModelWithDevice:(id<MTLDevice>)device_ maze:(Maze *)maze_;
- (instancetype)initBallModelWithDevice:(id<MTLDevice>)device_ diameter:(CGFloat)diameter_;

@end
