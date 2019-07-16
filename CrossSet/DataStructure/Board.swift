//
//  Board.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


// Row-first.
public class Board: CustomStringConvertible {
    
    var blocks:CssArray2D<Block>
    
    var colInfo:[LineInfo]
    var rowInfo:[LineInfo]
    
    public var width:Int {
        get { return self.blocks.dim.x }
    }
    public var height:Int {
        get { return self.blocks.dim.y }
    }
    
    // ----------------
    
    public init?(w:Int, h:Int, blocks:[Block]) {
        guard let b2d = CssArray2D(x: w, y: h, tiles: blocks) else {
            return nil
        }
        
        self.blocks = b2d
        
        self.colInfo = []
        for _ in 0 ..< w {
            self.colInfo.append( LineInfo(sz: h)! )
        }
        self.rowInfo = []
        for _ in 0 ..< h {
            self.rowInfo.append( LineInfo(sz: w)! )
        }
    }
    
    
    public init(copyFrom:Board) {
        // elm 為 struct。
        self.blocks = CssArray2D<Block>(copyFrom: copyFrom.blocks)
        self.colInfo = copyFrom.colInfo
        self.rowInfo = copyFrom.rowInfo
    }
    
    // -----------------
    
    /// 是否全 block 均為 stable？
    public func isAllStable() -> Bool {
        for i in 0 ..< self.blocks.dim.x {
            for j in 0 ..< self.blocks.dim.y {
                if(self.blocks[(i, j)].isStable == false) {
                    return false
                }
            }
        }
        
        return true
    }
    
    
    public var description: String {
        get{
            var rtStr = String()
            for j in 0 ..< self.height {
                for i in 0 ..< self.width {
                    let block = self.blocks[(i,j)]
                    rtStr += "\(block.numbers) "
                }
                rtStr += "\n"
            }
            
            return rtStr
        }
    }
    
    
    public func isContradiction() -> Bool {
        // for all cols
        for i in 0 ..< self.blocks.dim.x {
            var colStableArr:[Int] = []
            for j in 0 ..< self.blocks.dim.y {
                let block = self.blocks[(i, j)]
                if(block.isStable) {
                    colStableArr.append( block.numbers.first! )
                }
            }
            
            if self.hasRepeatedElm(arr: colStableArr) {
                return true
            }
        }
        
        // for all rows
        for j in 0 ..< self.blocks.dim.y {
            var rowStableArr:[Int] = []
            for i in 0 ..< self.blocks.dim.x {
                let block = self.blocks[(i, j)]
                if(block.isStable) {
                    rowStableArr.append( block.numbers.first! )
                }
            }
            
            if self.hasRepeatedElm(arr: rowStableArr) {
                return true
            }
        }
        
        return false
    }
    
    
    private func hasRepeatedElm(arr:[Int]) -> Bool {
        let sArr = arr.sorted()
        
        for (i, v1) in sArr.enumerated() {
            for (j, v2) in sArr.enumerated() {
                if (i == j) {continue}
                if (v1 == v2) {
                    return true
                }
            }
        }
        
        return false
    }
    
}
