//
//  main.swift
//  CrossSetSolver
//
//  Created by Rahnoc on 2019/7/14.
//  Copyright © 2019 CupsailorStudio. All rights reserved.
//

import Foundation

print("> CrossSetSolver start...")


let reader = Reader()

let abbrArr:[Int] = [
    48,38,71,45,83,13,62,63,
    38,85,64,82,12,57,61,83,
    56,65,42,86,37,41,13,83,
    57,26,53,42,86,68,83,12,
    72,16,63,75,54,62,84,41,
    28,45,21,36,12,53,74,25,
    12,28,65,38,54,52,25,57,
    16,17,83,13,63,51,42,26
]

let blocks = reader.buildBlocks(abbrArr: abbrArr)
// 預期為正方形棋盤。 若長寬不同就需要自行輸入。
let sz = Int(sqrt(Float(abbrArr.count)))
let board = Board(w: sz, h: sz, blocks: blocks)

let solver = Solver(input: board)
solver.solve()
