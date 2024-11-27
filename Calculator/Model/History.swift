//
//  History.swift
//  Calculator
//
//  Created by opfic on 11/24/24.
//

import Foundation

struct History: Hashable, Codable {
    var isChecked = false
    let historyExpr: String
    let displayExpr: String
    
    mutating func CheckToggle() {
        isChecked.toggle()
    }
}
