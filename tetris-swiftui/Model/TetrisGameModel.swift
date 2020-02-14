
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
    
    let numRows: Int
    let numColumns: Int
    
    @Published var gameBoard: [[TetrisGameBlock?]]
    @Published var tetromino: Tetromino?
    
    private var timer: Timer?
    private var speed: Double
    
    var shadow: Tetromino? {
        guard var lastShadow = tetromino else { return nil }
        var testShadow = lastShadow
        while isValidTetromino(testTetromino: testShadow) {
            lastShadow = testShadow
            testShadow = lastShadow.moveBy(row: -1, column: 0)
        }
        
        return lastShadow
    }
    
    //
    // MARK: - Initializers
    //
    
    init(numRows: Int = 23, numColumns: Int = 10, speed: Double = 0.5) {
        self.numRows = numRows
        self.numColumns = numColumns
        self.speed = speed
        
        let block: TetrisGameBlock? = nil
        let rowSquareArray = Array(repeating: block, count: numRows)
        gameBoard = Array(repeating: rowSquareArray, count: numColumns)
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
    
    func moveTetrominoDown() -> Bool {
        return moveTetromino(rowOffset: -1, columnOffset: 0)
    }
    
    func moveTetrominoLeft() -> Bool {
        return moveTetromino(rowOffset: 0, columnOffset: -1)
    }
    
    func moveTetrominoRight() -> Bool {
        return moveTetromino(rowOffset: 0, columnOffset: 1)
    }
    
    func dropTetromino() {
        while moveTetrominoDown() { }
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
        // Check if we need to clear a line
        if clearLines() {
            print("Line cleared")
            return
        }
        
        // Spawn a new block if we need to
        guard tetromino != nil else {
            debugPrint("Spawning new tetromino")
            tetromino = Tetromino.createNewTetromino(numRows: numRows, numColumns: numColumns)
            if !isValidTetromino(testTetromino: tetromino!) {
                debugPrint("Game is over")
                pauseGame()
            }
            return
        }
        
        // See about moving block down
        if moveTetrominoDown() {
            print("Moving tetromino down")
            return
        }
        
        // See if we need to place the block
        print("Placing tetromino")
        placeTetromino()
    }
    
    private func moveTetromino(rowOffset: Int, columnOffset: Int) -> Bool {
        guard let currentTetromino = tetromino else { return false }
        
        let newTetromino = currentTetromino.moveBy(row: rowOffset, column: columnOffset)
        if isValidTetromino(testTetromino: newTetromino) {
            tetromino = newTetromino
            return true
        }
        return false
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
    
    private func clearLines() -> Bool {
        let block: TetrisGameBlock? = nil
        let rowSquareArray = Array(repeating: block, count: numRows)
        var newBoard = Array(repeating: rowSquareArray, count: numColumns)
        
        var boardUpdated = false
        var nextRowToCopy = 0
        
        for row in 0...numRows - 1 {
            var clearLine = true
            for column in 0...numColumns - 1 {
                clearLine = clearLine && gameBoard[column][row] != nil
            }
            
            if !clearLine {
                for column in 0...numColumns - 1 {
                    newBoard[column][nextRowToCopy] = gameBoard[column][row]
                }
                nextRowToCopy += 1
            }
            boardUpdated = boardUpdated || clearLine
            
        }
        
        if boardUpdated {
            gameBoard = newBoard
        }
        return boardUpdated
    }
}
