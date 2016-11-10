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
    
    init?(withJSON fileName: String) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let objects : [NSDictionary] = jsonResult["objects"] as? [NSDictionary] {
                        
                        for object: NSDictionary in objects {
                            for (name,value) in object {
                                print("\(name) , \(value)")
                            }
                        }
                    }
                } catch {}
            } catch {}
        }
        
        question = ""
        variantAnswers = ""
        rightAnswer = ""
        imageName = ""
    }
    
    func getQuizArray() -> [Quiz] {
        var quizArray: [Quiz] = []
        return quizArray
    }
    
}
