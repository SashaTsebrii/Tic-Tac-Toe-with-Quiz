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
    let free = 0
    let occupied = 1
}

class ViewController: UIViewController {
    
    // MARK: - Constant
    
    //    let staticGreenColor = UIColor(red: 77, green: 194, blue: 0, alpha: 1)
    //    let staticYellowColor = UIColor(red: 255, green: 249, blue: 38, alpha: 1)
    //    let staticRedColor = UIColor(red: 255, green: 40, blue: 19, alpha: 1)
    //    let staticBlueColor = UIColor(red: 59, green: 217, blue: 255, alpha: 1)
    //    let staticGreyColor = UIColor(red: 163, green: 173, blue: 194, alpha: 1)
    
    // MARK: - Properties
    
    var gameIsActive = false
    var activePlayer = 0
    let player = Player()
    let cell = Cell()
    var gameState: [Int] = []
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
    // TODO: create quiz array from core data
    
    // MARK: - Setting
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        // FIXIT: set random button image from quiz array
        /*
         let maxBoardSizeFloat = min(view.bounds.width, view.bounds.height)
         let maxCellSizeFloat = maxBoardSizeFloat / CGFloat(3)
         let maxButtonSizeFloat = maxBoardSizeFloat * 0.1
         
         let boardRect = CGRect(x: 0, y: 0, width: maxBoardSizeFloat, height: maxBoardSizeFloat)
         let boardView = UIView(frame: boardRect)
         boardView.backgroundColor = UIColor.clear
         view.addSubview(boardView)
         
         var tagCount = 0
         for y in 0...2 {
         for x in 0...2 {
         tagCount += 1
         
         let cellButton = UIButton(type: .custom)
         let cellRect = CGRect(x: CGFloat(x) * maxCellSizeFloat, y: CGFloat(y) * maxCellSizeFloat,
         width: maxCellSizeFloat, height: maxCellSizeFloat)
         cellButton.frame = cellRect
         cellButton.backgroundColor = UIColor.clear
         cellButton.tag = tagCount
         cellButton.addTarget(self, action: #selector(actionCellButton(_:)), for: .touchUpInside)
         boardView.addSubview(cellButton)
         }
         }
         
         let newGameButton = UIButton(type: .custom)
         let newGameRect = CGRect(x: view.bounds.width - maxButtonSizeFloat, y: 0,
         width: maxButtonSizeFloat, height: maxButtonSizeFloat)
         newGameButton.frame = newGameRect
         newGameButton.backgroundColor = UIColor.red
         newGameButton.addTarget(self, action: #selector(actionNewGameButton(_:)), for: .touchUpInside)
         view.addSubview(newGameButton)
         */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewGame()
        
    }
    
    // MARK: - Action
    
    @IBAction func actionCellButton(_ sender: UIButton)  {
        print("\(sender.tag)")
        
        if gameIsActive == true {
            // check for cell is empty
            if gameState[sender.tag - 1] == cell.free  && gameIsActive == true {
                
                // change cell state
                gameState[sender.tag - 1] = activePlayer
                
                // design what drow in free cell
                if activePlayer == player.cross {
                    sender.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
                    activePlayer = player.nought
                } else {
                    sender.setImage(#imageLiteral(resourceName: "Nought"), for: .normal)
                    activePlayer = player.cross
                }
                
            }
            
            // check for player is won
            for combination in winningCombinations {
                if gameState[combination[0]] != cell.free &&
                    gameState[combination[0]] == gameState[combination[1]] &&
                    gameState[combination[1]] == gameState[combination[2]] {
                    
                    gameIsActive = false
                    
                    // check what is concret player won
                    if gameState[combination[0]] == player.cross {
                        // TODO: show custom alert view
                        print("cross has won")
                        gameIsActive = false
                    } else {
                        print("nought has won")
                        gameIsActive = false
                    }
                    
                }
            }
            
            // check for nobody is won
            if gameIsActive == true {
                gameIsActive = false
                for i in gameState {
                    if i == cell.free {
                        gameIsActive = true
                        break
                    }
                }
                if gameIsActive == false {
                    print("nobody has won")
                    gameIsActive = false
                }
            }
        }
    }
    
    @IBAction func actionNewGameButton(_ sender: UIButton) {
        
        startNewGame()
        print("new game")
        
    }
    
    // MARK: - Tic-tac-toe game logic
    
    func startNewGame() {
        
        gameIsActive = true
        activePlayer = player.cross
        gameState = [cell.free, cell.free, cell.free,
                     cell.free, cell.free, cell.free,
                     cell.free, cell.free, cell.free]
        
        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            // TODO: add random quiz from quiz array
            button.setImage(nil, for: .normal)
            button.backgroundColor = UIColor.white
        }
        
    }
    
    // MARK: - Quiz game logic
    
    // TODO: get object for quiz array from core data
    
}

