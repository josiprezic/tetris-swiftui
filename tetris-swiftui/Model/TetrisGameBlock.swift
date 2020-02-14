//
//  TetrisGameBlock.swift
//  tetris-swiftui
//
//  Created by Korisnik on 14/02/2020.
//  Copyright © 2020 Josip Rezic. All rights reserved.
//

import Foundation

struct TetrisGameBlock {
    var blockType: BlockType
}

enum BlockType: CaseIterable {
    case i, t, o, j, l, s, z
}
