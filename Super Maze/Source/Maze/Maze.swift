//
//  Maze.swift
//  Super Maze
//
//  Created by Rafal Grodzinski on 01/07/2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

import Foundation


enum MazeType {
    case Theta
}


class Maze {
    let type: MazeType
    let nodes: Dictionary<MazeNodePosition, MazeNode>

    
    init(thetaWithLevelMultipliers levelMultipliers: Int[])
    {
        type = .Theta
        
        var nodes: Dictionary<MazeNodePosition, MazeNode> = [:]
        
        //initial node
        /*let initialNodePosition = MazeNodePosition(level: 0, index: 0)
        let initialNode = MazeNode(position: initialNodePosition)
        nodes[initialNodePosition] = initialNode*/
        
        //rest of the nodes
        var indexesCount = 1;
        var level: Int
        for level in 0..levelMultipliers.count {
            indexesCount *= levelMultipliers[level]
            var index: Int
            for index in 0..indexesCount {
                var nodePosition = MazeNodePosition(level: level, index: index)
                var node = MazeNode(position: nodePosition)
                nodes[nodePosition] = node
            }
        }
        
        //now connect all the nodes with potential paths
        indexesCount = 1;
        for var level=0; level<levelMultipliers.count; level++ {
            let nextLevelMultiplier = levelMultipliers[level+1]
            
            for var index=0; index<indexesCount; index++ {
                let node = nodes[MazeNodePosition(level: level, index: index)]
                for var nextIndex=0; nextIndex<nextLevelMultiplier; nextIndex++ {
                    let anotherNode = nodes[MazeNodePosition(level: level+1, index: nextLevelMultiplier*index + nextIndex)]
                    
                    node!.connectPotentially(anotherNode)
                }
                
                let rightNode = nodes[MazeNodePosition(level: level, index: index+1)]
                node!.connectPotentially(rightNode)
            }
            
            indexesCount *= levelMultipliers[level+1]
        }
        
        self.nodes = nodes
    }
}