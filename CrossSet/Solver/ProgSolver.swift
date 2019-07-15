//
//  ProgSolver.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/15.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


public class ProgSolver {
    var workspace:Board
    
    
    public init(input:Board) {
        self.workspace = input
    }
    
    // -------------------------
    
    // Solve
    // Mark as sovled:
    
    // Perform for single row | single col:
    // (1) Block with only one choice.
    //     -> Mark as stable, update [distributable] [found].
    // (2) Check row/col for only appear once.
    //     -> Mark as stable, update [distributable] [found].
    // (3) n same n-tuple block
    //     -> update [distributable]
    //
    // (4) Block - [Candidate] reduction.
    //     -> update workspace.
    
    // [certain] or any block has changed : modify flag = true.
    // repeat same line when modify=true.
    
    // When reaching the last line, do stable check.
    // When all blocks are stable, puz is solved.
    
    
    func solve() {
        print(" > Puzzle >")
        print( self.workspace )
        
        var modified:Bool = false
        
        repeat{
            modified = false
            
            modified = modified || self.phase1()
            modified = modified || self.phase2()
            modified = modified || self.phase3()
            modified = modified || self.phase4()
        }while( modified && !self.workspace.isAllStable() )
        
        
        print( " -----[answer]----- " )
        print( self.workspace )
    }
    
    
    // ------------------------
    
    private func phase1() -> Bool {
        var modifiedAtLeastOnce:Bool = false
        var modified:Bool = false
        
        repeat{
            modified = false
            
            for c in 1 ... self.workspace.width {
                modified = modified || self.uniquenessCheck(col: c)
                modifiedAtLeastOnce = modifiedAtLeastOnce || modified
            }
            
            for r in 1 ... self.workspace.height {
                modified = modified || self.uniquenessCheck(row: r)
                modifiedAtLeastOnce = modifiedAtLeastOnce || modified
            }
        }while(modified)
        
        return modifiedAtLeastOnce
    }
    
    private func phase2() -> Bool {
        var modifiedAtLeastOnce:Bool = false
        var modified:Bool = false
        
        repeat{
            modified = false
            
            for c in 1 ... self.workspace.width {
                modified = modified || self.appearOnceCheck(col: c)
                modifiedAtLeastOnce = modifiedAtLeastOnce || modified
            }
            
            for r in 1 ... self.workspace.height {
                modified = modified || self.appearOnceCheck(row: r)
                modifiedAtLeastOnce = modifiedAtLeastOnce || modified
            }
        }while(modified)
        
        return modifiedAtLeastOnce
    }
    
    private func phase3() -> Bool {
        var modifiedAtLeastOnce:Bool = false
        var modified:Bool = false
        
        repeat{
            modified = false
            
            for c in 1 ... self.workspace.width {
                modified = modified || self.nTupleCheck(col: c)
                modifiedAtLeastOnce = modifiedAtLeastOnce || modified
            }
            
            for r in 1 ... self.workspace.height {
                modified = modified || self.nTupleCheck(row: r)
                modifiedAtLeastOnce = modifiedAtLeastOnce || modified
            }
        }while(modified)
        
        return modifiedAtLeastOnce
    }
    
    private func phase4() -> Bool {
        var modifiedAtLeastOnce:Bool = false
        
        for c in 1 ... self.workspace.width {
            let modified = self.lineReduction(col: c)
            modifiedAtLeastOnce = modifiedAtLeastOnce || modified
        }
        
        for r in 1 ... self.workspace.height {
            let modified = self.lineReduction(row: r)
            modifiedAtLeastOnce = modifiedAtLeastOnce || modified
        }
        
        return modifiedAtLeastOnce
    }
    
    
    
    // -------------------------
    
}




public extension ProgSolver {
    // 1. uniqueness Check
    // 找出只有一個解的格子 = 可確定該格值。
    
    private func uniquenessCheck(col:Int) -> Bool {
        var modified:Bool = false
        let colIndex = col - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.colInfo[colIndex]
        
        for j in 0 ..< self.workspace.height {
            let block = self.workspace.blocks[(colIndex, j)]
            
            if block.numbers.isSubset(of: lineInfo.used) {
                // 已經在 line info 中標記為有座位，就跳過。
                continue
            }
            
            if (block.isStable) {
                // 更新 line info。
                self.workspace.colInfo[colIndex].foundSeat(nums: block.numbers)
                self.workspace.rowInfo[j].foundSeat(nums: block.numbers)
                modified = true
            }
        }
        
        return modified
    }
    
    private func uniquenessCheck(row:Int) -> Bool {
        var modified:Bool = false
        let rowIndex = row - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.rowInfo[rowIndex]
        
        for i in 0 ..< self.workspace.width {
            let block = self.workspace.blocks[(i, rowIndex)]
            
            if block.numbers.isSubset(of: lineInfo.used) {
                // 已經在 line info 中標記為有座位，就跳過。
                continue
            }
            
            if (block.isStable) {
                // 更新 line info。
                self.workspace.colInfo[i].foundSeat(nums: block.numbers)
                self.workspace.rowInfo[rowIndex].foundSeat(nums: block.numbers)
                modified = true
            }
        }
        
        return modified
    }
    
    
    // 2. Appear Once check
    // 每一行列，均由 1,2 ... n 分配。 這裡找出於某行/列只出現一次的數字，此數字必定填入該格。
    
    private func appearOnceCheck(col:Int) -> Bool {
        var modified:Bool = false
        let colIndex = col - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.colInfo[colIndex]
        var founds:[(i:Int, n:Int)] = []
        
        // 目標為所有尚未確定座位的數字。 (包含 n-tuple)
        for number in lineInfo.free.union( lineInfo.distributable.subtracting(lineInfo.used) ) {
            var count:Int = 0
            var seatIdx:Int?
            
            for j in 0 ..< self.workspace.height {
                let block = self.workspace.blocks[(colIndex, j)]
                if (block.isStable == false) && (block.numbers.contains( number )) {
                    seatIdx = j
                    count += 1
                }
            }
            
            if (count == 1) {
                founds.append( (seatIdx!, number) )
            }
        }
        
        // Apply change.
        for f in founds {
            // 更新 block
            self.workspace.blocks[(colIndex, f.i)].numbers = [f.n]
            // 更新 line info。
            self.workspace.colInfo[colIndex].foundSeat(nums: [f.n])
            self.workspace.rowInfo[f.i].foundSeat(nums: [f.n])
            modified = true
        }
        
        return modified
    }
    
    private func appearOnceCheck(row:Int) -> Bool {
        var modified:Bool = false
        let rowIndex = row - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.rowInfo[rowIndex]
        var founds:[(i:Int, n:Int)] = []
        
        // 目標為所有尚未確定座位的數字。 (包含 n-tuple)
        for number in lineInfo.free.union( lineInfo.distributable.subtracting(lineInfo.used) ) {
            var count:Int = 0
            var seatIdx:Int?
            
            for i in 0 ..< self.workspace.width {
                let block = self.workspace.blocks[(i, rowIndex)]
                if (block.isStable == false) && (block.numbers.contains( number )) {
                    seatIdx = i
                    count += 1
                }
            }
            
            if (count == 1) {
                founds.append( (seatIdx!, number) )
            }
        }
        
        // Apply change.
        for f in founds {
            // 更新 block
            self.workspace.blocks[(f.i, rowIndex)].numbers = [f.n]
            // 更新 line info。
            self.workspace.colInfo[f.i].foundSeat(nums: [f.n])
            self.workspace.rowInfo[rowIndex].foundSeat(nums: [f.n])
            modified = true
        }
        
        return modified
    }
    
    
    // 3. n-tuple check
    // 找出某行/列是否有連續n格為相同內容的n-tuple。 若有，則將 n-tuple 納入該行列的 distributable 紀錄中。
    // distributable 與 found 的差異在於， found 內為可確定在哪一格。
    // 而 distributable 表示該行列目前可確定已分配給某格的值，但實際是哪一個不見得確定。
    // e.g. [1,2] [1,2] [1,3] 根據鴿籠定理，這兩格一定一個是 [1]，另一個是 [2]。 但順序尚無法確定。
    // 但既然 1 確定在前兩格，則 [1,3] 可削減為 [3]。 實作中，為將 [1,3] 減去 distributable=[1,2]。
    
    private func nTupleCheck(col:Int) -> Bool {
        var modified:Bool = false
        let colIndex = col - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.colInfo[colIndex]
        
        // 找 n-tuple
        for j in 0 ..< self.workspace.height {
            let sBlock = self.workspace.blocks[(colIndex, j)]
            if(sBlock.isStable) || (sBlock.numbers.isSubset(of: lineInfo.distributable)) {
                // 已解，或有加入過 distributable 的跳過。
                continue
            }
            var count:Int = 1
            
            for j2 in 0 ..< self.workspace.height {
                if(j == j2) {
                    // 自己那格，跳過。
                    continue
                }
                let tBlock = self.workspace.blocks[(colIndex, j2)]
                if sBlock.isEqual(other: tBlock) {
                    count += 1
                }
            }
            
            if (count == sBlock.numbers.count) {
                // consecutive n-tuple found. 更新 line info。
                self.workspace.colInfo[colIndex].addDistributed(nums: sBlock.numbers)
                modified = true
            }
        }
        
        
        return modified
    }
    
    private func nTupleCheck(row:Int) -> Bool {
        var modified:Bool = false
        let rowIndex = row - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.rowInfo[rowIndex]
        
        // 找 n-tuple
        for i in 0 ..< self.workspace.width {
            let sBlock = self.workspace.blocks[(i, rowIndex)]
            if(sBlock.isStable) || (sBlock.numbers.isSubset(of: lineInfo.distributable)) {
                // 已解，或有加入過 distributable 的跳過。
                continue
            }
            var count:Int = 1
            
            for i2 in 0 ..< self.workspace.width {
                if(i == i2) {
                    // 自己那格，跳過。
                    continue
                }
                let tBlock = self.workspace.blocks[(i2, rowIndex)]
                if sBlock.isEqual(other: tBlock) {
                    count += 1
                }
            }
            
            if (count == sBlock.numbers.count) {
                // consecutive n-tuple found. 更新 line info。
                self.workspace.rowInfo[rowIndex].addDistributed(nums: sBlock.numbers)
                modified = true
            }
        }
        
        
        return modified
    }
    
    
    // 4. Cross Reduction
    // 將目標格，減去行列的distributable。 之後可再由 p1,p2,p3 繼續處理。
    
    private func lineReduction(col:Int) -> Bool {
        var modified:Bool = false
        let colIndex = col - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.colInfo[colIndex]
        
        for j in 0 ..< self.workspace.height {
            let block = self.workspace.blocks[(colIndex, j)]
            if (block.isStable) || block.numbers.isSubset(of: lineInfo.distributable) {
                continue
            }
            
            // 更新該格的可用選擇。
            modified = true
            self.workspace.blocks[(colIndex, j)].numbers.subtract( lineInfo.distributable )
        }
        
        return modified
    }
    
    private func lineReduction(row:Int) -> Bool {
        var modified:Bool = false
        let rowIndex = row - 1      // 對陣列 0-base 修正。
        
        let lineInfo = self.workspace.rowInfo[rowIndex]
        
        for i in 0 ..< self.workspace.width {
            let block = self.workspace.blocks[(i, rowIndex)]
            if (block.isStable) || block.numbers.isSubset(of: lineInfo.distributable) {
                continue
            }
            
            // 更新該格的可用選擇。
            modified = true
            self.workspace.blocks[(i, rowIndex)].numbers.subtract( lineInfo.distributable )
        }
        
        return modified
    }
}
