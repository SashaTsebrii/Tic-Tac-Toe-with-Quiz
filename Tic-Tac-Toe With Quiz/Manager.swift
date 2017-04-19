//
//  Manager.swift
//  Tic-Tac-Toe With Quiz
//
//  Created by Aleksandr Tsebrii on 11/11/16.
//  Copyright © 2016 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class Manager: NSObject {
    
    static let SharedManager = Manager()
    
    
    func getJSON(fileName: String) -> [Array<String>] {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    if let objects: [NSDictionary] = jsonResult["objects"] as? [NSDictionary] {
                        for object: NSDictionary in objects {
                            for (name,value) in object {
                                print("\(name) , \(value)")
                            }
                            if let rows: [NSArray] = object["rows"] as? [NSArray] {
                                return rows as! [Array]
                            }
                        }
                    }
                } catch {
                    print("No 'jsonData'")
                }
            } catch {
                print("No 'path'")
            }
        }
        return []
    }
    
}
