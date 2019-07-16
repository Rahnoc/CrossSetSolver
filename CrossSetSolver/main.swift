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
    351,613,342,512,625,135,
    423,342,125,623,563,341,
    624,451,534,561,635,136,
    461,345,634,523,251,456,
    356,145,451,534,145,251,
    135,462,236,524,312,514
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
