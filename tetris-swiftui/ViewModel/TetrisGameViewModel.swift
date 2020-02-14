//
//  TetrisGameViewModel.swift
//  tetris-swiftui
//
//  Created by Korisnik on 07/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import Combine
import SwiftUI

final class TetrisGameViewModel: ObservableObject {
    
    //
    // MARK: - Properties
    //
    
    @Published var tetrisGameModel = TetrisGameModel()
    
    var numRows: Int {
        tetrisGameModel.numRows
    }
    
    var numColumns: Int {
        tetrisGameModel.numColumns
    }
    
    var gameBoard: [[TetrisGameSquare]] {
        var board = tetrisGameModel.gameBoard.map { $0.map(convertToSquare) }
        
        if let tetromino = tetrisGameModel.tetromino {
            for blockLocation in tetromino.blocks {
                let boardColumn = blockLocation.column + tetromino.origin.column
                let boardRow = blockLocation.row + tetromino.origin.row
                board[boardColumn][boardRow] = TetrisGameSquare(color: getColor(blockType: tetromino.blockType))
            }
        }
        return board
    }
    
    var anyCancellable: AnyCancellable?
    var lastMoveLocation: CGPoint?
    
    //
    // MARK: - Initializers
    //
    
    init() {
        anyCancellable = tetrisGameModel.objectWillChange.sink {
            self.objectWillChange.send()
        }
    }
    
    //
    // MARK: - Public methods
    //
    
    func squareClicked(row: Int, column: Int) {
        tetrisGameModel.blockClicked(row: row, column: column)
    }
    
    func getColor(blockType: BlockType?) -> Color {
        switch blockType {
        case .i: return .tetrisLightBlue
        case .j: return .tetrisDarkBlue
        case .l: return .tetrisOrange
        case .o: return .tetrisYellow
        case .s: return .tetrisGreen
        case .t: return .tetrisPurple
        case .z: return .tetrisRed
        case .none: return .tetrisBlack
        }
    }
    
    func getMoveGesture() -> some Gesture {
        return DragGesture()
        .onChanged(onMoveChanged(value:))
        .onEnded(onMoveEnded(_:))
    }
    
    //
    // MARK: - Private methods
    //
    
    private func convertToSquare(block: TetrisGameBlock?) -> TetrisGameSquare {
        let squareColor = getColor(blockType: block?.blockType)
        return TetrisGameSquare(color: squareColor)
    }
    
    private func onMoveChanged(value: DragGesture.Value) {
        guard let start = lastMoveLocation else {
            lastMoveLocation = value.location
            return
        }
        
        let xDiff = value.location.x - start.x
        
        if xDiff > 10 {
            debugPrint("Moving right")
            let _ = tetrisGameModel.moveTetrominoRight()
            lastMoveLocation = value.location
            return
        }
        
        if xDiff < -10 {
            debugPrint("Moving left")
            let _ = tetrisGameModel.moveTetrominoLeft()
            lastMoveLocation = value.location
            return
        }
        
        let yDiff = value.location.y - start.y
        
        if yDiff > 10 {
            debugPrint("Moving down")
            let _ = tetrisGameModel.moveTetrominoDown()
            lastMoveLocation = value.location
            return
        }
        
        if yDiff < -10 {
            debugPrint("Dropping")
            tetrisGameModel.dropTetromino()
            lastMoveLocation = value.location
            return
        }
    }
    
    private func onMoveEnded(_: DragGesture.Value) {
        lastMoveLocation = nil
    }
}

// TODO: JR Move
struct TetrisGameSquare {
    var color: Color
}
