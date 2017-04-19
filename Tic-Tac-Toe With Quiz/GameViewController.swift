//
//  GameViewController.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 11/6/16.
//  Copyright © 2016 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import AVFoundation

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

struct popupView {
    let popupViewEnter = 1
    let popupViewAlert = 2
    let popupViewQuestion = 3
}

class GameViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    let helper = Helper()
    
    // Enter View Properties
    @IBOutlet var enterView: EnterView!
    @IBOutlet weak var enterViewTextLabel: UILabel!
    @IBOutlet weak var enterViewOrLabel: UILabel!
    @IBOutlet weak var enterViewFirstPlayerField: UITextField!
    @IBOutlet weak var enterViewSecondPlayerField: UITextField!
    @IBOutlet weak var enterViewCrossButton: UIButton!
    @IBOutlet weak var enterViewNoughtButton: UIButton!
    
    // Question View Properties
    @IBOutlet var questionView: QuestionView!
    @IBOutlet weak var questionViewTextLabel: UILabel!
    @IBOutlet weak var questionViewImageView: UIImageView!
    @IBOutlet var questionViewAnswerButtons: [UIButton]!
    
    // Alert View Properties
    @IBOutlet var alertView: AlertView!
    @IBOutlet weak var alertViewTextLabel: UILabel!
    @IBOutlet weak var alertVeiwCloseButton: UIButton!
    
    
    let alertView = AlertView()
    let questionView = QuestionView()
    let choose = Choose()
    let firstPlayerNameField = UITextField()
    let secondPlayerNameField = UITextField()
    let crossButton = UIButton(type: .custom)
    let noughtButton = UIButton(type: .custom)
    
    var gameIsActive = false
    var activePlayer = 0
    let player = Player()
    let cell = Cell()
    var gameState: [Int] = []
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
    var questions: [Quiz] = []
    var currentCell = 0
    var audioPlayer: AVAudioPlayer?
    
    var firstPlayerName = ""
    var secondPlayerName = ""
    
    var isWin = false
        
    @IBOutlet weak var activeCrossView: UIView!
    @IBOutlet weak var activeNoughtView: UIView!
    
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var secondPlayerLabel: UILabel!
    
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
        
        self.view.backgroundColor = helper.yellowColor
        
        // FIXME: - remove creating 'alertView' to storyboprd
        // create alert view
        let indentHorizontal = view.bounds.width * 0.05
        let indentVertical = view.bounds.height * 0.05
        let alertRect = CGRect(x: indentHorizontal, y: indentVertical,
                               width: view.bounds.width - indentHorizontal * 2, height: view.bounds.height - indentVertical * 2)
        alertView.frame = alertRect
        alertView.backgroundColor = helper.greenColor
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 1
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = min(view.bounds.width, view.bounds.height) * 0.03
        view.addSubview(alertView)
        
        let textFrame = CGSize(width: alertView.bounds.width, height: alertView.bounds.height * 0.2)
        let textRect = CGRect(x: alertView.bounds.minX, y: alertView.bounds.midY + alertView.bounds.size.height * 0.05 - textFrame.height * 2.5,
                              width: textFrame.width, height: textFrame.height)
        let textLabel = UILabel(frame: textRect)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        let font = UIFont.boldSystemFont(ofSize: textFrame.height * 0.4)
        let attributed = NSAttributedString(string: "Enter the names for both teams.\n Then select the team.", attributes: [NSFontAttributeName: font])
        textLabel.attributedText = attributed
        alertView.addSubview(textLabel)
        
        let crossOrNoughtSizeFloat = min(alertView.bounds.width, alertView.bounds.height) * 0.3
        
        let crossRect = CGRect(x: alertView.bounds.midX - crossOrNoughtSizeFloat * 2, y: alertView.bounds.midY,
                               width: crossOrNoughtSizeFloat, height: crossOrNoughtSizeFloat)
        crossButton.frame = crossRect
        crossButton.backgroundColor = helper.redColor
        crossButton.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
        crossButton.isEnabled = false
        crossButton.tag = choose.cross
        crossButton.addTarget(self, action: #selector(actionCrossButtonOrNoughtButton(_:)), for: .touchUpInside)
        alertView.addSubview(crossButton)
        
        let noughtRect = CGRect(x: alertView.bounds.midX + crossOrNoughtSizeFloat, y: alertView.bounds.midY,
                               width: crossOrNoughtSizeFloat, height: crossOrNoughtSizeFloat)
        noughtButton.frame = noughtRect
        noughtButton.backgroundColor = helper.blueColor
        noughtButton.setImage(#imageLiteral(resourceName: "Nought"), for: .normal)
        noughtButton.isEnabled = false
        noughtButton.tag = choose.nought
        noughtButton.addTarget(self, action: #selector(actionCrossButtonOrNoughtButton(_:)), for: .touchUpInside)
        alertView.addSubview(noughtButton)
        
        firstPlayerNameField.frame = CGRect(x: crossButton.frame.origin.x - crossButton.frame.size.width * 0.5,
                                            y: crossButton.frame.origin.y - crossButton.frame.size.height / 2,
                                            width: crossButton.frame.size.width * 2, height: crossButton.frame.size.height / 3)
        firstPlayerNameField.borderStyle = .line
        firstPlayerNameField.placeholder = "first player name"
        firstPlayerNameField.delegate = self
        firstPlayerNameField.tag = 50
        alertView.addSubview(firstPlayerNameField)
        
        secondPlayerNameField.frame = CGRect(x: noughtButton.frame.origin.x - noughtButton.frame.size.width * 0.5,
                                             y: noughtButton.frame.origin.y - noughtButton.frame.size.height / 2,
                                             width: noughtButton.frame.size.width * 2, height: noughtButton.frame.size.height / 3)
        secondPlayerNameField.borderStyle = .line
        secondPlayerNameField.placeholder = "second player name"
        secondPlayerNameField.delegate = self
        secondPlayerNameField.tag = 51
        alertView.addSubview(secondPlayerNameField)
        
        // create question view
        questionView.frame = alertRect
        questionView.backgroundColor = UIColor.white
        questionView.layer.shadowOpacity = 1
        questionView.layer.shadowOffset = CGSize.zero
        questionView.layer.shadowRadius = min(view.bounds.width, view.bounds.height) * 0.03
        questionView.isHidden = true
        questionView.alpha = 0
        view.addSubview(questionView)
        
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
            activeCrossView.backgroundColor = helper.redColor
            activeNoughtView.backgroundColor = helper.greyColor
            
        case choose.nought:
            activePlayer = player.nought
            activeNoughtView.backgroundColor = helper.blueColor
            activeCrossView.backgroundColor = helper.greyColor
            
        default:
            activePlayer = player.cross
        }
        
        firstPlayerLabel.text = firstPlayerNameField.text!
        secondPlayerLabel.text = secondPlayerNameField.text!
        hideAlertView()
        
    }
    
    @IBAction func actionCellButton(_ sender: UIButton) {
        print("\(sender.tag)")
        if gameIsActive {
            currentCell = sender.tag
            showQuestionViewWithQuestion(question: questions[sender.tag - 1])
        }
    }
    
    @IBAction func actionNewGameButton(_ sender: UIButton) {
        
        startNewGame()
        showAlertViewWithText(inputText: "New game.")
        
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
            "2. You are X, your friend is O. Players take turns putting their marks in empty squares.\n" +
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
        closeButton.backgroundColor = helper.yellowColor
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
        if sender.tag == 22 {
            hideQuestionView()
        } else {
            if isWin {
                isWin = false
                hideAlertView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.startNewGame()
                }
            } else {
                hideAlertView()
            }
        }
    }
    
    @IBAction func anctionAnswerButton(_ newSender: UIButton) {
        
        let sender = view.viewWithTag(currentCell) as! UIButton
        let question = questions[sender.tag - 1]
        print("FACT question \(question.question)")
        
        if newSender.titleLabel!.text == question.rightAnswer {
            playCorrectSound()
            let randomAnswer = ["Good job!", "Fantastic!", "Awesome!", "Excellent!"]
            let randomIndex = Int(arc4random_uniform(UInt32(randomAnswer.count)))
            showAlertViewWithText(inputText: randomAnswer[randomIndex])
            if gameIsActive == true {
                // check for cell is empty
                if gameState[sender.tag - 1] == cell.free  && gameIsActive == true {
                    
                    // change cell state
                    gameState[sender.tag - 1] = activePlayer
                    
                    // design what drow in free cell
                    if activePlayer == player.cross {
                        sender.setImage(#imageLiteral(resourceName: "Cross"), for: .normal)
                        sender.backgroundColor = helper.redColor
                        activeCrossView.backgroundColor = helper.greyColor
                        activeNoughtView.backgroundColor = helper.blueColor
                        activePlayer = player.nought
                    } else {
                        sender.setImage(#imageLiteral(resourceName: "Nought"), for: .normal)
                        sender.backgroundColor = helper.blueColor
                        activeCrossView.backgroundColor = helper.redColor
                        activeNoughtView.backgroundColor = helper.greyColor
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
                            hideQuestionView()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isWin = true
                                self.showAlertViewWithText(inputText: "\(self.firstPlayerLabel.text!) has won!")
                            }
                            gameIsActive = false
                        } else {
                            hideQuestionView()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isWin = true
                                self.showAlertViewWithText(inputText: "\(self.secondPlayerLabel.text!) has won!")
                            }
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
                            hideQuestionView()
                            break
                        }
                    }
                    if gameIsActive == false {
                        hideQuestionView()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showAlertViewWithText(inputText: "Nobody has won!")
                        }
                        gameIsActive = false
                    }
                }
            }
        } else {
            playWrongSound()
            showAlertViewWithText(inputText: "You almost got it, try again.")
            hideQuestionView()
            if activePlayer == player.cross {
                activePlayer = player.nought
                activeCrossView.backgroundColor = helper.greyColor
                activeNoughtView.backgroundColor = helper.blueColor
            } else if activePlayer == player.nought {
                activePlayer = player.cross
                activeCrossView.backgroundColor = helper.redColor
                activeNoughtView.backgroundColor = helper.greyColor
            }
        }
        
    }
    
    // MARK: - Help
    
    func createImagesArrayFromQuestions(questions: [Quiz]) -> [UIImage] {
        
        var imagesArray: [UIImage] = []
        
        for question in questions {
            
            let indentHorizontal = self.view.bounds.width * 0.05
            let indentVertical = self.view.bounds.height * 0.05
            let alertRect = CGRect(x: indentHorizontal, y: indentVertical,
                                   width: self.view.bounds.width - indentHorizontal * 2, height: self.view.bounds.height - indentVertical * 2)
            let questionView = UIView()
            questionView.frame = alertRect
            questionView.backgroundColor = UIColor.white
            questionView.layer.shadowOpacity = 1
            questionView.layer.shadowOffset = CGSize.zero
            questionView.layer.shadowRadius = min(self.view.bounds.width, self.view.bounds.height) * 0.03
            questionView.isHidden = false
            questionView.alpha = 1
            view.addSubview(questionView)
            view.bringSubview(toFront: questionView)
            
            let questionFrame = CGSize(width: questionView.bounds.width, height: questionView.bounds.height * 0.3)
            let questionRect = CGRect(x: questionView.bounds.minX, y: questionView.bounds.minY,
                                      width: questionFrame.width, height: questionFrame.height)
            let questionLabel = UILabel(frame: questionRect)
            let font = UIFont.boldSystemFont(ofSize: questionRect.height * 0.3)
            let attributed = NSAttributedString(string: "\(question.question)", attributes: [NSFontAttributeName: font])
            questionLabel.numberOfLines = 0
            questionLabel.attributedText = attributed
            questionLabel.lineBreakMode = .byWordWrapping
            questionLabel.textAlignment = .center
            questionLabel.adjustsFontSizeToFitWidth = true
            questionView.addSubview(questionLabel)
            
            let imageRect = CGRect(x: questionView.bounds.minX, y: questionLabel.frame.maxY,
                                   width: questionView.bounds.width, height: questionView.bounds.height * 0.5)
            let imageView = UIImageView(frame: imageRect)
            imageView.backgroundColor = UIColor.clear
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: question.imageName)
            questionView.addSubview(imageView)
            
            let buttonWidth = questionView.bounds.width / 3
            let answers = question.variantAnswers.components(separatedBy: "-")
            for i in 0...2 {
                let answerButton = UIButton(type: .custom)
                answerButton.frame = CGRect(x: buttonWidth * CGFloat(i), y: imageView.frame.maxY,
                                            width: buttonWidth, height: questionView.bounds.height * 0.2)
                let font = UIFont.boldSystemFont(ofSize: questionRect.height * 0.3)
                let attributed = NSAttributedString(string: "\(answers[i])", attributes: [NSFontAttributeName: font])
                answerButton.setAttributedTitle(attributed, for: .normal)
                answerButton.setTitleColor(UIColor.black, for: .normal)
                questionView.addSubview(answerButton)
            }
            
            let image = UIImage.imageWithView(view: questionView)
            imagesArray.append(image)
            
            for view in questionView.subviews {
                view.removeFromSuperview()
            }
            questionView.removeFromSuperview()
            
        }
        
        return imagesArray
    }
    
    func startNewGame() {
        
        generateRandomQuestions()
        
        let imagesArray = createImagesArrayFromQuestions(questions: questions)
        print(imagesArray)
        
        gameIsActive = true
        activePlayer = player.cross
        activeCrossView.backgroundColor = helper.redColor
        activeNoughtView.backgroundColor = helper.greyColor
        gameState = [cell.free, cell.free, cell.free,
                     cell.free, cell.free, cell.free,
                     cell.free, cell.free, cell.free]
        
        for i in 1...9 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(imagesArray[i - 1], for: .normal)
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
        
        let closeButton = UIButton(type: .custom)
        let closeRect = CGRect(x: alertView.bounds.maxX - alertView.bounds.width * 0.05, y: alertView.bounds.minY,
                               width: alertView.bounds.width * 0.05, height: alertView.bounds.height * 0.1)
        closeButton.frame = closeRect
        closeButton.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        closeButton.backgroundColor = helper.yellowColor
        closeButton.alpha = 1
        closeButton.addTarget(self, action: #selector(actionCloseButton(_:)), for: .touchUpInside)
        alertView.addSubview(closeButton)
        
        self.alertView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.alertView.alpha = 1
        }, completion: { (finished: Bool) in
            if !self.isWin {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.hideAlertView()
                }
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
    
    func showQuestionViewWithQuestion(question: Quiz) {
        
        print("REAL question \(question.question)")
        
        let closeButton = UIButton(type: .custom)
        let closeRect = CGRect(x: alertView.bounds.maxX - alertView.bounds.width * 0.05, y: alertView.bounds.minY,
                               width: alertView.bounds.width * 0.05, height: alertView.bounds.height * 0.1)
        closeButton.frame = closeRect
        closeButton.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        closeButton.backgroundColor = helper.yellowColor
        closeButton.alpha = 1
        closeButton.tag = 22
        closeButton.addTarget(self, action: #selector(actionCloseButton(_:)), for: .touchUpInside)
        questionView.addSubview(closeButton)

        
        let questionFrame = CGSize(width: questionView.bounds.width, height: questionView.bounds.height * 0.3)
        let questionRect = CGRect(x: questionView.bounds.minX, y: questionView.bounds.minY,
                              width: questionFrame.width, height: questionFrame.height)
        let questionLabel = UILabel(frame: questionRect)
        let font = UIFont.boldSystemFont(ofSize: questionRect.height * 0.3)
        let attributed = NSAttributedString(string: "\(question.question)", attributes: [NSFontAttributeName: font])
        questionLabel.numberOfLines = 0
        questionLabel.attributedText = attributed
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.textAlignment = .center
        questionLabel.adjustsFontSizeToFitWidth = true
        questionView.addSubview(questionLabel)
        
        let imageRect = CGRect(x: questionView.bounds.minX, y: questionLabel.frame.maxY,
                               width: questionView.bounds.width, height: questionView.bounds.height * 0.5)
        let imageView = UIImageView(frame: imageRect)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: question.imageName)
        questionView.addSubview(imageView)
        
        let buttonWidth = questionView.bounds.width / 3
        let answers = question.variantAnswers.components(separatedBy: "-")
        for i in 0...2 {
            let answerButton = UIButton(type: .custom)
            answerButton.frame = CGRect(x: buttonWidth * CGFloat(i), y: imageView.frame.maxY,
                                        width: buttonWidth, height: questionView.bounds.height * 0.2)
            let font = UIFont.boldSystemFont(ofSize: questionRect.height * 0.3)
            let attributed = NSAttributedString(string: "\(answers[i])", attributes: [NSFontAttributeName: font])
            answerButton.setAttributedTitle(attributed, for: .normal)
            answerButton.setTitleColor(UIColor.black, for: .normal)
            answerButton.addTarget(self, action: #selector(anctionAnswerButton(_:)), for: .touchUpInside)
            questionView.addSubview(answerButton)
        }
        
        self.questionView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.questionView.alpha = 1
        }, completion: nil)
    }

    
    func hideQuestionView() {
        UIView.animate(withDuration: 1, animations: {
            self.questionView.alpha = 0
        }, completion: { (finished: Bool) in
            for subview in self.questionView.subviews {
                subview.removeFromSuperview()
            }
            self.questionView.isHidden = true
        })
    }
    
    func generateRandomQuestions() {
        self.questions.removeAll()
        
        // fill questions array
        let quiz = Manager.SharedManager.getJSON(fileName: "quiz")
        for question in quiz {
            let question = Quiz(question: question[1], variantAnswers: question[2], rightAnswer: question[3], imageName: question[4])
            self.questions.append(question!)
        }
        
        // create an array of 0 through 59
        var nums = Array(0...59)
        // remove the blacklist number
        nums.remove(at: nums.index(of: 8)!)
        var randoms = [Int]()
        for _ in 1...50 {
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            randoms.append(nums[index])
            nums.remove(at: index)
            self.questions.remove(at: index)
        }
        
        print(self.questions)
        print(nums)
    }
    
    // MARK: - Sound
    
    func playCorrectSound() {
        guard let url = Bundle.main.url(forResource: "Correct", withExtension: "wav") else {
            print("sound url not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playWrongSound() {
        guard let url = Bundle.main.url(forResource: "Wrong", withExtension: "wav") else {
            print("sound url not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 50 {
            // cross
            firstPlayerName = textField.text!
            if firstPlayerNameField.text != "" && secondPlayerNameField.text != "" {
                crossButton.isEnabled = true
                noughtButton.isEnabled = true
            }
        } else if textField.tag == 51 {
            // nought
            secondPlayerName = textField.text!
            if firstPlayerNameField.text != "" && secondPlayerNameField.text != "" {
                crossButton.isEnabled = true
                noughtButton.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if firstPlayerNameField.text != "" && secondPlayerNameField.text != "" {
            crossButton.isEnabled = true
            noughtButton.isEnabled = true
        }
        return true
    }
    
}
