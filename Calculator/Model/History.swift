//
//  History.swift
//  Calculator
//
//  Created by opfic on 11/24/24.
//

import Foundation

struct History: Hashable, Codable {
    let id: UUID
    var isChecked = false
    let historyExpr: [Token]
    let displayExpr: [Token]
    
    init(id: UUID, isChecked: Bool = false, historyExpr: [Token], displayExpr: [Token]) {
        self.id = id
        self.isChecked = isChecked
        self.historyExpr = historyExpr
        self.displayExpr = displayExpr
    }
    
    mutating func CheckToggle() {
        isChecked.toggle()
    }
}
