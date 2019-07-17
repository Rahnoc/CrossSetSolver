//
//  main.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation

print("> CrossSetSolver start...")


// Global 的解答容器。
var answerSet:Set<String> = []


let abbrArr:[Int] = [
    2478,3468,1246,6934,2391,7823,6795,4568,9457,
    2789,9278,5782,4613,9137,2351,5834,6935,4781,
    9356,3567,3489,1367,5684,6792,9347,5691,8967,
    9246,4789,5784,5124,7346,2681,8937,6895,2467,
    4723,9238,5134,7926,9568,4681,7136,9237,8915,
    3672,7836,6713,4612,6125,8924,9357,5134,1689,
    1348,1256,2569,7913,9357,2357,6345,5734,3892,
    7946,5892,8457,8135,5693,9235,1357,9123,9248,
    1237,8136,5623,3478,1457,7946,3912,8946,3456
]
//let dim = CssXy(8, 8)
let sz = Int(sqrt(Float(abbrArr.count)))
let dim = CssXy(sz, sz)

let blocks = Reader().buildBlocks(abbrArr: abbrArr)
if let board = Board(w: dim.x, h: dim.y, blocks: blocks) {
    print( "--------------------" )
    print( "Puzzle:" )
    print( board )
    
    let solver = ProgSolver(input: board)
    
    let success = solver.solve()
    if success {
        // 得解，紀錄結果。
        answerSet.insert( solver.workspace.description )
        
    }else{
        if( !solver.workspace.isContradiction() ) {
            // Halt，卡住了
            // 用目前solver卡住的盤面，首次開新時間線
            let nextTimeline = GuessingController(board: solver.workspace, layer: 0)
            nextTimeline.run()
            
        }else{
            // 解到出現矛盾，放棄。
        }
    }
    
}else{
    print( "Board load fail!" )
}

print( "\n--------------[Result]--------------" )
print( "Legal answer (#=\(answerSet.count)):" )
for ans in answerSet {
    print( ans )
}
