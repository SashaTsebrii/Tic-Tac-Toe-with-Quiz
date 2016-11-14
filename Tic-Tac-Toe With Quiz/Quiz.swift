//
//  Quiz.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 11/10/16.
//  Copyright © 2016 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class Quiz: NSObject {
    
    let question: String
    let variantAnswers: String
    let rightAnswer: String
    let imageName: String
    
    init?(question: String, variantAnswers: String, rightAnswer: String, imageName: String) {
        self.question = question
        self.variantAnswers = variantAnswers
        self.rightAnswer = rightAnswer
        self.imageName = imageName
    }
    
}
