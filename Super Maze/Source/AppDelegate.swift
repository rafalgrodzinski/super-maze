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
        
        self.window!.rootViewController = GameVC(isDebug: false);
        
        return true
    }
    
}

