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
    var w:Int
    var h:Int
    var blocks:[Block]
    
    public init(w:Int, h:Int, blocks:[Block]) {
        self.w = w
        self.h = h
        self.blocks = blocks
    }
    
    public init(copyFrom: Board) {
        self.w = copyFrom.w
        self.h = copyFrom.h
        
        self.blocks = copyFrom.blocks
    }
    
    // ----------------
    
    public func getRowIndex(r:Int) -> [Int] {
        var rtIdx:[Int] = []
        // (r-1)*w ..<r*w
        let lb:Int = (r-1) * self.w
        let rb:Int = r * self.w
        
        for i in lb ..< rb {
            rtIdx.append( i )
        }
        
        return rtIdx
    }
    
    public func getColIndex(c:Int) -> [Int] {
        var rtIdx:[Int] = []
        //
        for i in 0 ..< self.h {
            let idx:Int = (c - 1) + (i * self.w)
            rtIdx.append( idx )
        }
        
        return rtIdx
    }
    
    // -----------
    
    public var description: String {
        get{
            var rtStr = String()
            for i in 1 ... self.h {
                let idxs = self.getRowIndex(r: i)
                for idx in idxs {
                    let block = self.blocks[idx]
                    rtStr += "\(block.numbers) "
                }
                
                rtStr += "\n"
            }
            
            
            return rtStr
        }
    }
}
