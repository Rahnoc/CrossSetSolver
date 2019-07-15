//
//  LineInfo.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


/// 針對單一線段的當前 可用數字/已分配數字/有格子坐數字 的狀態。
public struct LineInfo {
    var free:Set<Int>               // 所有可能候選
    var distributable:Set<Int>      // 可分配至方塊中，但是哪個方塊可能不確定。
    var used:Set<Int>               // 有明確分配目標。
    
    
    public init?(sz:Int) {
        guard (sz > 0) else {
            print( "size must > 0, input = \(sz)." )
            return nil
        }
        
        self.free = []
        for i in 1 ... sz {
            self.free.insert(i)
        }
        
        self.distributable = []
        self.used = []
    }
    
    // ---------------------
    
    /// nums 是哪一格已知。 明確的說， nums.count=1。
    mutating func foundSeat(nums:Set<Int>) {
        self.free.subtract( nums )
        self.distributable.formUnion( nums )
        self.used.formUnion( nums )
    }
    
    /// nums 有被使用，但還不知道格子是哪一格。
    mutating func addDistributed(nums:Set<Int>) {
        self.free.subtract( nums )
        self.distributable.formUnion( nums )
        // 知道被使用，但沒有明確格子，所以 used 不更新。
    }
    
}
