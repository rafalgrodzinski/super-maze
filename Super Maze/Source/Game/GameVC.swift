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


class GameVC: UIViewController {
    internal let gameView: UIView
    internal let isDebug: Bool
    
    internal var displayLink: CADisplayLink?
    internal var maze: Maze?
    internal var physics: Physics?
    internal var motionManager: CMMotionManager?
    
    internal var rotation: CGPoint = CGPointZero
    
    
    required init(coder aDecoder: NSCoder!)
    {
        fatalError("NSCoding not supported")
    }
    
    
    init(isDebug: Bool)
    {
        self.gameView = UIView()
        self.isDebug = isDebug
        
        super.init(nibName: nil, bundle: nil)
        
        class GameView: UIView {
            required init(coder aDecoder: NSCoder!)
            {
                fatalError("NSCoding not supported")
            }
            
            
            /*override class func layerClass() -> AnyClass!
            {
                return CAMetalLayer.self
            }*/
        }

        if self.isDebug {
            self.gameView = DebugView(frame: self.view.frame)
        } else {
            //self.gameView = GameView(frame: self.view.frame)
        }
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.gameView)
    }
    
    
    override func viewDidLoad()
    {
        self.maze = Maze(thetaWithLevelMultipliers: [1, 4, 2, 1, 2, 2], levelSize: 30.0, wallSize:20.0)
        self.maze?.generateMaze(fromNode: self.maze!.nodes[MazeNodePosition(level: 0, index: 0)]!, usingAlgorithm: .RecursiveBacktracker)
        self.physics = Physics(maze: self.maze)
        
        self.motionManager = CMMotionManager()
        self.motionManager!.deviceMotionUpdateInterval = NSTimeInterval(1.0/60.0)
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        self.displayLink = CADisplayLink(target: self, selector: Selector("update"))
        self.displayLink!.frameInterval = 2
        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        self.motionManager?.startDeviceMotionUpdates()
    }
    
    
    func update()
    {
        //get rotation
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
        
        self.physics?.updateWithInterval(CGFloat(self.displayLink!.duration), rotation: self.rotation)
        
        (self.gameView as DebugView).maze = self.maze
        
        (self.gameView as DebugView).ballPosition = self.physics!.ballPosition
        (self.gameView as DebugView).ballDiameter = self.physics!.ballDiameter
        (self.gameView as DebugView).ballAngle = self.physics!.ballAngle
        
        (self.gameView as DebugView).update()
    }
}
