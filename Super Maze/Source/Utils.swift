//
//  Utils.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 27.07.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import CoreGraphics


class Utils {
    class func pointAtPolygon(angle: CGFloat, subdivision: Int, radius: CGFloat) -> CGPoint
    {
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
    
    
    class func verticesFromAngle(fromAngle startAngle: CGFloat, toAngle endAngle: CGFloat, subdivision: Int, radius: CGFloat) -> Array<CGPoint>
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
            vertices += vert
        }
        
        for var angle = firstAngle; angle <= endAngle; angle += anglePerPoly {
            let vert = pointAtPolygon(angle, subdivision: subdivision, radius: radius)
            vertices += vert
        }
        
        if lastAngle != endAngle {
            let vert = pointAtPolygon(endAngle, subdivision: subdivision, radius: radius)
            vertices += vert
        }
        
        return vertices
    }
}
