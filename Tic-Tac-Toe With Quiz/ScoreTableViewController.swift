//
//  ScoreTableViewController.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 4/12/17.
//  Copyright © 2017 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    @IBOutlet var firstPlayerImageView: UIImageView!
    @IBOutlet var secondPlayerImageView: UIImageView!
    @IBOutlet var firstPlayerLabel: UILabel!
    @IBOutlet var secondPlayerLabel: UILabel!
    
}

class ScoreTableViewController: UITableViewController {
    
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
    
    var scoreArray = [String]()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        scoreArray = defaults.stringArray(forKey: Constants.scoreArray) ?? [String]()
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreIdentifier", for: indexPath) as! ScoreTableViewCell
        #if NOT_TO_DO
            print("\(scoreArray[indexPath.row])")
        #else
        #endif
        let inputText = "\(scoreArray[indexPath.row])"
        var arrayFromString = inputText.components(separatedBy: " ")
        #if NOT_TO_DO
        let stringFromArray = arrayFromString.joined(separator:" ")
        #else
        #endif
        if arrayFromString.count >= 2 {
            if arrayFromString.first == "\u{1F947}" {
                print("\(arrayFromString)")
                arrayFromString.remove(at: 0)
                print("\(arrayFromString)")
                
                cell.firstPlayerLabel.text = arrayFromString.first
                cell.secondPlayerLabel.text = arrayFromString.last
                cell.firstPlayerImageView.image = #imageLiteral(resourceName: "Medal")
            } else {
                arrayFromString.remove(at: arrayFromString.count - 1)
                cell.firstPlayerLabel.text = arrayFromString.first
                cell.secondPlayerLabel.text = arrayFromString.last
                cell.secondPlayerImageView.image = #imageLiteral(resourceName: "Medal")
            }
        }
        return cell
    }
    
    // UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        #if NOT_TO_DO
            print("\(indexPath)")
        #else
        #endif
    }
    
    // MARK: - Action
    
    @IBAction func touchCloseBarButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchTrashBarButton(_ sender: UIBarButtonItem) {
        deleteScoreArray()
        scoreArray.removeAll()
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    // Save/load methods
    
    func deleteScoreArray() {
        let defaults = UserDefaults.standard
        let scoreArray: [String] = []
        defaults.set(scoreArray, forKey: Constants.scoreArray)
    }

}
