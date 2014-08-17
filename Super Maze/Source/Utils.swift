//
//  Utils.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 27.07.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import CoreGraphics


@objc public class Polygon {
    let v0: CGPoint
    let v1: CGPoint
    let v2: CGPoint
    let v3: CGPoint
    
    public init(v0: CGPoint, v1: CGPoint, v2: CGPoint, v3: CGPoint)
    {
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
    }
}


public class Utils {
    public class func pointAtPolygon(var angle: CGFloat, subdivision: Int, radius: CGFloat) -> CGPoint
    {
        if angle < 0.0 {
            angle += 360.0
        }
        
        let anglePerPoly: CGFloat = 360.0/CGFloat(subdivision)
        let firstAngle: CGFloat = CGFloat(Int(angle/anglePerPoly)) * anglePerPoly
        
        let beta: CGFloat = angle - firstAngle
        let gamma: CGFloat = (180.0 - anglePerPoly)*0.5
        let delta: CGFloat = 180.0 - beta - gamma
        
        let c: CGFloat = (radius * sin(gamma * CGFloat(M_PI/180.0)))/sin(delta * CGFloat(M_PI/180.0))
        
        let x: CGFloat = sin(angle * CGFloat(M_PI/180.0)) * c
        let y: CGFloat = cos(angle * CGFloat(M_PI/180.0)) * c
        
        return CGPointMake(x, y)
    }
    
    
    public class func vertices(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, subdivision: Int, radius: CGFloat) -> Array<CGPoint>
    {
        var vertices = [CGPoint]()
        
        let anglePerPoly: CGFloat = 360.0/CGFloat(subdivision)
        
        var firstAngle: CGFloat = CGFloat(Int(startAngle/anglePerPoly)) * anglePerPoly
        if firstAngle < startAngle {
            firstAngle += anglePerPoly
        }
        
        var lastAngle: CGFloat = CGFloat(Int(endAngle/anglePerPoly)) * anglePerPoly
        
        if firstAngle != startAngle {
            let vert = pointAtPolygon(startAngle, subdivision: subdivision, radius: radius)
            vertices.append(vert)
        }
        
        for var angle = firstAngle; angle <= endAngle; angle += anglePerPoly {
            let vert = pointAtPolygon(angle, subdivision: subdivision, radius: radius)
            vertices.append(vert)
        }
        
        if lastAngle != endAngle {
            let vert = pointAtPolygon(endAngle, subdivision: subdivision, radius: radius)
            vertices.append(vert)
        }
        
        return vertices
    }
}
