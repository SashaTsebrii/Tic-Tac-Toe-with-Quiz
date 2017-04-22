//
//  GameViewController.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 11/6/16.
//  Copyright © 2016 Aleksandr Tsebrii. All rights reserved.
//

// FIXME: Use animagion from project "SpringAndBlurDemo" for show and hight popupViews!
// FIXME: Save array for score.

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

struct TextFieldTag {
    let cross = 50
    let nought = 51
}

class GameViewController: UIViewController, UITextFieldDelegate {
    
    
    
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
    
    
    
    // MARK: - Properties
    
    let helper = Helper()
    let choose = Choose()
    let textFieldTag = TextFieldTag()
    let player = Player()
    let cell = Cell()
    let winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8],
                               [0, 3, 6], [1, 4, 7], [2, 5, 8],
                               [0, 4, 8], [2, 4, 6]]
    
    var gameIsActive = false
    var activePlayer = 0
    var gameState: [Int] = []
    var currentTextToSpeach: String = ""
    var questions: [Quiz] = []
    var currentCell = 0
    var audioPlayer: AVAudioPlayer?
    var firstPlayerName = ""
    var secondPlayerName = ""
    var isWin = false
    
    @IBOutlet var enterView: EnterView!
    @IBOutlet var questionView: QuestionView!
    @IBOutlet var alertView: AlertView!
    @IBOutlet weak var activeCrossView: UIView!
    @IBOutlet weak var activeNoughtView: UIView!
    @IBOutlet weak var firstPlayerLabel: UILabel!
    @IBOutlet weak var secondPlayerLabel: UILabel!
    
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enterView.firstPlayerNameField.becomeFirstResponder()
    }
    
    override func loadView() {
        super.loadView()
        
        // set 'enterView'
        enterView.frame.origin = CGPoint(x: (self.view.bounds.width - enterView.frame.width) / 2,
                                         y: (self.view.bounds.height - enterView.frame.height) / 2)
        enterView.layer.shadowColor = UIColor.black.cgColor
        enterView.layer.shadowOpacity = 1
        enterView.layer.shadowOffset = CGSize.zero
        enterView.layer.shadowRadius = min(view.bounds.width, view.bounds.height) * 0.05
        enterView.isHidden = true
        enterView.crossButton.isEnabled = false
        enterView.crossButton.tag = choose.cross
        enterView.crossButton.addTarget(self, action: #selector(actionCrossButtonOrNoughtButton(_:)), for: .touchUpInside)
        enterView.noughtButton.isEnabled = false
        enterView.noughtButton.tag = choose.nought
        enterView.noughtButton.addTarget(self, action: #selector(actionCrossButtonOrNoughtButton(_:)), for: .touchUpInside)
        enterView.firstPlayerNameField.delegate = self
        enterView.firstPlayerNameField.tag = textFieldTag.cross
        enterView.secondPlayerNameField.delegate = self
        enterView.secondPlayerNameField.tag = textFieldTag.nought
        self.view.addSubview(self.enterView)
        
        // set 'questionView'
        questionView.frame.origin = CGPoint(x: (self.view.bounds.width - questionView.frame.width) / 2,
                                            y: (self.view.bounds.height - questionView.frame.height) / 2)
        questionView.layer.shadowColor = UIColor.black.cgColor
        questionView.layer.shadowOpacity = 1
        questionView.layer.shadowOffset = CGSize.zero
        questionView.layer.shadowRadius = min(view.bounds.width, view.bounds.height) * 0.05
        questionView.isHidden = true
        questionView.soundButton.addTarget(self, action: #selector(actionSpeachText(_:)), for: .touchUpInside)
        self.view.addSubview(self.questionView)
        
        // set 'alelrtView'
        alertView.frame.origin = CGPoint(x: (self.view.bounds.width - alertView.frame.width) / 2,
                                         y: (self.view.bounds.height - alertView.frame.height) / 2)
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 1
        alertView.layer.shadowOffset = CGSize.zero
        alertView.layer.shadowRadius = min(view.bounds.width, view.bounds.height) * 0.05
        alertView.isHidden = true
        alertView.closeButton.addTarget(self, action: #selector(actionCloseButton(_:)), for: .touchUpInside)
        self.view.addSubview(self.alertView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterViewShow()
        startNewGame()
    }
    
    
    
    // MARK: - Views' methods
    
    func enterViewShow() {
        enterView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.alertView.alpha = 1
        }, completion: nil)
    }
    
    func enterViewHide() {
        UIView.animate(withDuration: 1, animations: {
            self.enterView.alpha = 0
        }, completion: { (finished: Bool) in
            self.enterView.isHidden = true
        })
    }
    
    func questionViewShow(question: Quiz) {
        #if NOT_TO_DO
            print("REAL question \(question.question)")
        #else
        #endif
        questionView.textLabel.text = "\(question.question)"
        questionView.imageView.image = UIImage(named: question.imageName)
        let answers = question.variantAnswers.components(separatedBy: "-")
        var counter = 0
        for answerButton in questionView.answerButtons {
            answerButton.setTitle("\(answers[counter])", for: .normal)
            answerButton.addTarget(self, action: #selector(anctionAnswerButton(_:)), for: .touchUpInside)
            counter += 1
        }
        let separateQuestion = self.questionView.textLabel.text!.components(separatedBy: "?")
        currentTextToSpeach = separateQuestion[0]
        questionView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.questionView.alpha = 1
        }, completion: { (finished: Bool) in
            self.readText(text: self.currentTextToSpeach)
        })
    }
    
    func questionViewHide() {
        UIView.animate(withDuration: 1, animations: {
            self.questionView.alpha = 0
        }, completion: { (finished: Bool) in
            self.questionView.isHidden = true
        })
    }
    
    func alertViewShow(withText: String, isFAQ: Bool) {
        if isFAQ {
            alertView.textView.isHidden = false
            alertView.textLabel.isHidden = true
            alertView.closeButton.isHidden = false
            alertView.textView.text = withText
            
            alertView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.alertView.alpha = 1
            }, completion: nil)
            
        } else {
            alertView.textView.isHidden = true
            alertView.textLabel.isHidden = false
            alertView.closeButton.isHidden = true
            alertView.textLabel.text = withText
            alertView.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.alertView.alpha = 1
            }, completion: { (finished: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.alertViewHide()
                }
            })
        }
    }
    
    func alertViewHide() {
        UIView.animate(withDuration: 1, animations: {
            self.alertView.alpha = 0
        }, completion: { (finished: Bool) in
            self.alertView.isHidden = true
        })
    }
    
    
    
    // MARK: - Game methods
    
    func startNewGame() {
        generateRandomQuestions()
        let imagesArray = createImagesArrayFromQuestions(questions: questions)
        #if NOT_TO_DO
            print(imagesArray)
        #else
        #endif
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
        firstPlayerLabel.text = enterView.firstPlayerNameField.text!
        secondPlayerLabel.text = enterView.secondPlayerNameField.text!
        enterViewHide()
    }
    
    @IBAction func actionCellButton(_ sender: UIButton) {
        #if NOT_TO_DO
            print("\(sender.tag)")
        #else
        #endif
        if gameIsActive {
            currentCell = sender.tag
            questionViewShow(question: questions[sender.tag - 1])
        }
    }
    
    @IBAction func actionNewGameButton(_ sender: UIButton) {
        startNewGame()
        alertViewShow(withText: "New game.", isFAQ: false)
    }
    
    @IBAction func actionHelpButton(_ sender: UIButton) {
        let text = "You probably already know how to play Tic-Tac-Toe. It's a really simple game, right? That's what most people think. But if you really wrap your brain around it, you'll discover that Tic-Tac-Toe isn't quite as simple as you think!\n" +
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
            "To beat the opponent (or at least tie), you need to make use of a little bit of strategy. Strategy means figuring out what you need to do to win.\n" +
            "Part of your strategy is trying to figure out how to get three Xs in a row. The other part is trying to figure out how to stop the opponent from getting three Os in a row.\n" +
            "After you put an X in a square, you start looking ahead. Where's the best place for your next X? You look at the empty squares and decide which ones are good choices—which ones might let you make three Xs in a row.\n" +
            "You also have to watch where the opponent puts its O. That could change what you do next. If the opponent gets two Os in a row, you have to put your next X in the last empty square in that row, or the opponent will win. You are forced to play in a particular square or lose the game.\n" +
        "If you always pay attention and look ahead, you'll never lose a game of Tic-Tac-Toe. You may not win, but at least you'll tie."
        self.alertViewShow(withText: text, isFAQ: true)
    }
    
    @IBAction func actionHomeButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionCloseButton(_ sender: UIButton) {
        alertViewHide()
    }
    
    @IBAction func actionSpeachText(_ sender: UIButton) {
        readText(text: currentTextToSpeach)
    }
    
    @IBAction func anctionAnswerButton(_ newSender: UIButton) {
        let sender = view.viewWithTag(currentCell) as! UIButton
        let question = questions[sender.tag - 1]
        #if NOT_TO_DO
            print("FACT question \(question.question)")
        #else
        #endif
        
        if newSender.titleLabel!.text == question.rightAnswer {
            playCorrectSound()
            let randomAnswer = ["Good job!", "Fantastic!", "Awesome!", "Excellent!"]
            let randomIndex = Int(arc4random_uniform(UInt32(randomAnswer.count)))
            alertViewShow(withText: randomAnswer[randomIndex], isFAQ: false)
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
                            questionViewHide()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isWin = true
                                self.alertViewShow(withText: "\(self.firstPlayerLabel.text!) has won!", isFAQ: false)
                            }
                            let saveString = "\u{1F947} \(firstPlayerName)     vs.     \(secondPlayerName)   "
                            self.saveString(string: saveString)
                            gameIsActive = false
                        } else {
                            questionViewHide()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isWin = true
                                self.alertViewShow(withText: "\(self.secondPlayerLabel.text!) has won!", isFAQ: false)
                            }
                            let saveString = "   \(firstPlayerName)     vs.     \(secondPlayerName) \u{1F947}"
                            self.saveString(string: saveString)
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
                            questionViewHide()
                            break
                        }
                    }
                    if gameIsActive == false {
                        questionViewHide()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.alertViewShow(withText: "Nobody has won!", isFAQ: false)
                        }
                        let saveString = "   \(firstPlayerName)     vs.     \(secondPlayerName)   "
                        self.saveString(string: saveString)
                        gameIsActive = false
                    }
                }
            }
        } else {
            playWrongSound()
            alertViewShow(withText: "You almost got it, try again.", isFAQ: false)
            questionViewHide()
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
    
    
    
    // Save/load methods
    
    func saveString(string: String) {
        let defaults = UserDefaults.standard
        var scoreArray = defaults.stringArray(forKey: Constants.scoreArray) ?? [String]()
        scoreArray.append(string)
        defaults.set(scoreArray, forKey: Constants.scoreArray)
    }
    
    
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if enterView.firstPlayerNameField.isFirstResponder {
            enterView.firstPlayerNameField.resignFirstResponder()
        }
        if enterView.secondPlayerNameField.isFirstResponder {
            enterView.secondPlayerNameField.resignFirstResponder()
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
    
    func generateRandomQuestions() {
        questions.removeAll()
        
        // fill questions array
        let quiz = Manager.SharedManager.getJSON(fileName: Constants.jsonFile)
        for question in quiz {
            let question = Quiz(question: question[1], variantAnswers: question[2], rightAnswer: question[3], imageName: question[4])
            questions.append(question!)
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
            questions.remove(at: index)
        }
        #if NOT_TO_DO
            print(questions)
            print(nums)
        #else
        #endif
    }
    
    
    
    // MARK: - Sound
    
    func playCorrectSound() {
        guard let url = Bundle.main.url(forResource: "Correct", withExtension: "wav") else {
            #if NOT_TO_DO
                print("sound url not found")
            #else
            #endif
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            #if NOT_TO_DO
                print(error.localizedDescription)
            #else
            #endif
        }
    }
    
    func playWrongSound() {
        guard let url = Bundle.main.url(forResource: "Wrong", withExtension: "wav") else {
            #if NOT_TO_DO
                print("sound url not found")
            #else
            #endif
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let player = audioPlayer else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            #if NOT_TO_DO
                print(error.localizedDescription)
            #else
            #endif
        }
    }
    
    func readText(text: String) {
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        let toSay = AVSpeechUtterance(string : text)
        toSay.rate = 0.35
        toSay.voice = voice
        let spk = AVSpeechSynthesizer( )
        spk.speak(toSay)
    }
    
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == textFieldTag.cross {
            // cross
            firstPlayerName = textField.text!
            if enterView.firstPlayerNameField.text != "" && enterView.secondPlayerNameField.text != "" {
                enterView.crossButton.isEnabled = true
                enterView.noughtButton.isEnabled = true
            }
        } else if textField.tag == textFieldTag.nought {
            // nought
            secondPlayerName = textField.text!
            if enterView.firstPlayerNameField.text != "" && enterView.secondPlayerNameField.text != "" {
                enterView.crossButton.isEnabled = true
                enterView.noughtButton.isEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if enterView.firstPlayerNameField.isFirstResponder {
            enterView.secondPlayerNameField.becomeFirstResponder()
            return true
        }
        
        if enterView.secondPlayerNameField.isFirstResponder {
            enterView.secondPlayerNameField.resignFirstResponder()
            return true
        }
        
        if enterView.firstPlayerNameField.text != "" && enterView.secondPlayerNameField.text != "" {
            enterView.crossButton.isEnabled = true
            enterView.noughtButton.isEnabled = true
        }
        return false
    }
}
