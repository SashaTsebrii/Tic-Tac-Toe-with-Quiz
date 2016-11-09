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

struct Choose {
    let cross = 11
    let nought = 22
}

struct Cell {
    let free = 0
    let occupied = 1
}

class ViewController: UIViewController {
    
    // MARK: - Constant
    
    let redColor = UIColor(red:1.00, green:0.16, blue:0.07, alpha:1.0)
    let blueColor = UIColor(red:0.23, green:0.85, blue:1.00, alpha:1.0)
    let greenColor = UIColor(red:0.30, green:0.76, blue:0.00, alpha:1.0)
    let yellowColor = UIColor(red:1.00, green:0.98, blue:0.15, alpha:1.0)
    let greyColor = UIColor(red:0.64, green:0.68, blue:0.76, alpha:1.0)
    
    // MARK: - Properties
    
    let alertView = UIView()
    let choose = Choose()
    
    var gameIsActive = false
    var activePlayer = 0
    let player = Player()
    let cell = Cell()
    var gameState: [Int] = []
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
    // TODO: create quiz array from core data
    
    // TODO: create textView for ? bunnto and add description
    
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
        
        let indentHorizontal = view.bounds.width * 0.05
        let indentVertical = view.bounds.height * 0.05
        let alertRect = CGRect(x: indentHorizontal, y: indentVertical,
                               width: view.bounds.width - indentHorizontal * 2, height: view.bounds.height - indentVertical * 2)
        alertView.frame = alertRect
        alertView.backgroundColor = greenColor
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 1
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = min(view.bounds.width, view.bounds.height) * 0.03
        view.addSubview(alertView)
        
        let textFrame = CGSize(width: alertView.bounds.width, height: alertView.bounds.height * 0.1)
        let textRect = CGRect(x: alertView.bounds.minX, y: alertView.bounds.midY - textFrame.height * 2.5,
                              width: textFrame.width, height: textFrame.height)
        let textLabel = UILabel(frame: textRect)
        textLabel.textAlignment = .center
        let font = UIFont.boldSystemFont(ofSize: textFrame.height * 0.8)
        let attributed = NSAttributedString(string: "Choose your team", attributes: [NSFontAttributeName: font])
        textLabel.attributedText = attributed
        alertView.addSubview(textLabel)
        
        let crossOrNoughtSizeFloat = min(alertView.bounds.width, alertView.bounds.height) * 0.3
        
        let crossButton = UIButton(type: .custom)
        let crossRect = CGRect(x: alertView.bounds.midX - crossOrNoughtSizeFloat * 2, y: alertView.bounds.midY,
                               width: crossOrNoughtSizeFloat, height: crossOrNoughtSizeFloat)
        crossButton.frame = crossRect
        crossButton.backgroundColor = redColor
        crossButton.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
        crossButton.tag = choose.cross
        crossButton.addTarget(self, action: #selector(actionCrossButtonOrNoughtButton(_:)), for: .touchUpInside)
        alertView.addSubview(crossButton)
        
        let noughtButton = UIButton(type: .custom)
        let noughtRect = CGRect(x: alertView.bounds.midX + crossOrNoughtSizeFloat, y: alertView.bounds.midY,
                               width: crossOrNoughtSizeFloat, height: crossOrNoughtSizeFloat)
        noughtButton.frame = noughtRect
        noughtButton.backgroundColor = blueColor
        noughtButton.setImage(#imageLiteral(resourceName: "Nought"), for: .normal)
        noughtButton.tag = choose.nought
        noughtButton.addTarget(self, action: #selector(actionCrossButtonOrNoughtButton(_:)), for: .touchUpInside)
        alertView.addSubview(noughtButton)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewGame()
        
    }
    
    // MARK: - Action
    
    @IBAction func actionCrossButtonOrNoughtButton(_ sender: UIButton) {
        
        switch sender.tag {
        case choose.cross:
            activePlayer = player.cross
        case choose.nought:
            activePlayer = player.nought
            
        default:
            activePlayer = player.cross
        }
        
        hideAlertView()
        
    }
    
    @IBAction func actionCellButton(_ sender: UIButton) {
        print("\(sender.tag)")
        
        if gameIsActive == true {
            // check for cell is empty
            if gameState[sender.tag - 1] == cell.free  && gameIsActive == true {
                
                // change cell state
                gameState[sender.tag - 1] = activePlayer
                
                // design what drow in free cell
                if activePlayer == player.cross {
                    sender.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
                    sender.backgroundColor = redColor
                    activePlayer = player.nought
                } else {
                    sender.setImage(#imageLiteral(resourceName: "Nought"), for: .normal)
                    sender.backgroundColor = blueColor
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
                        showAlertViewWithText(inputText: "Cross has won!")
                        gameIsActive = false
                    } else {
                        showAlertViewWithText(inputText: "Nought has won!")
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
                    showAlertViewWithText(inputText: "Nobody has won!")
                    gameIsActive = false
                }
            }
        }
    }
    
    @IBAction func actionNewGameButton(_ sender: UIButton) {
        
        startNewGame()
        print("new game")
        
    }
    
    @IBAction func actionHelpButton(_ sender: UIButton) {
        
        let textRect = CGRect(x: alertView.bounds.width * 0.05, y: alertView.bounds.height * 0.1,
                              width: alertView.bounds.width * 0.9, height: alertView.bounds.height * 0.8)
        let textView = UITextView(frame: textRect)
        textView.text = "You probably already know how to play Tic-Tac-Toe. It's a really simple game, right? That's what most people think. But if you really wrap your brain around it, you'll discover that Tic-Tac-Toe isn't quite as simple as you think!\n" +
            "Tic-Tac -Toe (along with a lot of other games) involves looking ahead and trying to figure out what the person playing against you might do next.\n" +
            "\n" +
            "RULES FOR TIC-TAC-TOE\n" +
            "\n" +
            "1. The game is played on a grid that's 3 squares by 3 squares.\n" +
            "2. You are X, your friend (or the computer in this case) is O. Players take turns putting their marks in empty squares.\n" +
            "3. The first player to get 3 of her marks in a row (up, down, across, or diagonally) is the winner.\n" +
            "4. When all 9 squares are full, the game is over. If no player has 3 marks in a row, the game ends in a tie.\n" +
            "\n" +
            "HOW CAN I WIN AT TIC-TAC-TOE?\n" +
            "\n" +
            "To beat the computer (or at least tie), you need to make use of a little bit of strategy. Strategy means figuring out what you need to do to win.\n" +
            "Part of your strategy is trying to figure out how to get three Xs in a row. The other part is trying to figure out how to stop the computer from getting three Os in a row.\n" +
            "After you put an X in a square, you start looking ahead. Where's the best place for your next X? You look at the empty squares and decide which ones are good choices—which ones might let you make three Xs in a row.\n" +
            "You also have to watch where the computer puts its O. That could change what you do next. If the computer gets two Os in a row, you have to put your next X in the last empty square in that row, or the computer will win. You are forced to play in a particular square or lose the game.\n" +
            "If you always pay attention and look ahead, you'll never lose a game of Tic-Tac-Toe. You may not win, but at least you'll tie."
        alertView.addSubview(textView)
        
        let closeButton = UIButton(type: .custom)
        let closeRect = CGRect(x: alertView.bounds.maxX - alertView.bounds.width * 0.05, y: alertView.bounds.minY,
                               width: alertView.bounds.width * 0.05, height: alertView.bounds.height * 0.1)
        closeButton.frame = closeRect
        closeButton.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        closeButton.backgroundColor = yellowColor
        closeButton.alpha = 0
        closeButton.addTarget(self, action: #selector(actionCloseButton(_:)), for: .touchUpInside)
        alertView.addSubview(closeButton)
        
        self.alertView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.alertView.alpha = 1
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 1, animations: {
                closeButton.alpha = 1
            })
        })
        
    }
    
    @IBAction func actionCloseButton(_ sender: UIButton) {
        hideAlertView()
    }
    
    // MARK: - Help
    
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
        
    func showAlertViewWithText(inputText: String) {
        
        let textFrame = CGSize(width: alertView.bounds.width, height: alertView.bounds.height * 0.1)
        let textRect = CGRect(x: alertView.bounds.minX, y: alertView.bounds.midY - textFrame.height / 2,
                              width: textFrame.width, height: textFrame.height)
        let textLabel = UILabel(frame: textRect)
        textLabel.textAlignment = .center
        let font = UIFont.boldSystemFont(ofSize: textFrame.height * 0.8)
        let attributed = NSAttributedString(string: inputText, attributes: [NSFontAttributeName: font])
        textLabel.attributedText = attributed
        alertView.addSubview(textLabel)
        
        self.alertView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.alertView.alpha = 1
        }, completion: { (finished: Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.hideAlertView()
            }
        })
    }
    
    func hideAlertView() {
        UIView.animate(withDuration: 1, animations: {
            self.alertView.alpha = 0
        }, completion: { (finished: Bool) in
            for subview in self.alertView.subviews {
                subview.removeFromSuperview()
            }
            self.alertView.isHidden = true
        })
    }
    
    // TODO: get object for quiz array from core data
    
}

