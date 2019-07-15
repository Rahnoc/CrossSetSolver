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
    
}
