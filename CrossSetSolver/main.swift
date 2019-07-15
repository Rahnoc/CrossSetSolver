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
    412,4,6,134,614,52,
    352,6,12,46,2,523,
    62,453,451,32,145,16,
    1,5,614,625,43,2,
    463,2,34,21,5,6,
    413,12,235,513,612,341
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

