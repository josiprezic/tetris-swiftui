//
//  TetrisGameView.swift
//  tetris-swiftui
//
//  Created by Korisnik on 07/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import SwiftUI

struct TetrisGameView: View {
    
    //
    // MARK: - Properties
    //
    
    @ObservedObject var tetrisGame = TetrisGameViewModel()
    
    //
    // MARK: - Body view
    //
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            self.drawBoard(boundingRect: geometry.size)
        }
        .gesture(tetrisGame.getMoveGesture())
    }
    
    //
    // MARK: - Methods
    //
    
    private func drawBoard(boundingRect: CGSize) -> some View {
        let columns = tetrisGame.numColumns
        let rows = tetrisGame.numRows
        let blockSize = min(boundingRect.width / CGFloat(columns), boundingRect.height / CGFloat(rows))
        let xOffset = (boundingRect.width - blockSize * CGFloat(columns)) / 2
        let yOffset = (boundingRect.height - blockSize * CGFloat(rows)) / 2
        let gameBoard = self.tetrisGame.gameBoard
        
        return ForEach(0...columns - 1, id: \.self) { column in
            ForEach(0...rows - 1, id: \.self) { row in
                Path { path in
                    let x = xOffset + blockSize * CGFloat(column)
                    let y = boundingRect.height - yOffset - blockSize * CGFloat(row + 1)
                    
                    let rect = CGRect(x: x, y: y, width: blockSize, height: blockSize)
                    path.addRect(rect)
                }
                .fill(gameBoard[column][row].color)
                .onTapGesture {
                    self.tetrisGame.squareClicked(row: row, column: column)
                }
            }
        }
    }
}

struct TetrisGameView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisGameView()
    }
}
