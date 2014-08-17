//
//  MazeNode.swift
//  Super Maze
//
//  Created by Rafal Grodzinski on 01/07/2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import Foundation


public struct MazeNodePosition : Hashable, Equatable {
    public var level: Int
    public var index: Int
    
    public var hashValue: Int {
        get {
            return level * 0xffff + index
        }
    }
}


public func ==(left: MazeNodePosition, right: MazeNodePosition) -> Bool
{
    return left.level == right.level && left.index == right.index
}


@objc public class MazeNode {
    
    public let position: MazeNodePosition

    public var potentialPaths: Dictionary<MazeNodePosition, MazeNode> = [:]
    public var paths: Dictionary<MazeNodePosition, MazeNode> = [:]
    public var visited: Bool = false


    public init(position: MazeNodePosition)
    {
        self.position = position
    }
    
    
    public func connectPotentially(node: MazeNode)
    {
        if node.position != self.position && self.potentialPaths[node.position] == nil {
            self.potentialPaths[node.position] = node
            node.potentialPaths[self.position] = self
        }
    }
    
    
    public func tryConnecting(node: MazeNode) -> Bool
    {
        if node.position != self.position && self.paths[node.position] == nil && !node.visited {
            self.paths[node.position] = node
            node.paths[self.position] = self
            node.visited = true
            self.visited = true
            
            return true
        }
        
        return false
    }
}
