//
//  Block.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


public struct Block {
    public var numbers:Set<Int>
    public var isStable:Bool {
        get { return (self.numbers.count == 1) }
    }
    
    public init() {
        self.numbers = Set<Int>()
    }
    
    public init(_ numbers:[Int]) {
        self.numbers = Set<Int>(numbers)
    }
    
    // ---------------
    
    public func isEqual(other:Block) -> Bool {
        return Set(self.numbers) == Set(other.numbers)
    }
    
}
