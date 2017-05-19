//
//  Helper.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 4/12/17.
//  Copyright © 2017 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

// \u{2B50} = ⭐️
// \u{1F947} = 🥇
// \u{1F948} = 🥈

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
    let redColor = UIColor(red:1.000, green:0.043, blue:0.000, alpha:1.0) // ff0b00
    let blueColor = UIColor(red:0.000, green:0.769, blue:1.000, alpha:1.0) // 00c4ff
    let pinkColor = UIColor(red: 0.988, green: 0.000, blue: 1.000, alpha: 1.0) // fc00ff
    let perpleColor = UIColor(red: 0.557, green: 0.263, blue: 0.906, alpha: 1.0) // 8e43e7
    let greyColor = UIColor(red:0.592, green:0.592, blue:0.592, alpha:1.0) // 979797
}

// FIXME: Use animagion from project "SpringAndBlurDemo" for show and hight popupViews!
