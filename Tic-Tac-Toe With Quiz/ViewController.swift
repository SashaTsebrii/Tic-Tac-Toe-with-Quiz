//
//  ViewController.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 11/6/16.
//  Copyright © 2016 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

struct Player {
    let cross = 1
    let nought = 2
}

struct Cell {
    let free = true
    let occupied = false
}

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    var gameIsActive = false
    var activePlayer = 0
    var gameState = [0]
    let winningCombination = [[], []]
    // FIXME: create quiz array from core data
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let maxBoardSizeFloat = min(view.bounds.width, view.bounds.height)
        let maxCellSizeFloat = maxBoardSizeFloat / CGFloat(3)
        
        let boardRect = CGRect(x: 0, y: 0, width: maxBoardSizeFloat, height: maxBoardSizeFloat)
        let boardView = UIView(frame: boardRect)
        boardView.backgroundColor = UIColor.clear
        view.addSubview(boardView)
        
        var tagCount = 0
        for y in 0...2 {
            for x in 0...2 {
                tagCount += 1
                let cellRect = CGRect(x: CGFloat(x) * maxCellSizeFloat, y: CGFloat(y) * maxCellSizeFloat, width: maxCellSizeFloat, height: maxCellSizeFloat)
                let cellButton = UIButton(type: .system)
                cellButton.frame = cellRect
                // FIXME: set random image from quiz array
                cellButton.backgroundColor = UIColor.clear
                cellButton.tag = tagCount
                cellButton.addTarget(self, action: #selector(actionCellButton(_:)), for: .touchUpInside)
                boardView.addSubview(cellButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // MARK: - Action
    
    @IBAction
    
    func actionCellButton(_ sender: UIButton)  {
        print("\(sender.tag)")
    }
    
    // MARK: - Tic-tac-toe game logic
    
    func newGame() {
        
        
        
    }
    
    func gameEnd() {
        
        
        
    }
    
    // MARK: - Quiz game logic
    
    // TODO: get object for quiz array from core data
    
}

