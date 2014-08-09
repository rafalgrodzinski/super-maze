//
//  MazeRenderer2D.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 05.07.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import UIKit
import Foundation


class MazeRenderer2D: UIView {
    let maze: Maze
    let levelSize: CGFloat
    
    
    required init(coder aDecoder: NSCoder!)
    {
        fatalError("NSCoding not supported")
    }

    
    init(frame: CGRect, maze: Maze, levelSize: CGFloat)
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
        for var level: Int = 0; level<maze.levelMultipliers.count; level++ {
            indexesCount *= maze.levelMultipliers[level]
            
            let anglePerNode: CGFloat = 360.0/CGFloat(indexesCount)
            
            for var index: Int = 0; index<indexesCount; index++ {
                let node = maze.nodes[MazeNodePosition(level: level, index: index)]!
                
                //try to draw wall to the right
                var rightIndex = index+1;
                if rightIndex >= indexesCount {
                    rightIndex = 0
                }
                
                if rightIndex != index && node.paths[MazeNodePosition(level: level, index: rightIndex)] == nil {
                        //draw wall to the right
                        
                    let angle: CGFloat = anglePerNode * CGFloat(index+1);
                    
                        let startPoint = Utils.pointAtPolygon(angle, subdivision: 20, radius: CGFloat(level)*self.levelSize)
                        let endPoint = Utils.pointAtPolygon(angle, subdivision: 20, radius: CGFloat(level+1)*self.levelSize)

                        /*let startX = CGFloat(level)*self.levelSize * sin(angle * CGFloat(M_PI/180.0))
                        let startY = CGFloat(level)*self.levelSize * cos(angle * CGFloat(M_PI/180.0))
                        
                        let endX = CGFloat(level+1)*self.levelSize * sin(angle * CGFloat(M_PI/180.0))
                        let endY = CGFloat(level+1)*self.levelSize * cos(angle * CGFloat(M_PI/180.0))*/
                        
                        CGContextMoveToPoint(ctx, startPoint.x, startPoint.y)
                        CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y)

                        CGContextStrokePath(ctx)
                }

                let nextLevelMultiplier: Int = level < Int(maze.levelMultipliers.count)-1 ? maze.levelMultipliers[level+1] : 1
                for var nextIndex: Int = 0; nextIndex<nextLevelMultiplier; nextIndex++ {
                    var mazePath: CGMutablePathRef
                    mazePath = CGPathCreateMutable()
                    //draw wall with space if there is connection
                    if node.paths[MazeNodePosition(level: level+1, index: index*nextLevelMultiplier + nextIndex)] != nil {
                        /*let startAngle: CGFloat = CGFloat(index)*anglePerNode + CGFloat(nextIndex)*(anglePerNode/CGFloat(nextLevelMultiplier))
                        let endAngle: CGFloat = CGFloat(index)*anglePerNode + (CGFloat(nextIndex)+1.0)*(anglePerNode/CGFloat(nextLevelMultiplier))
                        let radius: CGFloat = CGFloat(level+1)*self.levelSize
                        
                        CGPathAddArc(mazePath, nil, 0.0, 0.0, radius, (90.0-startAngle)*M_PI/180.0,
                            (90.0-endAngle)*M_PI/180.0, true)*/
                    //otherwise, draw full wall
                    } else {
                        let startAngle: CGFloat = CGFloat(index)*anglePerNode + CGFloat(nextIndex)*(anglePerNode/CGFloat(nextLevelMultiplier))
                        let endAngle: CGFloat = CGFloat(index)*anglePerNode + (CGFloat(nextIndex)+1.0)*(anglePerNode/CGFloat(nextLevelMultiplier))
                        
                        let radius: CGFloat = CGFloat(level+1)*self.levelSize
                        
                        let verts = Utils.verticesFromAngle(fromAngle: startAngle, toAngle: endAngle, subdivision: 20, radius: radius)
                        let first: CGPoint = verts[0]
                        CGContextMoveToPoint(ctx, first.x, first.y)
                        var i: Int
                        for i = 1; i<verts.count; i++ {
                            let point: CGPoint = verts[i]
                            CGContextAddLineToPoint(ctx, point.x, point.y)
                        }
    
                        /*CGPathAddArc(mazePath, nil, 0.0, 0.0, radius,
                            CGFloat(90.0 - startAngle) * CGFloat(M_PI/180.0),
                            CGFloat(90.0-endAngle) * CGFloat(M_PI/180.0),
                            true)*/
                    }
                    CGContextAddPath(ctx, mazePath)
                    CGContextStrokePath(ctx)
                }
            }
        }
    }
}
