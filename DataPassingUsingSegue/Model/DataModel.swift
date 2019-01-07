//
//  DataModel.swift
//  DataPassingUsingSegue
//
//  Created by Yagnik Suthar on 04/01/19.
//  Copyright © 2019 ecosmob. All rights reserved.
//

import UIKit

class DataModel:NSCoder {
    
    // WS KEYS
    private let Name            = "name"
    private let Age             = "desc"
    private let Date            = "date"
  
    var name        : String = ""
    var age         : String = ""
    var date        : String = ""
    
    init?(dictionary:[String : Any?]) {
        
        if let tempUserName = dictionary[Name] as? String, tempUserName.count > 0 {
            name = tempUserName
        }else {return nil}
        
        if let tempAge = dictionary[Age] as? String, tempAge.count > 0 {
            age = tempAge
        }
        
        if let tempDate = dictionary[Date] as? String, tempDate.count > 0 {
            date = tempDate
        }
    }
}
