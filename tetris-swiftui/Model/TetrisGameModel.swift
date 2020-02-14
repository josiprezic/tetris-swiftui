
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
    
    private var timer: Timer?
    private var speed: Double
    
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
        // tetromino = Tetromino(origin: BlockLocation(row: 22, column: 4), blockType: .i)
        speed = 0.1
        resumeGame()
    }
    
    //
    // MARK: - Public methods
    //
    
    func blockClicked(row: Int, column: Int) {
        debugPrint("Column: \(column), Row: \(row)")
        if gameBoard[column][row] == nil {
            gameBoard[column][row] = TetrisGameBlock(blockType: BlockType.allCases.randomElement()!)
        }
    }
    
    //
    // MARK: - Private methods
    //
    
    private func resumeGame() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true, block: runEngine)
    }
    
    private func pauseGame() {
        timer?.invalidate()
    }
    
    private func runEngine(timer: Timer) {
        // Spawn a new block if we need to
        guard let currentTetromino = tetromino else {
            debugPrint("Spawning new tetromino")
            tetromino = Tetromino.createNewTetromino(numRows: numRows, numColumns: numColumns)
            if !isValidTetromino(testTetromino: tetromino!) {
                debugPrint("Game is over")
                pauseGame()
            }
            return
        }
        
        // See about moving block down
        let newTetromino = currentTetromino.moveBy(row: -1, column: 0)
        if isValidTetromino(testTetromino: newTetromino) {
            print("Moving tetromino down")
            tetromino = newTetromino
            return
        }
        
        // See if we need to place the block
        print("Placing tetromino")
        placeTetromino()
    }
    
    private func isValidTetromino(testTetromino: Tetromino) -> Bool {
        for block in testTetromino.blocks {
            let row = testTetromino.origin.row + block.row
            if row < 0 || row >= numRows { return false }
            
            let column = testTetromino.origin.column + block.column
            if column < 0 || column >= numColumns { return false }
            
            if gameBoard[column][row] != nil { return false }
        }
        return true
    }
    
    private func placeTetromino() {
        guard let currentTetromino = tetromino else {
            return
        }
        
        for block in currentTetromino.blocks {
            let row = currentTetromino.origin.row + block.row
            if row < 0 || row >= numRows { continue }
            
            let column = currentTetromino.origin.column + block.column
            if column < 0 || column >= numColumns { continue }
            
            gameBoard[column][row] = TetrisGameBlock(blockType: currentTetromino.blockType)
        }
        
        tetromino = nil
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
    
    //
    // MARK: - Properties
    //
    
    var origin: BlockLocation
    var blockType: BlockType
    
    var blocks: [BlockLocation] {
        return Tetromino.getBlocks(blockType: blockType)
    }
    
    //
    // MARK: - Public methods
    //
    
    func moveBy(row: Int, column: Int) -> Tetromino {
        let newOrigin = BlockLocation(row: origin.row + row, column: origin.column + column)
        return Tetromino(origin: newOrigin, blockType: blockType)
    }
    
    static func createNewTetromino(numRows: Int, numColumns: Int) -> Tetromino {
        let blockType = BlockType.allCases.randomElement()!
        
        var maxRow = 0
        for block in getBlocks(blockType: blockType) {
            maxRow = max(maxRow, block.row)
        }
        
        let origin = BlockLocation(row: numRows - 1 - maxRow, column: (numColumns - 1) / 2)
        return Tetromino(origin: origin, blockType: blockType)
    }
    
    //
    // MARK: - Private methods
    //
    
    private static func getBlocks(blockType: BlockType) -> [BlockLocation] {
        switch blockType {
        case .i:
            return [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 0, column: 2)]
        case .o:
            return [BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1), BlockLocation(row: 1, column: 0)]
        case .t:
            return [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 0)]
        case .j:
            return [BlockLocation(row: 1, column: -1), BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1)]
        case .l:
            return [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: 1), BlockLocation(row: 1, column: 1)]
        case .s:
            return [BlockLocation(row: 0, column: -1), BlockLocation(row: 0, column: 0), BlockLocation(row: 1, column: 0), BlockLocation(row: 1, column: 1)]
        case .z:
            return [BlockLocation(row: -1, column: 0), BlockLocation(row: 0, column: 0), BlockLocation(row: 0, column: -1), BlockLocation(row: -1, column: 1)]
        }
    }
}

// TODO: JR move
struct BlockLocation {
    var row: Int
    var column: Int
}
