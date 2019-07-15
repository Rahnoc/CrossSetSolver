//
//  LineInfo.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


public struct LineInfo {
    var uncertain:[Int]
    var distributable:[Int]     // 可分配至方塊中，但是哪個方塊可能不確定。
    var found:[Int]             // 有明確分配目標。
    
    public init(_ input:[Int]) {
        self.uncertain = input.sorted()
        self.distributable = []
        self.found = []
    }
    
    public init(sz:Int) {
        self.uncertain = []
        for i in 1 ... sz {
            self.uncertain.append( i )
        }
        self.distributable = []
        self.found = []
    }
    
}
