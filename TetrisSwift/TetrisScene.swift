//
//  TetrisScene.swift
//  TetrisSwift
//
//  Created by Максим Гребенников on 22.05.2020.
//  Copyright © 2020 Maksim Grebennikov. All rights reserved.
//

import SpriteKit

class TetrisScene: SKScene {
  
  private var gameZone: SKSpriteNode!
  private var helloNode: SKShapeNode!
  private var pointsLabel: SKLabelNode!
  private var boxSize: CGFloat!
  private var numberOfRows = 20
  private var numberOfColumns = 10
  private let rightOffset: CGFloat = 10
  private var tickLength: TimeInterval = 600
  var lastTick: Date?
  private var tetrisLogic: TetrisLogic!
  
  override func didMove(to view: SKView) {
    initializeMainBoard(with: view.bounds.size)
    tetrisLogic = TetrisLogic(rows: numberOfRows, columns: numberOfColumns)
    tetrisLogic.delegate = self
    setupGestureRecognizer(to: view)
    createHelloLabel(with: view.bounds.size)
    createPointLabel(with: view.bounds.size)
  }
  
  private func createPointLabel(with size: CGSize) {
    pointsLabel = SKLabelNode(text: "Points\n 0")
    pointsLabel.position = CGPoint(x: size.width - gameZone.frame.width / 2 + boxSize + boxSize, y: size.height -  gameZone.frame.height / 2 + boxSize)
    pointsLabel.numberOfLines = 2
    pointsLabel.fontSize = 20
    pointsLabel.fontName = "Helvetica"
    pointsLabel.fontColor = .black
    self.addChild(pointsLabel)
    
  }
  
  private func createHelloLabel(with size: CGSize) {
    helloNode = SKShapeNode(rectOf: size)
    helloNode.fillColor = .brown
    helloNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    helloNode.alpha = 0.5
    addChild(helloNode)
    
    let helloLabel = SKLabelNode(text: "Tetris on Swift")
    helloLabel.fontSize = 30
    helloLabel.fontName = "Helvetica"
    helloLabel.fontColor = .black

    
    let tapLabel = SKLabelNode(text: "tap to start...")
    tapLabel.position = CGPoint(x: 0, y: -50)
    tapLabel.fontSize = 20
    tapLabel.fontName = "Helvetica"
    tapLabel.fontColor = .black
    helloNode.addChild(tapLabel)
    helloNode.addChild(helloLabel)
    
    let action = SKAction.fadeAlpha(to: 0.1, duration: 1)
    let act = SKAction.fadeAlpha(to: 1, duration: 1)
    
    
    tapLabel.run(SKAction.repeatForever(SKAction.sequence([action,act])))
    
  }
  
  private func initializeMainBoard(with size: CGSize) {
    boxSize = size.width / 15
    let gameSize = CGSize(
      width: boxSize * CGFloat(numberOfColumns),
      height: boxSize * CGFloat(numberOfRows))
        
    gameZone = SKSpriteNode(color: UIColor.lightGray, size: gameSize)
    gameZone.anchorPoint = CGPoint(x: 0, y: 1)
    gameZone.position = CGPoint(x: rightOffset, y: gameSize.height / 2 + size.height / 2)
    self.addChild(gameZone)
  }
  
  override func update(_ currentTime: TimeInterval) {
    guard let lastTick = lastTick else { return }
    let timePassed = lastTick.timeIntervalSinceNow * -1000.0
    if timePassed > tickLength {
      self.lastTick = Date(timeIntervalSinceNow: 0)
      tetrisLogic.didTick()
    }
  }

  private func positionForSpite(column: Int, row: Int) -> CGPoint {
    return CGPoint(
      x: CGFloat(column) * boxSize,
      y: -CGFloat(row) * boxSize - boxSize
    )
  }
  
  
  
  private func setupGestureRecognizer(to view: SKView) {
    
    let swipeLeft = UISwipeGestureRecognizer()
    swipeLeft.addTarget(tetrisLogic!, action: #selector(tetrisLogic.moveToSide(sender:)) )
    swipeLeft.direction = .left
    view.addGestureRecognizer(swipeLeft)
    
    let swipeRight = UISwipeGestureRecognizer()
    swipeRight.addTarget(tetrisLogic!, action: #selector(tetrisLogic.moveToSide(sender:)))
    swipeRight.direction = .right
    view.addGestureRecognizer(swipeRight)

    let tap = UITapGestureRecognizer()
    tap.addTarget(tetrisLogic!, action: #selector(tetrisLogic.didTap(sender:)))
    view.addGestureRecognizer(tap)

    let swipeDown = UISwipeGestureRecognizer()
    swipeDown.direction = .down
    swipeDown.addTarget(tetrisLogic!, action: #selector(tetrisLogic.dropShape(sender:)))
    view.addGestureRecognizer(swipeDown)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard helloNode != nil else { return }
    helloNode.removeFromParent()
    helloNode = nil
    gameZone.removeAllChildren()
    tetrisLogic.startGame()
  }
  
  
}

extension TetrisScene: GameDelegate {
  
  func drawShape(block: Block, color: UIColor) {
    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: boxSize, height: boxSize))
    path.lineWidth = 4
    let node = SKShapeNode(path: path.cgPath)
    node.position = positionForSpite(column: block.column, row: block.row)
    node.fillColor = color
    block.sprite = node
    gameZone.addChild(node)
  }
  
  func move(block: Block, duration : Double ) {
    block.sprite!.run(SKAction.move(to: positionForSpite(column: block.column, row: block.row), duration: duration))
  }
  
  func setPoint(new point: Int) {
    self.pointsLabel.text = "Points\n \(point)"
  }
  
  func gameOver() {
    createHelloLabel(with: view!.bounds.size)
    guard let textLAbel = helloNode.children.last as? SKLabelNode else { return }
    textLAbel.text = "Game Over"
  }
  
}
