//
//  ScoreTableViewController.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 4/12/17.
//  Copyright © 2017 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreIdentifier", for: indexPath)
        cell.textLabel?.text = "\(scoreArray[indexPath.row])"
        cell.textLabel?.textAlignment = .center
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
}
