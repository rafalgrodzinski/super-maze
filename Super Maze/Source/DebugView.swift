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
    
    init(frame: CGRect)
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
    }
}
