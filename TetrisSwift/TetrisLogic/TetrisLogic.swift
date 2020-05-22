//
//  TetrisLogic.swift
//  TetrisSwift
//
//  Created by Максим Гребенников on 22.05.2020.
//  Copyright © 2020 Maksim Grebennikov. All rights reserved.
//

import SpriteKit

protocol GameDelegate: AnyObject {
  var lastTick: Date? { get set }
  func drawShape(block: Block, color: UIColor)
  func move(block: Block, duration: Double)
  func setPoint(new point: Int)
  func gameOver()
}

class TetrisLogic {
  
  private let numberOfRows: Int
  private let numberOfColumns: Int
  private var shape: Shape?
  private var points = 0
  private var mainArray: [[Block?]] = []
  weak var delegate: GameDelegate?
  
  init(rows: Int, columns: Int) {
    self.numberOfRows = rows
    self.numberOfColumns = columns
  }
  
  func startGame() {
    let temp = Array<Block?>(repeating: nil, count: numberOfColumns)
    mainArray = Array(repeating: temp, count: numberOfRows)
    
    createShape()
    delegate?.lastTick = Date(timeIntervalSinceNow: 0)
  }
  
  private func createShape() {
    shape = Shape(maxRow: numberOfRows, maxColumn: numberOfColumns)
    guard !isCollision() else {
      delegate?.lastTick = nil
      shape = nil
      delegate?.gameOver()
      return
    }
    for block in shape!.blocks {
      delegate?.drawShape(block: block, color: shape!.color)
    }
  }
    
  func didTick() {
    moveShape(byRow: 1, byColumn: 0, with: 0)
  }
  
  private func moveShape(byRow row: Int, byColumn column: Int, with duration: Double) {
    guard let shape = shape else { return }
    shape.shift(row: row, column: column)
    for block in shape.blocks {
      delegate?.move(block: block, duration: duration)
    }
    checkCollision()
  }
  
  private func checkCollision() {
    if isCollision() {
      for block in shape!.blocks {
        mainArray[block.row][block.column] = block
      }
      checkLines()
      shape = nil
      createShape()
    }
  }
  
  private func isCollision() -> Bool {
    for block in shape!.blocks {
      guard block.row != numberOfRows - 1 else { return true }
      guard mainArray[block.row + 1][block.column] == nil else { return true }
    }
    return false
  }
  
  private func checkLines() {
    
    var indRowToRemove: [Int] = []
    for (i,row) in mainArray.enumerated() {
      if row.filter({ $0 == nil }).count == 0 {
        indRowToRemove.append(i)
      }
    }
    
    guard !indRowToRemove.isEmpty else { return }
    
    self.points += indRowToRemove.count * numberOfColumns
    delegate?.setPoint(new: points)
    
    var maxInd = 0
    for i in indRowToRemove {
      if i > maxInd {
        maxInd = i
      }
      for j in 0..<numberOfColumns {
        mainArray[i][j]?.sprite?.removeFromParent()
        mainArray[i][j] = nil
      }
    }
    
    
    
    for i in stride(from: maxInd - 1, through: 0, by: -1) {
      for j in 0..<numberOfColumns {
        guard let block = mainArray[i][j] else { continue }
        let newRow = i + indRowToRemove.count
      
        block.row = newRow
        mainArray[i][j] = nil
        mainArray[newRow][j] = block
      }
    }
    
    for i in 0...maxInd {
      mainArray[i].forEach( { block in
        guard let block = block else { return }
        delegate?.move(block: block,duration: 0.1)
      })
    }
  }
  
  
  @objc func didTap(sender: UITapGestureRecognizer) {
    guard shape != nil else { return }
    shape?.rotation()
    moveShape(byRow: 0, byColumn: 0, with: 0)
  }
  
  @objc func moveToSide(sender: UISwipeGestureRecognizer) {
    guard shape != nil else { return }
    let moveTo = sender.direction.rawValue == 2 ? -1 : 1
    for block in shape!.blocks {
      if block.column + moveTo < 0 || block.column + moveTo > numberOfColumns - 1 {
        return
      }
      if mainArray[block.row][block.column+moveTo] != nil {
        return
      }
    }
    moveShape(byRow: 0, byColumn: moveTo, with: 0)
  }
  
  @objc func dropShape(sender: UISwipeGestureRecognizer) {
    guard let oldShape = shape else { return }
    while oldShape === shape {
      moveShape(byRow: 1, byColumn: 0, with: 0.1)
    }
  }
  
}
