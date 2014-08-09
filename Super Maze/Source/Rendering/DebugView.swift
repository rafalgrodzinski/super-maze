//
//  DebugView.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 03.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import UIKit


class DebugView: UIView {
    var ballPosition: CGPoint = CGPointZero
    var ballDiameter: CGFloat = 0.0
    var ballAngle: CGFloat = 0.0
    
    var maze: Maze? {
        willSet(newMaze) {
            self.mazeNeedsUpdate = self.maze !== newMaze
        }
    }
    var mazeImage: CGImageRef?
    var mazeNeedsUpdate: Bool = false
    
    
    required init(coder aDecoder: NSCoder!) {
        fatalError("NSCoding not supported")
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    func update()
    {
        self.setNeedsDisplay()
    }

    
    override func drawRect(rect: CGRect)
    {
        let ctx = UIGraphicsGetCurrentContext()
        
        //save current CTM
        CGContextSaveGState(ctx);
        
        //Clear view
        CGContextClearRect(ctx, rect)
        
        //flip y and set origin to center
        CGContextTranslateCTM(ctx, 0.0, self.frame.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextTranslateCTM(ctx, self.frame.size.width*0.5, self.frame.size.height*0.5)
        
        //draw maze
        if let maze = self.maze {
            if self.mazeNeedsUpdate {
                self.mazeImage = self.mazeImageFrom(maze)
                self.mazeNeedsUpdate = false
            }
            
            let width = CGFloat(CGImageGetWidth(self.mazeImage))
            let height = CGFloat(CGImageGetHeight(self.mazeImage))
            
            CGContextDrawImage(ctx, CGRectMake(-width*0.5, -height*0.5, width, height), self.mazeImage)
        }
        
        //Draw ball
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0)
        CGContextSetLineWidth(ctx, 2.0)
        
        let ballRect = CGRectMake(self.ballPosition.x - self.ballDiameter*0.5,
                                  self.ballPosition.y - self.ballDiameter*0.5,
                                  self.ballDiameter,
                                  self.ballDiameter)
        CGContextStrokeEllipseInRect(ctx, ballRect)
        
        //restore current CTM
        CGContextRestoreGState(ctx);
        
        UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    func mazeImageFrom(maze: Maze) -> CGImageRef
    {
        UIGraphicsBeginImageContext(self.frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        
        //flip y and set origin to center
        CGContextTranslateCTM(ctx, 0.0, self.frame.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextTranslateCTM(ctx, self.frame.size.width*0.5, self.frame.size.height*0.5)
        
        CGContextSetLineWidth(ctx, 2.0)
        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0)
        
        let levelSize: CGFloat = 40.0
        
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
                    
                    let startPoint = Utils.pointAtPolygon(angle, subdivision: 20, radius: CGFloat(level)*levelSize)
                    let endPoint = Utils.pointAtPolygon(angle, subdivision: 20, radius: CGFloat(level+1)*levelSize)
                    
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
                        
                        let radius: CGFloat = CGFloat(level+1)*levelSize
                        
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

        
        let mazeImage = UIGraphicsGetImageFromCurrentImageContext().CGImage
        UIGraphicsEndImageContext()
        
        return mazeImage
    }
}
