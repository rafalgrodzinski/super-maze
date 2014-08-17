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
    var shouldUpdate: Bool = true
    
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
        if self.shouldUpdate {
            self.setNeedsDisplay()
        }
        
        self.shouldUpdate = !self.shouldUpdate
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
        
        //outside walls
        for var level=0; level<maze.levelMultipliers.count; level++ {
            let polys = maze.ousideWallPolygons(atLevel: level)
            
            var poly: Polygon
            for poly in polys {
                let path = CGPathCreateMutable();
                CGPathMoveToPoint(path, nil, poly.v0.x, poly.v0.y)
                CGPathAddLineToPoint(path, nil, poly.v1.x, poly.v1.y)
                CGPathAddLineToPoint(path, nil, poly.v2.x, poly.v2.y)
                CGPathAddLineToPoint(path, nil, poly.v3.x, poly.v3.y)
                CGPathAddLineToPoint(path, nil, poly.v0.x, poly.v0.y)
                CGContextAddPath(ctx, path)
                //CGContextStrokePath(ctx)
                CGContextFillPath(ctx)
            }
        }
        
        //inside walls
        for var level=0; level<maze.levelMultipliers.count; level++ {
            let polys = maze.wallPolygons(atLevel: level)
            
            var poly: Polygon
            for poly in polys {
                let path = CGPathCreateMutable();
                CGPathMoveToPoint(path, nil, poly.v0.x, poly.v0.y)
                CGPathAddLineToPoint(path, nil, poly.v1.x, poly.v1.y)
                CGPathAddLineToPoint(path, nil, poly.v2.x, poly.v2.y)
                CGPathAddLineToPoint(path, nil, poly.v3.x, poly.v3.y)
                CGPathAddLineToPoint(path, nil, poly.v0.x, poly.v0.y)
                CGContextAddPath(ctx, path)
                //CGContextStrokePath(ctx)
                CGContextFillPath(ctx)
            }
        }
        
        let mazeImage = UIGraphicsGetImageFromCurrentImageContext().CGImage
        UIGraphicsEndImageContext()
        
        return mazeImage
    }
}
