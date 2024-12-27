//
//  Token.swift
//  Calculator
//
//  Created by opfic on 12/23/24.
//
//  수식을 구성하는 토큰을 정의

import Foundation

struct Token: Codable, Hashable {
    var value: String
    var automatic: Bool //  수식의 구조 때문에 자동으로 추가되었는지(true: 식에 회색으로 처리)
    
    init(id: UUID = UUID(), value: String, automatic: Bool = false) {
        self.value = value
        self.automatic = automatic
    }
}
