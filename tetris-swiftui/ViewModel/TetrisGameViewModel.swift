//
//  TetrisGameViewModel.swift
//  tetris-swiftui
//
//  Created by Korisnik on 07/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import SwiftUI

class TetrisGameViewModel: ObservableObject {
    
    //
    // MARK: - Properties
    //
    
    @Published var gameBoard: [[TetrisGameSquare]]
    
    let numRows: Int
    let numColumns: Int
    
    //
    // MARK: - Initializers
    //
    
    init(numRows: Int = 23, numColumns: Int = 10) {
        self.numRows = numRows
        self.numColumns = numColumns
        
        let repeatingSquare = TetrisGameSquare(color: .tetrisBlack)
        let rowSquareArray = Array(repeating: repeatingSquare, count: numRows)
        gameBoard = Array(repeating: rowSquareArray, count: numColumns)
    }
    
    //
    // MARK: - Methods
    //
    
    func squareClicked(row: Int, column: Int) {
        debugPrint("Column: \(column), Row: \(row)")
        let currentSquareColor = gameBoard[column][row].color
        gameBoard[column][row].color = currentSquareColor == .tetrisBlack ? .tetrisRed : .tetrisBlack
    }
}

// TODO: JR Move
struct TetrisGameSquare {
    var color: Color
}
