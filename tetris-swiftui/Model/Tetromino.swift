//
//  Tetromino.swift
//  tetris-swiftui
//
//  Created by Korisnik on 14/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import Foundation

struct Tetromino {
    
    //
    // MARK: - Properties
    //
    
    var origin: BlockLocation
    var blockType: BlockType
    var blocks: [BlockLocation] { return Tetromino.getBlocks(blockType: blockType) }
    
    //
    // MARK: - Static methods
    //
    
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
    // MARK: - Public methods
    //
    
    func moveBy(row: Int, column: Int) -> Tetromino {
        let newOrigin = BlockLocation(row: origin.row + row, column: origin.column + column)
        return Tetromino(origin: newOrigin, blockType: blockType)
    }
    
    func rotate() -> Tetromino {
        // TODO: JR
        debugPrint("ROTATE TETROMINO CALLED")
        return self
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
