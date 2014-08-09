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


enum MazeGenerationAlgorithm {
    case RecursiveBacktracker
}


class Maze {
    let type: MazeType
    let nodes: [MazeNodePosition : MazeNode]
    let levelMultipliers: [Int]

    
    init(thetaWithLevelMultipliers levelMultipliers: [Int])
    {
        type = .Theta
        self.levelMultipliers = levelMultipliers
        
        var nodes: [MazeNodePosition : MazeNode] = [:]
        
        //first create the nodes
        var indexesCount = 1;
        for var level=0; level<levelMultipliers.count; level++ {
            indexesCount *= levelMultipliers[level]
            for var index=0; index<indexesCount; index++ {
                var nodePosition = MazeNodePosition(level: level, index: index)
                var node = MazeNode(position: nodePosition)
                nodes[nodePosition] = node
            }
        }
        
        //now connect all the nodes with potential paths
        indexesCount = 1;
        for var level=0; level<levelMultipliers.count; level++ {
            indexesCount *= levelMultipliers[level];
            for var index=0; index<indexesCount; index++ {
                let node = nodes[MazeNodePosition(level: level, index: index)]
                
                //try to connect with left neighbour
                var leftIndex = index-1;
                if leftIndex < 0 {
                    leftIndex = indexesCount-1
                }
                node!.connectPotentially(nodes[MazeNodePosition(level: level, index: leftIndex)]!)
                
                //try to connect with right neighbour
                var rightIndex = index+1;
                if rightIndex >= indexesCount {
                    rightIndex = 0
                }
                node!.connectPotentially(nodes[MazeNodePosition(level: level, index: rightIndex)]!)
                
                //then connect with nodes at higher level (if there is a higher level
                if level < levelMultipliers.count-1 {
                    let nextLevelMultiplier = levelMultipliers[level+1]

                    for var nextIndex=0; nextIndex<nextLevelMultiplier; nextIndex++ {
                        let anotherNode = nodes[MazeNodePosition(level: level+1, index: nextLevelMultiplier*index + nextIndex)]
                        
                        node!.connectPotentially(nodes[MazeNodePosition(level: level+1, index: index*nextLevelMultiplier + nextIndex)]!)
                    }
                }
            }
        }
        
        self.nodes = nodes
    }
    
    
    func generateMaze(fromNode node: MazeNode, usingAlgorithm algorithm: MazeGenerationAlgorithm)
    {
        if algorithm == .RecursiveBacktracker {
            var scrambledPotentialNodes: Array<MazeNode> = []
            var nodeToScramble: MazeNode
            for nodeToScramble in node.potentialPaths.values {
                scrambledPotentialNodes.append(nodeToScramble)
            }
            
            for var i=0; i<scrambledPotentialNodes.count; i++ {
                var tempNode = scrambledPotentialNodes[i]
                var randomIndex = Int(arc4random_uniform(UInt32(scrambledPotentialNodes.count)))
                
                scrambledPotentialNodes[i] = scrambledPotentialNodes[randomIndex]
                scrambledPotentialNodes[randomIndex] = tempNode
            }
            
            var potentialNode: MazeNode
            for potentialNode in scrambledPotentialNodes {
                if node.tryConnecting(potentialNode) {
                    generateMaze(fromNode: potentialNode, usingAlgorithm: algorithm)
                }
            }
        }
    }
}