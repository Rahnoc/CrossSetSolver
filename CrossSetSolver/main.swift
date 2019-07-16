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
    135,156,251,124,3512,645,
    352,612,613,563,1246,246,
    126,612,524,463,452,563,
    341,2345,146,2451,1246,512,
    4613,461,634,125,352,136,
    564,352,356,614,236,145
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
