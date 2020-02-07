//
//  TetrisGameViewModel.swift
//  tetris-swiftui
//
//  Created by Korisnik on 07/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import SwiftUI

class TetrisGameViewModel: ObservableObject {
    
    var numRows: Int
    var numColumns: Int
    @Published var gameBoard: [[TetrisGameSquare]]
    
    init(numRows: Int = 23, numColumns: Int = 10) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        gameBoard = Array(repeating: Array(repeating: TetrisGameSquare(color: .tetrisBlack), count: numRows), count: numColumns)
    }
    
    func squareClicked(row: Int, column: Int) {
        debugPrint("Column: \(column), Row: \(row)")
        if gameBoard[column][row].color == .tetrisBlack {
            gameBoard[column][row].color = .tetrisRed
        } else {
            gameBoard[column][row].color = .tetrisBlack
        }
    }
}


struct TetrisGameSquare {
    var color: Color
}
