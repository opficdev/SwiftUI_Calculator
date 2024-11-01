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
    case allClear,clear, oppo, perc
    case lbrac, rbrac, mc, m_add, m_sub, mr
    case sec, x2, x3, xy, ex, tenx
    case rev, x_2, x_3, x_y, ln, log10
    case xf, sin, cos, tan, e, EE
    case rad, sinh, cosh, tanh, pi, rand
    
    var BtnDisplay:String{
        switch self {
        case ._0:
            return "0"
        case ._1:
            return "1"
        case ._2:
            return "2"
        case ._3:
            return "3"
        case ._4:
            return "4"
        case ._5:
            return "5"
        case ._6:
            return "6"
        case ._7:
            return "7"
        case ._8:
            return "8"
        case ._9:
            return "9"
        case .dot:
            return "."
        case .equal:
            return "="
        case .add:
            return "+"
        case .sub:
            return "﹣"
        case .mul:
            return "×"
        case .div:
            return "÷"
        case .allClear:
            return "AC"
        case .clear:
            return "C"
        case .oppo:
            return "⁺⁄₋"
        case .perc:
            return "%"
        case .lbrac:
            return "("
        case .rbrac:
            return ")"
        case .mc:
            return "mc"
        case .m_add:
            return "m+"
        case .m_sub:
            return "m-"
        case .mr:
            return "mr"
        case .sec:
            return "2nd"
        case .x2:
            return "x²"
        case .x3:
            return "x³"
        case .xy:
            return "xʸ"
        case .ex:
            return "eˣ"
        case .tenx:
            return "10ˣ"
        case .rev:
            return "¹∕ｘ"
        case .x_2:
            return "²√ⅹ"
        case .x_3:
            return "³√ⅹ"
        case .x_y:
            return "ʸ√ⅹ"
        case .ln:
            return "ln"
        case .log10:
            return "log₁₀"
        case .xf:
            return "x!"
        case .sin:
            return "sin"
        case .cos:
            return "cos"
        case .tan:
            return "tan"
        case .e:
            return "e"
        case .EE:
            return "EE"
        case .rad:
            return "Rad"
        case .sinh:
            return "sinh"
        case .cosh:
            return "cosh"
        case .tanh:
            return "tanh"
        case .pi:
            return "π"
        case .rand:
            return "Rand"
        }
    }
    
    var backgroundColor:Color{
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
    
    var foregroundColor:Color{
        switch self{
        case .allClear,.clear,.oppo,.perc:
            return Color.black
        default:
            return Color.white
        }
    }
    var BtnSize:CGFloat{
        switch self{
        case ._0,._1,._2,._3,._4,._5,._6,._7,._8,._9,.dot,.allClear,.clear,.oppo,.perc:
            return CGFloat(20)
        case .add,.sub,.mul,.div,.equal:
            return CGFloat(30)
        default:
            return CGFloat(15)
        }
    }
}
