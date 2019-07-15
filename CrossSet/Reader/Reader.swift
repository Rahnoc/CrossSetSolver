//
//  Reader.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


public class Reader {
    
    /// 由完整陣列初始。
    public func buildBlocks(arr:[[Int]]) -> [Block] {
        var rtBlks:[Block] = []
        for numbers in arr {
            rtBlks.append( Block(numbers) )
        }
        
        return rtBlks
    }
    
    /// 由縮減陣列初始。
    public func buildBlocks(abbrArr:[Int]) -> [Block] {
        let arr = self.convertAbbrArr(arr: abbrArr)
        return self.buildBlocks(arr: arr)
    }
    
    // ------------------
    
    /// 將 [312, 43] -> [[3,1,2], [4,3]]
    func convertAbbrArr(arr:[Int]) -> [[Int]] {
        var rtArr:[[Int]] = []
        for n in arr {
            rtArr.append( self.numConvert(num: n) )
        }
        
        return rtArr
    }
    
    /// 將數字每個位數提出，轉為序列。
    /// e.g. 524 -> [5,2,4]
    /// * 預設輸出數字範圍在 1~9 內。
    private func numConvert(num:Int) -> [Int] {
        var rtArr:[Int] = []
        for c in num.description {
            rtArr.append( Int(String(c))! )
        }
        
        return rtArr
    }
}
