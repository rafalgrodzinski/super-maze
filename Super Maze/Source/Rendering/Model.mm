//
//  Model.m
//  Super Maze
//
//  Created by Rafał Grodziński on 31.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import "Model.h"
#import <simd/simd.h>
#import "METLTransforms.h"
#import <math.h>
#import <Metal/Metal.h>

#import "Super_Maze-Swift.h"


@interface Model ()

@property (nonatomic, assign) CGFloat ballCircumference;
@property (nonatomic, assign) CGFloat ballDiameter;

@end


@implementation Model

#pragma mark - Initialization
- (instancetype)initMazeModelWithDevice:(id<MTLDevice>)device_ maze:(Maze *)maze_;
{
    self = [super init];
    if(self == nil)
        return nil;
    
    //setup model matrix
    self.modelMatrixBuffer = [device_ newBufferWithLength:sizeof(simd::float4x4) options:0];
    self.modelMatrix = METL::translate(0.0, 0.0, 0.0);
    
    //generate vertices
    NSMutableArray *polygons = [NSMutableArray array];
    
    for(NSInteger level=0; level<maze_.levelMultipliers.count; level++) {
        //outside wall
        NSArray *outsideWallolygons = [maze_ ousideWallPolygonsAtLevel:level];
        [polygons addObjectsFromArray:outsideWallolygons];
        
        //inside walls
        NSArray *wallPolygons = [maze_ wallPolygonsAtLevel:level];
        [polygons addObjectsFromArray:wallPolygons];
    }
    
    self.vertexCount = polygons.count * 5 * 2 * 3; //5 walls, 2 triangles, 3 vertices
    
    simd::float3 *vertexBuffer = (simd::float3 *)malloc(sizeof(simd::float3) * self.vertexCount);
    simd::float3 *bufferPointer = vertexBuffer;
    
    for(Polygon *polygon in polygons) {
        bufferPointer += [self boxFromPolygon:polygon height:maze_.wallSize atAddress:bufferPointer];
    }
    
    self.vertexBuffer = [device_ newBufferWithBytes:vertexBuffer length:sizeof(simd::float3) * self.vertexCount options:0];
    
    free(vertexBuffer);
    
    //dummy colors
    simd::float4 *colorBuffer = (simd::float4 *)malloc(sizeof(simd::float4) * self.vertexCount);
    simd::float4 *colorPointer = colorBuffer;
    
    for(NSInteger i=0; i<self.vertexCount; i+=6) {
        simd::float4 color;
        color.x = arc4random()%1000/1000.0;
        color.y = arc4random()%1000/1000.0;
        color.z = arc4random()%1000/1000.0;
        color.w = 1.0;

        colorPointer[0] = color;
        colorPointer[1] = color;
        colorPointer[2] = color;
        
        colorPointer[3] = color;
        colorPointer[4] = color;
        colorPointer[5] = color;
        
        colorPointer += 6;
    }
    
    self.colorBuffer = [device_ newBufferWithBytes:colorBuffer length:sizeof(simd::float4) * self.vertexCount options:0];
    
    free(colorBuffer);
    
    NSLog(@"Initialized maze with %ld triangles", self.vertexCount/3);
    
    return self;
}


- (instancetype)initBallModelWithDevice:(id<MTLDevice>)device_ diameter:(CGFloat)diameter_;
{
    self = [super init];
    if(self == nil)
        return nil;
    
    self.ballDiameter = diameter_;
    self.ballCircumference = M_PI * diameter_;
    
    //setup model matrix
    self.modelMatrixBuffer = [device_ newBufferWithLength:sizeof(simd::float4x4) options:0];
    self.modelMatrix = METL::translate(0.0, diameter_*0.5, 0.0);
    
    //generate vertices
    self.vertexCount = 60;
    
    float radius = diameter_*0.5;
    
    float t = (1.0 + sqrtf(5.0))*0.5 * radius;
    
    simd::float3 v0 = {-radius,  t, 0.0};
    simd::float3 v1 = { radius,  t, 0.0};
    simd::float3 v2 = {-radius, -t, 0.0};
    simd::float3 v3 = { radius, -t, 0.0};
    
    simd::float3 v4 = {0.0, -radius,  t};
    simd::float3 v5 = {0.0,  radius,  t};
    simd::float3 v6 = {0.0, -radius, -t};
    simd::float3 v7 = {0.0,  radius, -t};
    
    simd::float3 v8  = {t,  0.0, -radius};
    simd::float3 v9  = {t,  0.0,  radius};
    simd::float3 v10 = {-t, 0.0, -radius};
    simd::float3 v11 = {-t, 0.0,  radius};
    
    simd::float3 *vertexBuffer = (simd::float3 *)malloc(sizeof(simd::float3) * self.vertexCount);
    
    //first
    vertexBuffer[0]  = v0;
    vertexBuffer[1]  = v11;
    vertexBuffer[2]  = v5;
    
    vertexBuffer[3]  = v0;
    vertexBuffer[4]  = v5;
    vertexBuffer[5]  = v1;
    
    vertexBuffer[6]  = v0;
    vertexBuffer[7]  = v1;
    vertexBuffer[8]  = v7;
    
    vertexBuffer[9]  = v0;
    vertexBuffer[10] = v7;
    vertexBuffer[11] = v10;
    
    vertexBuffer[12] = v0;
    vertexBuffer[13] = v10;
    vertexBuffer[14] = v11;
    
    //second
    vertexBuffer[15] = v1;
    vertexBuffer[16] = v5;
    vertexBuffer[17] = v9;
    
    vertexBuffer[18] = v5;
    vertexBuffer[19] = v11;
    vertexBuffer[20] = v4;
    
    vertexBuffer[21] = v11;
    vertexBuffer[22] = v10;
    vertexBuffer[23] = v2;
    
    vertexBuffer[24] = v10;
    vertexBuffer[25] = v7;
    vertexBuffer[26] = v6;
    
    vertexBuffer[27] = v7;
    vertexBuffer[28] = v1;
    vertexBuffer[29] = v8;
    
    //third
    vertexBuffer[30] = v3;
    vertexBuffer[31] = v9;
    vertexBuffer[32] = v4;

    vertexBuffer[33] = v3;
    vertexBuffer[34] = v4;
    vertexBuffer[35] = v2;
    
    vertexBuffer[36] = v3;
    vertexBuffer[37] = v2;
    vertexBuffer[38] = v6;
    
    vertexBuffer[39] = v3;
    vertexBuffer[40] = v6;
    vertexBuffer[41] = v8;
    
    vertexBuffer[42] = v3;
    vertexBuffer[43] = v8;
    vertexBuffer[44] = v9;
    
    //fourth
    vertexBuffer[45] = v4;
    vertexBuffer[46] = v9;
    vertexBuffer[47] = v5;
    
    vertexBuffer[48] = v2;
    vertexBuffer[49] = v4;
    vertexBuffer[50] = v11;
    
    vertexBuffer[51] = v6;
    vertexBuffer[52] = v2;
    vertexBuffer[53] = v10;
    
    vertexBuffer[54] = v8;
    vertexBuffer[55] = v6;
    vertexBuffer[56] = v7;
    
    vertexBuffer[57] = v9;
    vertexBuffer[58] = v8;
    vertexBuffer[59] = v1;
    
    self.vertexBuffer = [device_ newBufferWithBytes:vertexBuffer length:sizeof(simd::float3) * self.vertexCount options:0];
    
    free(vertexBuffer);
    
    //dummy colors
    simd::float4 *colorBuffer = (simd::float4 *)malloc(sizeof(simd::float4) * self.vertexCount);
    simd::float4 *colorPointer = colorBuffer;
    
    for(NSInteger i=0; i<60; i+=3) {
        simd::float4 color;
        color.x = arc4random()%1000/1000.0;
        color.y = arc4random()%1000/1000.0;
        color.z = arc4random()%1000/1000.0;
        color.w = 1.0;
        
        colorPointer[0] = color;
        colorPointer[1] = color;
        colorPointer[2] = color;
        
        colorPointer += 3;
    }
    
    self.colorBuffer = [device_ newBufferWithBytes:colorBuffer length:sizeof(simd::float4) * self.vertexCount options:0];
    
    free(colorBuffer);
    
    NSLog(@"Initialized ball with %ld triangles", self.vertexCount/3);
    
    return self;
}


#pragma mark - Properties
- (void)setModelMatrix:(simd::float4x4)modelMatrix_
{
    _modelMatrix = modelMatrix_;
    
    simd::float4x4 *bufferPointer = (simd::float4x4 *)[self.modelMatrixBuffer contents];
    memcpy(bufferPointer, &_modelMatrix, sizeof(simd::float4x4));
}


- (void)setBallPosition:(CGPoint)ballPosition_
{
    _ballPosition = ballPosition_;
    
    CGFloat xRatio = ballPosition_.x/self.ballCircumference;
    CGFloat yRatio = ballPosition_.y/self.ballCircumference;
    
    CGFloat xAngle = fmod(yRatio * 360.0, 360.0);
    CGFloat zAngle = -fmod(xRatio * 360.0, 360.0);

    simd::float4x4 translate = METL::translate(ballPosition_.x, self.ballDiameter*0.5, ballPosition_.y);
    simd::float4x4 rotateX = METL::rotate(xAngle, 1.0, 0.0, 0.0);
    simd::float4x4 rotateZ = METL::rotate(zAngle, 0.0, 0.0, 1.0);
    
    self.modelMatrix = translate * (rotateZ * rotateX);
}


#pragma mark - Internal Control
- (NSInteger)boxFromPolygon:(Polygon *)polygon_ height:(CGFloat)height_ atAddress:(simd::float3 *)address_
{
    simd::float3 frontBottomLeft  = {float(polygon_.v1.x), 0.0,            float(polygon_.v1.y)};
    simd::float3 frontBottomRight = {float(polygon_.v0.x), 0.0,            float(polygon_.v0.y)};
    simd::float3 frontTopLeft     = {float(polygon_.v1.x), float(height_), float(polygon_.v1.y)};
    simd::float3 frontTopRight     = {float(polygon_.v0.x), float(height_), float(polygon_.v0.y)};
    
    simd::float3 backBottomLeft  = {float(polygon_.v2.x), 0.0,            float(polygon_.v2.y)};
    simd::float3 backBottomRight = {float(polygon_.v3.x), 0.0,            float(polygon_.v3.y)};
    simd::float3 backTopLeft     = {float(polygon_.v2.x), float(height_), float(polygon_.v2.y)};
    simd::float3 backTopRight    = {float(polygon_.v3.x), float(height_), float(polygon_.v3.y)};
    
    //front
    address_[0] = frontBottomLeft;
    address_[1] = frontTopLeft;
    address_[2] = frontTopRight;
    
    address_[3] = frontBottomLeft;
    address_[4] = frontTopRight;
    address_[5] = frontBottomRight;
    
    //right
    address_[6] = frontBottomRight;
    address_[7] = frontTopRight;
    address_[8] = backTopRight;
    
    address_[9] = frontBottomRight;
    address_[10] = backTopRight;
    address_[11] = backBottomRight;
    
    //back
    address_[12] = backBottomRight;
    address_[13] = backTopRight;
    address_[14] = backTopLeft;
    
    address_[15] = backBottomRight;
    address_[16] = backTopLeft;
    address_[17] = backBottomLeft;
    
    //left
    address_[18] = backBottomLeft;
    address_[19] = backTopLeft;
    address_[20] = frontTopLeft;
    
    address_[21] = backBottomLeft;
    address_[22] = frontTopLeft;
    address_[23] = frontBottomLeft;
    
    //top
    address_[24] = frontTopLeft;
    address_[25] = backTopLeft;
    address_[26] = backTopRight;
    
    address_[27] = frontTopLeft;
    address_[28] = backTopRight;
    address_[29] = frontTopRight;
    
    return 30;
}

@end
