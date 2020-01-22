//
//  Taskinfo.swift
//  Sumandeep_C0764942_lab2
//
//  Created by MacStudent on 2020-01-21.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import Foundation

class Taskinfo {
    internal init(name: String, days: Int,date:String) {
        self.name = name
        self.days = days
        self.date = date
    }
    
    var name:String
    var days:Int
    var date:String
    var countDays = 0
}
