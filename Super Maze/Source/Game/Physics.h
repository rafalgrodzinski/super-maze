//
//  Physics.h
//  Super Maze
//
//  Created by Rafał Grodziński on 03.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>


@class Maze;


@interface Physics : NSObject

@property (nonatomic, readonly) CGPoint ballPosition;
@property (nonatomic, readonly) CGFloat ballDiameter;
@property (nonatomic, readonly) CGFloat ballAngle;

//Initialization
- (instancetype)initWithMaze:(Maze *)maze_;

//Control
- (void)updateWithInterval:(CGFloat)interval_ rotation:(CGPoint)rotation_;

@end
