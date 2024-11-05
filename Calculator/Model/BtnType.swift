//
//  BtnType.swift
//  Calculator
//
//  Created by 최윤진 on 10/31/24.
//

import SwiftUI

enum BtnType{
    case _1, _2, _3, _4, _5, _6, _7, _8, _9, _0
    case dot, equal, add, sub, mul, div
    case allClear, clear, oppo, perc
    case lbrac, rbrac, mc, m_add, m_sub, mr
    case sec, x2, x3, xy, ex, tenx
    case rev, x_2, x_3, x_y, ln, log10
    case xf, sin, cos, tan, e, EE
    case rad, sinh, cosh, tanh, pi, rand
    case emoji
    
    var BtnDisplay: button {
        switch self {
        case ._0:
            return button(string: "0")
        case ._1:
            return button(string: "1")
        case ._2:
            return button(string: "2")
        case ._3:
            return button(string: "3")
        case ._4:
            return button(string: "4")
        case ._5:
            return button(string: "5")
        case ._6:
            return button(string: "6")
        case ._7:
            return button(string: "7")
        case ._8:
            return button(string: "8")
        case ._9:
            return button(string: "9")
        case .dot:
            return button(string: ".")
        case .equal:
            return button(image: "equal")
        case .add:
            return button(image: "plus")
        case .sub:
            return button(image: "minus")
        case .mul:
            return button(image: "multiply")
        case .div:
            return button(image: "divide")
        case .allClear:
            return button(string: "AC")
        case .clear:
            return button(image: "delete.backward")
        case .oppo:
            return button(image: "plus.forwardslash.minus")
        case .perc:
            return button(image: "percent")
        case .lbrac:
            return button(string: "(")
        case .rbrac:
            return button(string: ")")
        case .mc:
            return button(string: "mc")
        case .m_add:
            return button(string: "m+")
        case .m_sub:
            return button(string: "m-")
        case .mr:
            return button(string: "mr")
        case .sec:
            return button(string: "2nd")
        case .x2:
            return button(string: "x²")
        case .x3:
            return button(string: "x³")
        case .xy:
            return button(string: "xʸ")
        case .ex:
            return button(string: "𝑒ˣ")
        case .tenx:
            return button(string: "10ˣ")
        case .rev:
            return button(string: "¹∕ｘ")
        case .x_2:
            return button(string: "²√ⅹ")
        case .x_3:
            return button(string: "³√ⅹ")
        case .x_y:
            return button(string: "ʸ√ⅹ")
        case .ln:
            return button(string: "ln")
        case .log10:
            return button(string: "log₁₀")
        case .xf:
            return button(string: "x!")
        case .sin:
            return button(string: "sin")
        case .cos:
            return button(string: "cos")
        case .tan:
            return button(string: "tan")
        case .e:
            return button(string: "𝑒")
        case .EE:
            return button(string: "EE")
        case .rad:
            return button(string: "Rad")
        case .sinh:
            return button(string: "sinh")
        case .cosh:
            return button(string: "cosh")
        case .tanh:
            return button(string: "tanh")
        case .pi:
            return button(string: "π")
        case .rand:
            return button(string: "Rand")
        case .emoji:
            return button(image: "circle.grid.3x3.fill") // 계산기 SF Symbols가 없음
        }
    }
    
    var backgroundColor: Color{
        switch self{
        case ._0,._1,._2,._3,._4,._5,._6,._7,._8,._9,.dot:
            return Color("numBtn")
        case .allClear,.clear,.oppo,.perc:
            return Color.gray
        case .add,.sub,.mul,.div,.equal:
            return Color.orange
        default:
            return Color("elseBtn")
        }
    }
    
    var BtnSize: CGFloat{
        switch self{
        case ._0,._1,._2,._3,._4,._5,._6,._7,._8,._9,.dot,.allClear,.clear,.oppo,.perc:
            return CGFloat(20)
        case .add,.sub,.mul,.div,.equal:
            return CGFloat(25)
        default:
            return CGFloat(15)
        }
    }
}

struct button {
    let string: String?
    let image: Image?
    
    init(string: String? = nil, image: String? = nil) {
        self.string = string
        if let image = image {
            self.image = Image(systemName: image)
        } else {
            self.image = nil
        }
    }
}

