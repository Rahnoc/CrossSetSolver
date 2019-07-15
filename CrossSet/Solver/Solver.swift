//
//  Solver.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation


public class Solver {
    var workSpace:Board
    var colDesc:[LineInfo]
    var rowDesc:[LineInfo]
    
    
    public init(input:Board) {
        self.workSpace = Board(copyFrom: input)
        
        self.colDesc = Array<LineInfo>()
        for _ in 0 ..< input.w {
            self.colDesc.append( LineInfo(sz: input.h) )
        }
        self.rowDesc = Array<LineInfo>()
        for _ in 0 ..< input.h {
            self.rowDesc.append( LineInfo(sz: input.w) )
        }
    }
    
    
    // -------------------
    
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
    
    // --------------------
    
    func solve() {
        print(" > Puzzle >")
        print( self.workSpace )
        repeat{
            self.phase1()
//            print(" > p1 >")
//            print( self.workSpace )
            self.phase2()
//            print(" > p2 >")
//            print( self.workSpace )
            self.phase3()
//            print(" > p3 >")
//            print( self.workSpace )
            self.phase4()
//            print(" > p4 >")
//            print( self.workSpace )
        }while(self.isAllStable() == false)
        
        print( " -----[answer]----- " )
        print( self.workSpace )
    }
    
    
    /// 是否全 block 均為 stable？
    private func isAllStable() -> Bool {
        for b in self.workSpace.blocks {
            if(b.isStable == false) {
                return false
            }
        }
        
        return true
    }
    
    /// 將只有一個選擇的格子標記
    private func phase1() {
        var modified:Bool = false
        
        repeat{
            modified = false
            
            for c in 1 ... self.workSpace.w {
                modified = modified || self.uniqueCheckCol(col: c)
            }
            
            for r in 1 ... self.workSpace.h {
                modified = modified || self.uniqueCheckRow(row: r)
            }
        }while(modified)
    }
    
    private func phase2() {
        var modified:Bool = false
        
        repeat{
            modified = false
            
            for c in 1 ... self.workSpace.w {
                modified = modified || self.appearOnceCheckCol(col: c)
            }
            
            for r in 1 ... self.workSpace.h {
                modified = modified || self.appearOnceCheckRow(row: r)
            }
        }while(modified)
    }
    
    private func phase3() {
        var modified:Bool = false
        
        repeat{
            modified = false
            
            for c in 1 ... self.workSpace.w {
                modified = modified || self.nTupleCheck(col: c)
            }
            
            for r in 1 ... self.workSpace.h {
                modified = modified || self.nTupleCheck(row: r)
            }
        }while(modified)
    }
    
    private func phase4() {
        for c in 1 ... self.workSpace.w {
            _ = self.lineReduction(col: c)
        }
        
        for r in 1 ... self.workSpace.h {
            _ = self.lineReduction(row: r)
        }
    }
    
    // -------------------
    // 計算結果更新用
    // -------------------
    
    /// 更新目標格與其所在行、列。
    private func updateBlock(idx:Int, ns:[Int]) {
        self.workSpace.blocks[idx].numbers = ns
        self.workSpace.blocks[idx].isStable = true
        
        let row = (idx / self.workSpace.w) + 1
        let col = (idx % self.workSpace.w) + 1
        
        let block = self.workSpace.blocks[idx]
        
        let cuSet = Set(self.colDesc[col - 1].uncertain)
        let cdSet = Set(self.colDesc[col - 1].distributable)
        let cfSet = Set(self.colDesc[col - 1].found)
        let cntSet = Set(block.numbers)
        self.colDesc[col - 1].uncertain = Array( cuSet.subtracting(cntSet) ).sorted()
        self.colDesc[col - 1].distributable = Array( cdSet.union(cntSet) ).sorted()
        self.colDesc[col - 1].found = Array( cfSet.union(cntSet) ).sorted()
        
        let ruSet = Set(self.rowDesc[row - 1].uncertain)
        let rdSet = Set(self.rowDesc[row - 1].distributable)
        let rfSet = Set(self.rowDesc[row - 1].found)
        let rntSet = Set(block.numbers)
        self.rowDesc[row - 1].uncertain = Array( ruSet.subtracting(rntSet) ).sorted()
        self.rowDesc[row - 1].distributable = Array( rdSet.union(rntSet) ).sorted()
        self.rowDesc[row - 1].found = Array( rfSet.union(rntSet) ).sorted()
    }
    
    /// 只更新目標格與其所在列。
    private func updateBlockRow(idx:Int, ns:[Int]) {
        self.workSpace.blocks[idx].numbers = ns
        
        let row = (idx / self.workSpace.w) + 1
        
        let block = self.workSpace.blocks[idx]
        
        let ruSet = Set(self.rowDesc[row - 1].uncertain)
        let rdSet = Set(self.rowDesc[row - 1].distributable)
        let rntSet = Set(block.numbers)
        self.rowDesc[row - 1].uncertain = Array( ruSet.subtracting(rntSet) ).sorted()
        self.rowDesc[row - 1].distributable = Array( rdSet.union(rntSet) ).sorted()
    }
    
    /// 只更新目標格與其所在行。
    private func updateBlockCol(idx:Int, ns:[Int]) {
        self.workSpace.blocks[idx].numbers = ns
        
        let col = (idx % self.workSpace.w) + 1
        
        let block = self.workSpace.blocks[idx]
        
        let cuSet = Set(self.colDesc[col - 1].uncertain)
        let cdSet = Set(self.colDesc[col - 1].distributable)
        let cntSet = Set(block.numbers)
        self.colDesc[col - 1].uncertain = Array( cuSet.subtracting(cntSet) ).sorted()
        self.colDesc[col - 1].distributable = Array( cdSet.union(cntSet) ).sorted()
    }
    
    // --------------------
    
    // 1. Unique Check
    // 找出只有一個解的格子 = 可確定該格值。
    
    private func uniqueCheckCol(col:Int) -> Bool {
        var modified:Bool = false
        
        let idxs = self.workSpace.getColIndex(c: col)
        for i in idxs {
            let block = self.workSpace.blocks[i]
            if( block.isStable ) { continue }
            
            if (block.numbers.count == 1) {
                self.updateBlock(idx: i, ns: block.numbers)
                modified = true
            }
        }
        
        return modified
    }
    
    private func uniqueCheckRow(row:Int) -> Bool {
        var modified:Bool = false
        
        let idxs = self.workSpace.getRowIndex(r: row)
        for i in idxs {
            let block = self.workSpace.blocks[i]
            if( block.isStable ) { continue }
            
            if (block.numbers.count == 1) {
                self.updateBlock(idx: i, ns: block.numbers)
                modified = true
            }
        }
        
        return modified
    }
    
    // 2. Appear Once check
    // 每一行列，均由 1,2 ... n 分配。 這裡找出於某行/列只出現一次的數字，此數字必定填入該格。
    
    private func appearOnceCheckCol(col:Int) -> Bool {
        var modified:Bool = false
        let idxs = self.workSpace.getColIndex(c: col)
        var founds:[(i:Int, n:Int)] = []
        
        let LineInfo = self.colDesc[col - 1]
        for number in LineInfo.uncertain {
            var count:Int = 0
            var tarIdx:Int?
            
            for i in idxs {
                let block = self.workSpace.blocks[i]
                if (block.isStable == false) && (block.numbers.contains( number )) {
                    tarIdx = i
                    count += 1
                }
            }
            
            if (count == 1) {
                founds.append( (tarIdx!, number) )
            }
        }
        
        //
        for f in founds {
            modified = true
            self.updateBlock(idx: f.i, ns: [f.n])
        }
        
        return modified
    }
    
    private func appearOnceCheckRow(row:Int) -> Bool {
        var modified:Bool = false
        let idxs = self.workSpace.getRowIndex(r: row)
        var founds:[(i:Int, n:Int)] = []
        
        
        let LineInfo = self.rowDesc[row - 1]
        for number in LineInfo.uncertain {
            var count:Int = 0
            var tarIdx:Int?
            
            for i in idxs {
                let block = self.workSpace.blocks[i]
                if (block.isStable == false) && (block.numbers.contains( number )) {
                    tarIdx = i
                    count += 1
                }
            }
            
            if (count == 1) {
                founds.append( (tarIdx!, number) )
            }
        }
        
        //
        for f in founds {
            modified = true
            self.updateBlock(idx: f.i, ns: [f.n])
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
        let idxs = self.workSpace.getColIndex(c: col)
        
        for i in idxs {
            let sBlock = self.workSpace.blocks[i]
            if sBlock.isStable {
                continue
            }
            var count:Int = 1
            
            for j in idxs {
                if(j == i) {
                    continue
                }
                
                let tBlock = self.workSpace.blocks[j]
                let dSet = Set(self.colDesc[col - 1].distributable)
                let sSet = Set(sBlock.numbers)
                if(sSet.isSubset(of: dSet)) {
                    continue
                }
                if sBlock.isEqual(other: tBlock) {
                    count += 1
                }
            }
            
            if (count == sBlock.numbers.count) {
                modified = true
                self.updateBlockCol(idx: i, ns: sBlock.numbers)
            }
        }
        
        return modified
    }
    
    
    private func nTupleCheck(row:Int) -> Bool {
        var modified:Bool = false
        let idxs = self.workSpace.getRowIndex(r: row)
        
        for i in idxs {
            let sBlock = self.workSpace.blocks[i]
            if sBlock.isStable {
                continue
            }
            var count:Int = 1
            
            for j in idxs {
                if(j == i) {
                    continue
                }
                
                let tBlock = self.workSpace.blocks[j]
                let rSet = Set(self.rowDesc[row - 1].distributable)
                let sSet = Set(sBlock.numbers)
                if(sSet.isSubset(of: rSet)) {
                    continue
                }
                if sBlock.isEqual(other: tBlock) {
                    count += 1
                }
            }
            
            if (count == sBlock.numbers.count) {
                modified = true
                self.updateBlockRow(idx: i, ns: sBlock.numbers)
            }
        }
        
        return modified
    }
    
    
    // 4. Cross Reduction
    // 將目標格，減去行列的distributable。 之後可再由 p1,p2,p3 繼續處理。
    
    private func lineReduction(col:Int) -> Bool {
        var modified:Bool = false
        let idxs = self.workSpace.getColIndex(c: col)
        
        for i in idxs {
            // 移除該格於同行中已確認的部分。
            let sBlock = self.workSpace.blocks[i]
            if( sBlock.isStable ) { continue }
            let sSet = Set(sBlock.numbers)
            let uSet = Set( self.colDesc[col - 1].distributable )
            let rSet = sSet.subtracting(uSet)
            
            if (rSet.isEmpty == false) {
                modified = true
                self.workSpace.blocks[i].numbers = Array(rSet).sorted()
            }
        }
        
        return modified
    }
    
    private func lineReduction(row:Int) -> Bool {
        var modified:Bool = false
        let idxs = self.workSpace.getRowIndex(r: row)
        
        for i in idxs {
            // 移除該格於同列中已確認的部分。
            let sBlock = self.workSpace.blocks[i]
            if( sBlock.isStable ) { continue }
            let sSet = Set(sBlock.numbers)
            let uSet = Set( self.rowDesc[row - 1].distributable )
            let rSet = sSet.subtracting(uSet)
            
            if (rSet.isEmpty == false) {
                modified = true
                self.workSpace.blocks[i].numbers = Array(rSet).sorted()
            }
        }
        
        return modified
    }
    
    
    // --------------
    
}
