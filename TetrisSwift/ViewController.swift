//
//  ViewController.swift
//  TetrisSwift
//
//  Created by Максим Гребенников on 22.05.2020.
//  Copyright © 2020 Maksim Grebennikov. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

  private var skView: SKView!
  
  override var shouldAutorotate: Bool {
    return false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    initializeSkView()
  }
  
  private func initializeSkView() {
    skView = SKView(frame: view.bounds)
    view.addSubview(skView)
    let scene = TetrisScene()
    skView.presentScene(scene)
    scene.scaleMode = .resizeFill
    scene.backgroundColor = .white
  }
  

  


  
}

