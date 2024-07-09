//
//  landscape.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//

import Foundation
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


struct Landscape: View{
    @State var num:String = "0" //화면에 보여지는 수
    @State private var btnData:[[BtnType]] = [
        [.lbrac,.rbrac,.mc,.m_add,.m_sub,.mr,.allClear,.oppo,.perc,.div],
        [.sec,.x2,.x3,.xy,.ex,.tenx,._7,._8,._9,.mul],
        [.rev,.x_2,.x_3,.x_y,.ln,.log10,._4,._5,._6,.sub],
        [.xf,.sin,.cos,.tan,.e,.EE,._1,._2,._3,.add],
        [.rad,.sinh,.cosh,.tanh,.pi,.rand,._0,.dot,.equal]
    ]
    
    var body:some View{
        ZStack{
            Color.black.ignoresSafeArea()
            VStack{
                HStack{
                    Spacer().frame(width:10)
                    Text(num)
                        .frame(width:750,height:50,alignment:.trailing)
                        .font(.system(size: 50,weight:.regular))
                        .foregroundColor(Color.white)
                        .lineLimit(1)
//                        .border(Color.white)
                }
                ForEach(btnData,id:\.self){col in
                    HStack{
                        ForEach(col,id:\.self){row in
                            Button{
                                if row == .lbrac{
                                    
                                }
                                else if row == .rbrac{
                                    
                                }
                                else if row == .mc{
                                    
                                }
                                else if row == .m_add{
                                    
                                }
                                else if row == .m_sub{
                                    
                                }
                                else if row == .mr{
                                    
                                }
                                else if row == .clear || row == .allClear{
                                    btnData[0][6] = .allClear
                                    num = Calculation.Clear()
                                }
                                else if row == .oppo{
                                    num = Calculation.Opposite()
                                }
                                else if row == .perc{
                                    num = Calculation.Percent()
                                }
                                else if row == .div{ //바로 계산
                                    num = Calculation.Div()
                                }
                                else if row == .sec{
                                    
                                }
                                else if row == .x2{
                                    num = Calculation.X2()
                                }
                                else if row == .x3{
                                    num = Calculation.X3()
                                }
                                else if row == .xy{
                                    
                                }
                                else if row == .ex{
                                    
                                }
                                else if row == .tenx{
                                    
                                }
                                else if row == .mul{ //바로 계산
                                    num = Calculation.Mul()
                                }
                                else if row == .rev{
                                    
                                }
                                else if row == .x_2{
                                    
                                }
                                else if row == .x_3{
                                    
                                }
                                else if row == .x_y{
                                    
                                }
                                else if row == .ln{
                                    
                                }
                                else if row == .log10{
                                    
                                }
                                else if row == .sub{
                                    num = Calculation.Sub()
                                }
                                else if row == .xf{
                                    
                                }
                                else if row == .sin{
                                    
                                }
                                else if row == .cos{
                                    
                                }
                                else if row == .tan{
                                    
                                }
                                else if row == .e{
                                    
                                }
                                else if row == .EE{
                                    
                                }
                                else if row == .add{
                                    num = Calculation.Add()
                                }
                                else if row == .rad{
                                    
                                }
                                else if row == .sinh{
                                    
                                }
                                else if row == .cosh{
                                    
                                }
                                else if row == .tanh{
                                    
                                }
                                else if row == .pi{
                                    
                                }
                                else if row == .rand{
                                    
                                }
                                else if row == .dot{
                                    if !num.contains(".") && num != "오류"{
                                        btnData[0][0] = .clear
                                        num = Calculation.Dot()
                                    }
                                }
                                else if row == .equal{
                                    num = Calculation.Equal()
                                }
                                else{ //숫자키들 모음
                                    
                                }
                            }label: {
                                Text(row.BtnDisplay)
                                    .padding(row == .some(._0) ? 30 : 0 )
                                    .frame(width: row == .some(._0) ? 150 : 68, height:50,
                                           alignment: row == .some(._0) ? .leading : .center)
                                    .background(row.backgroundColor)
                                    .cornerRadius(25)
                                    .foregroundColor(row.foregroundColor)
                                    .font(.system(size: row.BtnSize,
                                                  weight: .medium))
                                    .padding(3)
//                                    .border(Color.white)
                            }
                        }
                    }
                
                }
            }
        }
    }
}


struct Previews_landscape_Previews: PreviewProvider {
    static var previews: some View {
        return Landscape().previewLayout(.fixed(width: 896, height: 414))
    
        
    }
}
 
