
//
//  TetrisGameModel.swift
//  tetris-swiftui
//
//  Created by Korisnik on 07/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import Foundation
import SwiftUI

class TetrisGameModel: ObservableObject {
    
    //
    // MARK: - Properties
    //
    
    @Published var gameBoard: [[TetrisGameBlock?]]
    @Published var tetromino: Tetromino?
    
    let numRows: Int
    let numColumns: Int
    
    //
    // MARK: - Initializers
    //
    
    init(numRows: Int = 23, numColumns: Int = 10) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        let block: TetrisGameBlock? = nil
        let rowSquareArray = Array(repeating: block, count: numRows)
        gameBoard = Array(repeating: rowSquareArray, count: numColumns)
        tetromino = Tetromino(origin: BlockLocation(row: 22, column: 4), blockType: .i)
    }
    
    //
    // MARK: - Methods
    //
    
    func blockClicked(row: Int, column: Int) {
        debugPrint("Column: \(column), Row: \(row)")
        if gameBoard[column][row] == nil {
            gameBoard[column][row] = TetrisGameBlock(blockType: BlockType.allCases.randomElement()!)
        }
    }
}

// TODO: JR move
struct TetrisGameBlock {
    var blockType: BlockType
}

// TODO: JR move
enum BlockType: CaseIterable {
    case i, t, o, j, l, s, z
}

// TODO: JR move
struct Tetromino {
    var origin: BlockLocation
    var blockType: BlockType
    var blocks: [BlockLocation] {
        [
            BlockLocation(row: 0, column: -1),
            BlockLocation(row: 0, column: 0),
            BlockLocation(row: 0, column: 1),
            BlockLocation(row: 0, column: 2)
        ]
    }
}

// TODO: JR move
struct BlockLocation {
    var row: Int
    var column: Int
}
