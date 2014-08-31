//
//  MazeRenderer.h
//  Super Maze
//
//  Created by Rafał Grodziński on 19.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Maze;


@interface MazeRenderer : NSObject

@property (nonatomic, assign) CGPoint ballPosition;


//Initialization
- (instancetype)initWithMaze:(Maze *)maze_ rendererView:(UIView *)rendererView_;

//Control
- (void)redraw;

@end
