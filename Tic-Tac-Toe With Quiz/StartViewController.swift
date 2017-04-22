//
//  StartViewController.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 4/12/17.
//  Copyright © 2017 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    
    
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
    
    
    
    // MARK: - Variable
    
    let helper = Helper()
    
    
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
//        self.view.backgroundColor = helper.yellowColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
