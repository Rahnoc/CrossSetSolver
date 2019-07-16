//
//  GuessingController.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/15.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation



/// 猜測模擬解題工具
/// * (目前版本尚未 prune) 因為目標為抓所有可能解， stack 會開很多層，小心使用。
public class GuessingController {
    // 時間軸標記, for timeline stamp marking
    public var layer:Int
    /// 上一次的猜測點指標
    public var lastPosition:BlockPointer?
    /// 棋盤快照
    public var snapshot:Board
    
    
    /// 首次使用
    public init(board:Board, layer:Int) {
        self.snapshot = Board(copyFrom: board)
        self.layer = layer
        self.lastPosition = nil
    }
    
    /// 接續上次進度
    public init(board:Board, layer:Int, lastPtr:BlockPointer) {
        self.snapshot = Board(copyFrom: board)
        self.layer = layer
        self.lastPosition = lastPtr
    }
    
    // ---------------
    
    // 執行:
    // 移動指標到下一個猜測點，猜下去，更新 block 後，用 solver 下去跑。
    // solver 跑到
    //  1. 解開: 記錄結果，本層移動指標繼續猜
    //     無法移動指標 = 本層可以收工
    //  2. 卡住：快照後，開下一層繼續猜
    
    // 猜測時，挑一個有一個以上數字的格子，每個數字都猜一次即可。
    // 因為那個格子，最後必定會選用那些數字的其中一個。 所以猜測時，挑一個未解格子遍歷即可，不用每個未解格子都跑 (意義上會重複計算)。
    
    public func run() {
        print( " > Timeline [Layer \(self.layer)] execute..." )
        
        // move pointer
        var ptr:BlockPointer?
        if let uwLastPtr = self.lastPosition {
            // 接續進度
            ptr = self.findNextLegalPtr(board: self.snapshot, ptr: uwLastPtr)
        }else{
            // 第一次
            ptr = self.findFirstLegalPtr(board: self.snapshot)
        }
        
        while let uwPtr = ptr {
            // 建立 solver
            let solver = ProgSolver(input: Board(copyFrom: self.snapshot))
            
            if let gNum = self.getLegalNum(board: solver.workspace, ptr: uwPtr) {
                // 套用猜測
                solver.updateBlock(col: uwPtr.col, row: uwPtr.row, num: gNum)
                
                let success = solver.solve()
                if success {
                    // 紀錄結果
                    answerSet.insert( solver.workspace.description )
                    
                }else{
                    if( !solver.workspace.isContradiction() ) {
                        // Halt: 無法繼續解下去
                        // 用目前solver卡住的盤面，開新時間線
                        let nextTimeline = GuessingController(board: solver.workspace, layer: self.layer + 1)
                        nextTimeline.run()
                        
                    }else{
                        // 矛盾發生，放棄當前指標位置的工作。
                    }
                }
                
                // 移動本層指標，每個可用數字都猜一次。
                ptr = self.findNextLegalNumberPtr(board: self.snapshot, ptr: uwPtr)
                
            }else{
                break
            }
        }
        
    }
    
    // -----------------
    // pointer move
    // -----------------
    
    func findFirstLegalPtr(board:Board) -> BlockPointer? {
        var ptr:BlockPointer? = BlockPointer(c: 1, r: 1, snIdx: 0)
        
        repeat {
            if let _ = self.getLegalNum(board: board, ptr: ptr!) {
                // 有 block.num 可取得。
                return ptr
            }
            
            ptr = self.movePointer(board: board, ptr: ptr!)
            
        }while( ptr != nil )
        
        return nil
    }
    
    /// (跨格子的移動) 先在格A.numbers 移動，數字跑完後，跳到下一個未解的格子B.number 繼續。
    /// 沒有下一個未解格子可以跑時，回傳 nil。
    func findNextLegalPtr(board:Board, ptr:BlockPointer) -> BlockPointer? {
        var nextPtr:BlockPointer? = self.movePointer(board: board, ptr: ptr)
        
        while let uwNextPtr = nextPtr {
            if let _ = self.getLegalNum(board: board, ptr: uwNextPtr) {
                return uwNextPtr
            }
            
            nextPtr = self.movePointer(board: board, ptr: uwNextPtr)
        }
        
        return nil
    }
    
    /// 只在目標格的 numbers 內移動。 當 numbers 都跑過時，回傳 nil。
    func findNextLegalNumberPtr(board:Board, ptr:BlockPointer) -> BlockPointer? {
        let nextNumPtr = BlockPointer(c: ptr.col, r: ptr.row, snIdx: ptr.sortedNumIndex + 1)
        if let _ = self.getPtPair(board: board, ptr: nextNumPtr) {
            // 移動到同一格子 的下一個 number.
            return nextNumPtr
        }
        
        return nil
    }
    
    // ------------------
    
    /// 移動 blockPointer 至目前 block 的下一個 可用 number。 若已經是本 block 的最後一個 number，移動至下一個 block 的第一個 (sorted) 可用 number。
    /// 若移出最後一個 block，回傳 nil。
    private func movePointer(board:Board, ptr:BlockPointer) -> BlockPointer? {
        let colIdx = ptr.col - 1
        let rowIdx = ptr.row - 1
        
        
        let nextNumPtr = BlockPointer(c: ptr.col, r: ptr.row, snIdx: ptr.sortedNumIndex + 1)
        if let _ = self.getPtPair(board: board, ptr: nextNumPtr) {
            // 移動到同一格子 的下一個 number.
            return nextNumPtr
            
        }else{
            // 換下一格
            let nextXy:(x:Int, y:Int)
            if (colIdx + 1) < board.width {
                nextXy = (colIdx + 1, rowIdx)
                
            }else{
                if (rowIdx + 1) < board.height {
                    nextXy = (0, rowIdx + 1)
                }else{
                    // Ptr have just leave the last block.
                    return nil
                }
            }
            
            // 移動到下一格子的第一個 number.
            return BlockPointer(c: nextXy.x + 1, r: nextXy.y + 1, snIdx: 0)
        }
    }
    
    
    /// 取得 未解 block 的 某個可用number。 (由 blockPointer 決定)
    /// 若 ptr 出界，或 block 已解， 則回傳 nil。
    func getLegalNum(board:Board, ptr:BlockPointer) -> Int? {
        guard let ptPair = self.getPtPair(board: board, ptr: ptr) else {
            // block pointer is illegal.
            return nil
        }
        
        if ptPair.block.isStable {
            // The block is determined.
            return nil
        }
        
        return ptPair.num
    }
    
    /// 取得 blockPointer 所指 block， 與所指向的 block.number 內的 number。
    /// 若 BlockPointer 內指向 block.number 的 sortedNumIndex 出界，回傳 nil。
    private func getPtPair(board:Board, ptr:BlockPointer) -> (block:Block, num:Int)? {
        let colIdx = ptr.col - 1
        let rowIdx = ptr.row - 1
        let block = board.blocks[(colIdx, rowIdx)]
        
        guard (ptr.sortedNumIndex >= 0) && (ptr.sortedNumIndex < block.numbers.count) else {
            // oob
            return nil
        }
        
        return (block, block.numbers.sorted()[ptr.sortedNumIndex])
    }
}


public struct BlockPointer {
    var col:Int
    var row:Int
    var sortedNumIndex:Int
    
    public init(c:Int, r:Int, snIdx:Int) {
        self.col = c
        self.row = r
        self.sortedNumIndex = snIdx
    }
    
    // ------------------
}
