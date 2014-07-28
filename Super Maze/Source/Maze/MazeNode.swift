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
    var visited: Bool = false


    init(position: MazeNodePosition)
    {
        self.position = position
    }
    
    
    func connectPotentially(node: MazeNode)
    {
        if node.position != self.position &&  !self.potentialPaths[node.position]{
            self.potentialPaths[node.position] = node
            node.potentialPaths[self.position] = self
        }
    }
    
    
    func tryConnecting(node: MazeNode) -> Bool
    {
        if node.position != self.position && !self.paths[node.position] && !node.visited {
            self.paths[node.position] = node
            node.paths[self.position] = self
            node.visited = true
            self.visited = true
            
            return true
        }
        
        return false
    }
}
