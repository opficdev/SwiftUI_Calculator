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
    case _2nd, x2, x3, xy, ex, tenx
    case rev, x_2, x_3, x_y, ln, log10
    case xf, sin, cos, tan, e, EE
    case rad, sinh, cosh, tanh, pi, rand, deg
    case emoji
    
    var BtnDisplay: CalcButton {
        switch self {
        case ._0:
            return CalcButton(string: "0")
        case ._1:
            return CalcButton(string: "1")
        case ._2:
            return CalcButton(string: "2")
        case ._3:
            return CalcButton(string: "3")
        case ._4:
            return CalcButton(string: "4")
        case ._5:
            return CalcButton(string: "5")
        case ._6:
            return CalcButton(string: "6")
        case ._7:
            return CalcButton(string: "7")
        case ._8:
            return CalcButton(string: "8")
        case ._9:
            return CalcButton(string: "9")
        case .dot:
            return CalcButton(string: ".")
        case .equal:
            return CalcButton(image: "equal")
        case .add:
            return CalcButton(string: "+", image: "plus")
        case .sub:
            return CalcButton(string: "-", image: "minus")
        case .mul:
            return CalcButton(string: "×", image: "multiply")
        case .div:
            return CalcButton(string: "÷", image: "divide")
        case .allClear:
            return CalcButton(string: "AC")
        case .clear:
            return CalcButton(image: "delete.backward")
        case .oppo:
            return CalcButton(image: "plus.forwardslash.minus")
        case .perc:
            return CalcButton(image: "percent")
        case .lbrac:
            return CalcButton(string: "(")
        case .rbrac:
            return CalcButton(string: ")")
        case .mc:
            return CalcButton(string: "mc")
        case .m_add:
            return CalcButton(string: "m+")
        case .m_sub:
            return CalcButton(string: "m-")
        case .mr:
            return CalcButton(string: "mr")
        case ._2nd:
            return CalcButton(string: "2nd")
        case .x2:
            return CalcButton(string: "x²")
        case .x3:
            return CalcButton(string: "x³")
        case .xy:
            return CalcButton(string: "xʸ")
        case .ex:
            return CalcButton(string: "𝑒ˣ")
        case .tenx:
            return CalcButton(string: "10ˣ")
        case .rev:
            return CalcButton(string: "¹∕ｘ")
        case .x_2:
            return CalcButton(string: "²√ⅹ")
        case .x_3:
            return CalcButton(string: "³√ⅹ")
        case .x_y:
            return CalcButton(string: "ʸ√ⅹ")
        case .ln:
            return CalcButton(string: "ln")
        case .log10:
            return CalcButton(string: "log₁₀")
        case .xf:
            return CalcButton(string: "x!")
        case .sin:
            return CalcButton(string: "sin")
        case .cos:
            return CalcButton(string: "cos")
        case .tan:
            return CalcButton(string: "tan")
        case .e:
            return CalcButton(string: "𝑒")
        case .EE:
            return CalcButton(string: "EE")
        case .rad:
            return CalcButton(string: "Rad")
        case .sinh:
            return CalcButton(string: "sinh")
        case .cosh:
            return CalcButton(string: "cosh")
        case .tanh:
            return CalcButton(string: "tanh")
        case .pi:
            return CalcButton(string: "π")
        case .rand:
            return CalcButton(string: "Rand")
        case .deg:
            return CalcButton(string: "Deg")
        case .emoji:
            return CalcButton(image: "circle.grid.3x3.fill") // 계산기 SF Symbols가 없음
        }
    }
    
    var backgroundColor: Color{
        switch self{
        case ._0,._1,._2,._3,._4,._5,._6,._7,._8,._9,.dot,.emoji:
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

struct CalcButton: Equatable {
    let string: String?
    let image: Image?
    
    init(string: String? = nil, image: String? = nil) {
        self.string = string
        if let image = image {
            self.image = Image(systemName: image)
        }
        else {
            self.image = nil
        }
    }
}

