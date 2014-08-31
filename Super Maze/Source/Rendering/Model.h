//
//  Model.h
//  Super Maze
//
//  Created by Rafał Grodziński on 31.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Metal/Metal.h>


@class Maze;


@interface Model : NSObject

@property (nonatomic, assign) NSInteger vertexCount;
@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLBuffer> colorBuffer;

//Initialization
- (instancetype)initMazeModelWithDevice:(id<MTLDevice>)device_ maze:(Maze *)maze_;
- (instancetype)initBallModelWithDevice:(id<MTLDevice>)device_ diameter:(CGFloat)diameter_;

@end
