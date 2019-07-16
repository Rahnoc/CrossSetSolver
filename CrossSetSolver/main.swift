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
    123456789,612,827,349,493,125,148,123,149,
    371,123456789,372,789,356,925,795,478,947,
    672,259,123456789,824,259,352,479,938,256,
    623,948,895,123456789,896,178,926,134,915,
    145,574,967,926,123456789,847,267,561,713,
    683,713,634,251,524,123456789,796,581,574,
    278,391,645,925,591,493,123456789,673,581,
    482,794,692,267,735,917,134,123456789,489,
    524,491,812,493,897,715,238,269,123456789
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
