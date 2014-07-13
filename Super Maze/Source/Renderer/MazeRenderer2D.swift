//
//  MazeRenderer2D.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 05.07.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import UIKit


class MazeRenderer2D: UIView {
    let maze: Maze
    let levelSize: Double

    init(frame: CGRect, maze: Maze, levelSize: Double)
    {
        self.maze = maze
        self.levelSize = levelSize
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
    }
    
    
    func render(maze: Maze)
    {
        setNeedsDisplay()
    }


    override func drawRect(rect: CGRect)
    {
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(ctx, 0.0, rect.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextTranslateCTM(ctx, self.frame.size.width*0.5, self.frame.size.height*0.5)
        
        CGContextSetLineWidth(ctx, 2.0)
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0)
        
        var indexesCount = 1
        for var level=0; level<maze.levelMultipliers.count; level++ {
            indexesCount *= maze.levelMultipliers[level]
            
            let anglePerNode: Double = 360.0/Double(indexesCount)
            
            for var index=0; index<indexesCount; index++ {
                let node = maze.nodes[MazeNodePosition(level: level, index: index)]!
                
                //try to draw wall to the right
                var rightIndex = index+1;
                if rightIndex >= indexesCount {
                    rightIndex = 0
                }
                
                if rightIndex != index && !node.paths[MazeNodePosition(level: level, index: rightIndex)] {
                        //draw wall to the right
                        
                        let angle = anglePerNode * Double(index+1)
                        let startX = Double(level)*self.levelSize * sin(angle * M_PI/180.0)
                        let startY = Double(level)*self.levelSize * cos(angle * M_PI/180.0)
                        
                        let endX = Double(level+1)*self.levelSize * sin(angle * M_PI/180.0)
                        let endY = Double(level+1)*self.levelSize * cos(angle * M_PI/180.0)
                        
                        CGContextMoveToPoint(ctx, startX, startY)
                        CGContextAddLineToPoint(ctx, endX, endY)

                        CGContextStrokePath(ctx)
                }

                let nextLevelMultiplier = level < Int(maze.levelMultipliers.count)-1 ? maze.levelMultipliers[level+1] : 1
                for var nextIndex=0; nextIndex<nextLevelMultiplier; nextIndex++ {
                    var mazePath: CGMutablePathRef
                    mazePath = CGPathCreateMutable()
                    //draw wall with space if there is connection
                    if node.paths[MazeNodePosition(level: level+1, index: index*nextLevelMultiplier + nextIndex)] {
                        /*let startAngle: Double = Double(index)*anglePerNode + Double(nextIndex)*(anglePerNode/Double(nextLevelMultiplier))
                        let endAngle: Double = Double(index)*anglePerNode + (Double(nextIndex)+1.0)*(anglePerNode/Double(nextLevelMultiplier))
                        let radius: Double = Double(level+1)*self.levelSize
                        
                        CGPathAddArc(mazePath, nil, 0.0, 0.0, radius, (90.0-startAngle)*M_PI/180.0,
                            (90.0-endAngle)*M_PI/180.0, true)*/
                    //otherwise, draw full wall
                    } else {
                        let startAngle: Double = Double(index)*anglePerNode + Double(nextIndex)*(anglePerNode/Double(nextLevelMultiplier))
                        let endAngle: Double = Double(index)*anglePerNode + (Double(nextIndex)+1.0)*(anglePerNode/Double(nextLevelMultiplier))
                        
                        let radius: Double = Double(level+1)*self.levelSize
                        CGPathAddArc(mazePath, nil, 0.0, 0.0, radius,
                            (90.0-startAngle)*M_PI/180.0,
                            (90.0-endAngle)*M_PI/180.0, true)
                    }
                    CGContextAddPath(ctx, mazePath)
                    CGContextStrokePath(ctx)
                }
            }
        }
    }
}
