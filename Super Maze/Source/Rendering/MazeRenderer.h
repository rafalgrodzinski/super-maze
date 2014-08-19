//
//  MazeRenderer.h
//  Super Maze
//
//  Created by Rafał Grodziński on 19.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Maze;


@interface MazeRenderer : NSObject

//Initialization
- (instancetype)initWithMaze:(Maze *)maze_;

//Control
- (void)redraw;

@end
