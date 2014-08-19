//
//  GameVC.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 31.07.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import UIKit
import QuartzCore
import CoreMotion
import Metal


class MazeRendererView: UIView {
    required init(coder aDecoder: NSCoder)
    {
        fatalError("NSCoding not supported")
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    
    override class func layerClass() -> AnyClass
    {
        return CAMetalLayer.self
    }
}


class GameVC: UIViewController {
    //State
    internal let isDebug: Bool
    
    //Model
    internal var maze: Maze?
    
    //Graphics
    internal var rendererView: UIView?
    internal var debugView: DebugView?
    internal var renderer: MazeRenderer?
    internal var displayLink: CADisplayLink?

    //Physics
    internal var physics: Physics?
    
    //Input
    internal var motionManager: CMMotionManager?
    internal var rotation: CGPoint = CGPointZero
    
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("NSCoding not supported")
    }
    
    
    init(isDebug: Bool)
    {
        self.isDebug = isDebug

        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    
    override func viewDidLoad()
    {
        //Data Model
        self.maze = Maze(thetaWithLevelMultipliers: [1, 4, 2, 1, 2, 2, 1, 1], levelSize: 30.0, wallSize:20.0)
        self.maze?.generateMaze(fromNode: self.maze!.nodes[MazeNodePosition(level: 0, index: 0)]!, usingAlgorithm: .RecursiveBacktracker)
        
        //Graphics
        if self.isDebug {
            self.debugView = DebugView(frame: self.view.frame, maze: self.maze!)
            self.view.addSubview(self.debugView!)
        } else {
            self.rendererView = MazeRendererView(frame: self.view.frame)
            self.view.addSubview(self.rendererView!)
            self.renderer = MazeRenderer(maze: self.maze!, rendererView: self.rendererView!)
        }
        
        //Physics
        self.physics = Physics(maze: self.maze)

        //Input
        self.motionManager = CMMotionManager()
        self.motionManager?.deviceMotionUpdateInterval = NSTimeInterval(1.0/60.0)
        self.motionManager?.startDeviceMotionUpdates()
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        self.displayLink = CADisplayLink(target: self, selector: Selector("update"))
        self.displayLink?.frameInterval = 1
        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        

    }
    
    
    func update()
    {
        //Update Input
        if let attitude: CMAttitude = self.motionManager?.deviceMotion?.attitude? {
            self.rotation = CGPointMake(CGFloat(attitude.roll*180.0/M_PI), CGFloat(-attitude.pitch*180.0/M_PI))
            if self.rotation.x < -90.0 {
                self.rotation.x = -90.0
            } else if self.rotation.x > 90.0 {
                self.rotation.x = 90.0
            }
            
            if self.rotation.y < -90.0 {
                self.rotation.y = -90.0
            } else if self.rotation.y > 90.0 {
                self.rotation.y = 90.0
            }
        }
        
        //Update Physics
        self.physics?.updateWithInterval(CGFloat(self.displayLink!.duration), rotation: self.rotation)
        
        //Update Graphics
        if self.isDebug {
            self.debugView?.ballPosition = self.physics!.ballPosition
            self.debugView?.ballDiameter = self.physics!.ballDiameter
            self.debugView?.ballAngle = self.physics!.ballAngle
            
            self.debugView?.redraw()
        } else {
            self.renderer?.redraw()
        }
    }
}
