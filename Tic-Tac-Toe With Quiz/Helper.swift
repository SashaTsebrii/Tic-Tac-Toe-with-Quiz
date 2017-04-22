//
//  Helper.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 4/12/17.
//  Copyright © 2017 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

//\u{2B50}\u{1F947}\u{1F948}

let NOT_TO_DO = true
/*
 #if NOT_TO_DO
     // not to do
 #else
     // to do
 #endif
*/

struct Constants {
    static let scoreArray = "scoreArray"
    static let jsonFile = "quiz"
}

class Helper: NSObject {
    let redColor = UIColor(red:1.000, green:0.043, blue:0.000, alpha:1.0)
    let blueColor = UIColor(red:0.000, green:0.769, blue:1.000, alpha:1.0)
    let greenColor = UIColor(red:0.498, green:0.733, blue:0.000, alpha:1.0)
    let yellowColor = UIColor(red:1.000, green:0.725, blue:0.000, alpha:1.0)
    let greyColor = UIColor(red:0.639, green:0.639, blue:0.639, alpha:1.0)
}
