//
//  Shape.swift
//  TetrisSwift
//
//  Created by Максим Гребенников on 22.05.2020.
//  Copyright © 2020 Maksim Grebennikov. All rights reserved.
//

import UIKit

enum Shapes: CaseIterable {
  
  case ishape
  case zshape
  case jshape
  case lshape
  case oshape
  case sshape
  case tshape
  
}

class Shape {
  
  var shape: [(Int,Int)] = []
  private let startRow: Int
  private let startColumn: Int
  private let maxRow: Int
  private let maxColumn: Int
  var color: UIColor = .clear
  var blocks: [Block] = []
  private var isRotating = true
  
  init(maxRow: Int, maxColumn: Int) {
    self.maxRow = maxRow
    self.maxColumn = maxColumn
    self.startRow = 0
    self.startColumn = maxColumn / 2 - 1
    randomShape()
    inititalizeBlock()
  }
  
  func inititalizeBlock() {
    blocks = shape.map { dif -> Block in
      return Block(row: startRow + dif.0, column: startColumn + dif.1)
    }
  }
  
  func shift(row: Int, column: Int) {
    for block in blocks {
      block.row += row
      block.column += column
    }
  }

  
  func rotation() {
    guard isRotating else { return }
    let R = [ [0, -1], [1, 0] ]
    var minR = 0
    var minC = 0
    var pivot: (Int, Int)?
    for (i, block) in blocks.enumerated() {
      guard let piv = pivot else {
        pivot = (block.row, block.column)
        continue
      }
      let vt = [piv.0 - block.row, piv.1 - block.column]
      var vr: [Int] = []
      for j in R {
        vr.append(j[0] * vt[0] + j[1] * vt[1])
      }
      if !(0...maxColumn - 1 ~= piv.0 + vr[0]) {
        let temp = piv.0 + vr[0] < 0 ? -(piv.0 + vr[0]) : maxColumn - 1 - (piv.0 + vr[0])
        if abs(temp) > abs(minR) {
          minR = temp
        }
      }
      
      if !(0...maxRow - 1 ~= piv.1 + vr[1]) {
        let temp = piv.1 + vr[1] < 0 ? -(piv.1 + vr[1]) : maxRow - 1 - (piv.1 + vr[1])
        if abs(temp) > abs(minC) {
          minC = temp
        }
      }
      blocks[i].row = piv.0 + vr[0]
      blocks[i].column = piv.1 + vr[1]
    }
    guard abs(minR) > 0 || abs(minC) > 0 else { return }
    
    for i in 0..<blocks.count {
      blocks[i].row += minR
      blocks[i].column += minC
    }
  
  }
  
  func randomShape() {
    switch Shapes.allCases.randomElement()! {
      
    case .ishape:
    self.shape = [(0,-1),(0,0),(0,1),(0,2)]
    self.color = .cyan
      
    case .jshape:
    self.shape = [(0,0),(0,1),(1,0),(2,0)]
    self.color = .blue
      
    case .lshape:
    self.shape = [(0,0),(0,1),(1,1),(2,1)]
    self.color = .orange
      
    case .oshape:
    self.shape = [(0,0),(0,1),(1,0),(1,1)]
    self.color = .yellow
    self.isRotating = false
      
    case .sshape:
    self.shape = [(0,1),(0,2),(1,0),(1,1)]
    self.color = .green
      
    case .tshape:
    self.shape = [(0,1),(1,0),(1,1),(1,2)]
    self.color = .magenta
      
    case .zshape:
    self.shape = [(0,0),(0,1),(1,1),(1,2)]
    self.color = .red
    }
  }
}
