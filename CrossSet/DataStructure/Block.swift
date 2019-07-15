//
//  Block.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


public struct Block {
    public var numbers:[Int]
    public var isStable:Bool
    
    public init() {
        self.numbers = []
        self.isStable = false
    }
    
    public init(_ numbers:[Int]) {
        self.numbers = numbers
        self.isStable = false
    }
    
    // ---------------
    
    public func isEqual(other:Block) -> Bool {
        return Set(self.numbers) == Set(other.numbers)
    }
    
}
