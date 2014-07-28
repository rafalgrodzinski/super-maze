//
//  AppDelegate.swift
//  Super Maze
//
//  Created by Rafał Grodziński on 30.06.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.makeKeyAndVisible()
        
        var maze = Maze(thetaWithLevelMultipliers: [1, 8, 2, 1, 2, 1, 1, 2])
        maze.generateMaze(fromNode: maze.nodes[MazeNodePosition(level: 0, index: 0)]!, usingAlgorithm: .RecursiveBacktracker)
        
        let vc = UIViewController();
        let mazeView = MazeRenderer2D(frame: UIScreen.mainScreen().bounds, maze: maze, levelSize: 20.0)
        vc.view = mazeView
        
        self.window!.rootViewController = vc
        
        //let a = Utils.verticesFromAngle(fromAngle: 30.0, toAngle: 160.0, subdivision: 5, radius: 100.0)
        
        return true
    }
    
}

