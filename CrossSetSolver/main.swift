//
//  main.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation

print("> CrossSetSolver start...")


let abbrArr:[Int] = [
    54,41,62,24,35,14,
    42,65,51,45,56,23,
    31,45,15,62,42,21,
    45,53,24,53,16,65,
    56,42,23,13,54,25,
    41,63,24,35,51,52
]
//let dim = CssXy(8, 8)
let sz = Int(sqrt(Float(abbrArr.count)))
let dim = CssXy(sz, sz)

let blocks = Reader().buildBlocks(abbrArr: abbrArr)
if let board = Board(w: dim.x, h: dim.y, blocks: blocks) {
    let solver = ProgSolver(input: board)
    solver.solve()
}else{
    print( "Board load fail!" )
}

