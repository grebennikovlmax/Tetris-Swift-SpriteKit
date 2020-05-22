//
//  Block.swift
//  TetrisSwift
//
//  Created by Максим Гребенников on 22.05.2020.
//  Copyright © 2020 Maksim Grebennikov. All rights reserved.
//

import SpriteKit

class Block: Equatable {
   
  var column: Int
  var row: Int
  var sprite: SKShapeNode?
  
  init(row: Int, column: Int) {
    self.column = column
    self.row = row
  }
  
  static func == (lhs: Block, rhs: Block) -> Bool {
     return lhs.column == rhs.column && rhs.row == lhs.row
   }
   
  
}
