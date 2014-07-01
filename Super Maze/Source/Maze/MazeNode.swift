//
//  MazeNode.swift
//  Super Maze
//
//  Created by Rafal Grodzinski on 01/07/2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import Foundation


struct MazeNodePosition : Hashable, Equatable {
    var level: Int
    var index: Int
    
    var hashValue: Int {
        get {
            return level * 0xffff + index
        }
    }
}

@infix func ==(left: MazeNodePosition, right: MazeNodePosition) -> Bool
{
    return left.level == right.level && left.index == right.index
}


class MazeNode {
    
    let position: MazeNodePosition

    var potentialPaths: Dictionary<MazeNodePosition, MazeNode> = [:]
    var paths: Dictionary<MazeNodePosition, MazeNode> = [:]


    init(position: MazeNodePosition)
    {
        self.position = position
    }
    
    
    func connectPotentially(node: MazeNode?)
    {
        if node {
            if self.potentialPaths[node!.position] == nil {
                self.potentialPaths[node!.position] = node!
                println("Connection between \(self.position.level)x\(self.position.index) and \(node!.position.level)x\(node!.position.index)")
                node!.potentialPaths[self.position] = self
            }
        }
    }
}
