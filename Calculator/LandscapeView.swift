//
//  landscape.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//

import Foundation
import SwiftUI

struct Landscape: View {
    @EnvironmentObject var viewModel: CalculatorViewModel
    @State private var btnData: [[BtnType]] = [
        [.lbrac, .rbrac, .mc, .m_add, .m_sub, .mr, .allClear, .oppo, .perc, .div],
        [.sec, .x2, .x3, .xy, .ex, .tenx, ._7, ._8, ._9, .mul],
        [.rev, .x_2, .x_3, .x_y, .ln, .log10, ._4, ._5, ._6, .sub],
        [.xf, .sin, .cos, .tan, .e, .EE, ._1, ._2, ._3, .add],
        [.rad, .sinh, .cosh, .tanh, .pi, .rand, ._0, .dot, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer().frame(width: 10)
                    Text(viewModel.displayNum)
                        .frame(width: 750, height: 50, alignment: .trailing)
                        .font(.system(size: 50, weight: .regular))
                        .foregroundColor(Color.white)
                        .lineLimit(1)
                        .onAppear() {
                            if viewModel.displayNum == "0" {
                                btnData[0][6] = .allClear
                            }
                            else {
                                btnData[0][6] = .clear
                            }
                        }
                        .onChange(of: viewModel.displayNum) { newValue in
                            if newValue == "0" {
                                btnData[0][6] = .allClear
                            }
                            else {
                                btnData[0][6] = .clear
                            }
                        }
                }
                ForEach(btnData, id: \.self) { col in
                    HStack {
                        ForEach(col, id: \.self) { button in
                            Button {
                                viewModel.handleButtonPress(button)
                            } label: {
                                Text(button.BtnDisplay)
                                    .padding(button == .some(._0) ? 30 : 0)
                                    .frame(width: button == .some(._0) ? 150 : 68, height: 50,
                                           alignment: button == .some(._0) ? .leading : .center)
                                    .background(button.backgroundColor)
                                    .cornerRadius(25)
                                    .foregroundColor(button.foregroundColor)
                                    .font(.system(size: button.BtnSize, weight: .medium))
                                    .padding(.vertical, 3)
                            }
                        }
                    }
                }
            }
        }
    }
}


//struct Landscape: View{
//    @Binding var num:String //화면에 보여지는 수
//    @State private var btnData:[[BtnType]] = [
//        [.lbrac,.rbrac,.mc,.m_add,.m_sub,.mr,.allClear,.oppo,.perc,.div],
//        [.sec,.x2,.x3,.xy,.ex,.tenx,._7,._8,._9,.mul],
//        [.rev,.x_2,.x_3,.x_y,.ln,.log10,._4,._5,._6,.sub],
//        [.xf,.sin,.cos,.tan,.e,.EE,._1,._2,._3,.add],
//        [.rad,.sinh,.cosh,.tanh,.pi,.rand,._0,.dot,.equal]
//    ]
//    @EnvironmentObject var calc: Calculation
//    
//    var body:some View{
//        ZStack{
//            Color.black.ignoresSafeArea()
//            VStack{
//                HStack{
//                    Spacer().frame(width:10)
//                    Text(num)
//                        .frame(width:750,height:50,alignment:.trailing)
//                        .font(.system(size: 50,weight:.regular))
//                        .foregroundColor(Color.white)
//                        .lineLimit(1)
////                        .border(Color.white)
//                }
//                ForEach(btnData,id:\.self){col in
//                    HStack{
//                        ForEach(col,id:\.self){row in
//                            Button{
//                                if row == .lbrac{
//                                    
//                                }
//                                else if row == .rbrac{
//                                    
//                                }
//                                else if row == .mc{
//                                    
//                                }
//                                else if row == .m_add{
//                                    
//                                }
//                                else if row == .m_sub{
//                                    
//                                }
//                                else if row == .mr{
//                                    
//                                }
//                                else if row == .clear || row == .allClear{
//                                    btnData[0][6] = .allClear
//                                    num = calc.Clear()
//                                }
//                                else if row == .oppo{
//                                    num = calc.Opposite()
//                                }
//                                else if row == .perc{
//                                    num = calc.Percent()
//                                }
//                                else if row == .div{ //바로 계산
//                                    num = calc.Div()
//                                }
//                                else if row == .sec{
//                                    
//                                }
//                                else if row == .x2{
//                                    num = calc.X2()
//                                }
//                                else if row == .x3{
//                                    num = calc.X3()
//                                }
//                                else if row == .xy{
//                                    
//                                }
//                                else if row == .ex{
//                                    
//                                }
//                                else if row == .tenx{
//                                    
//                                }
//                                else if row == .mul{ //바로 계산
//                                    num = calc.Mul()
//                                }
//                                else if row == .rev{
//                                    
//                                }
//                                else if row == .x_2{
//                                    
//                                }
//                                else if row == .x_3{
//                                    
//                                }
//                                else if row == .x_y{
//                                    
//                                }
//                                else if row == .ln{
//                                    
//                                }
//                                else if row == .log10{
//                                    
//                                }
//                                else if row == .sub{
//                                    num = calc.Sub()
//                                }
//                                else if row == .xf{
//                                    
//                                }
//                                else if row == .sin{
//                                    
//                                }
//                                else if row == .cos{
//                                    
//                                }
//                                else if row == .tan{
//                                    
//                                }
//                                else if row == .e{
//                                    
//                                }
//                                else if row == .EE{
//                                    
//                                }
//                                else if row == .add{
//                                    num = calc.Add()
//                                }
//                                else if row == .rad{
//                                    
//                                }
//                                else if row == .sinh{
//                                    
//                                }
//                                else if row == .cosh{
//                                    
//                                }
//                                else if row == .tanh{
//                                    
//                                }
//                                else if row == .pi{
//                                    
//                                }
//                                else if row == .rand{
//                                    
//                                }
//                                else if row == .dot{
//                                    btnData[0][0] = .clear
//                                    num = calc.Dot()
//                                }
//                                else if row == .equal{
//                                    num = calc.Equal()
//                                }
//                                else{ //숫자키들 모음
//                                    btnData[0][0] = .clear
//                                    num = calc.setNum(newNum:row.BtnDisplay)
//                                }
//                            }label: {
//                                Text(row.BtnDisplay)
//                                    .padding(row == .some(._0) ? 30 : 0 )
//                                    .frame(width: row == .some(._0) ? 150 : 68, height:50,
//                                           alignment: row == .some(._0) ? .leading : .center)
//                                    .background(row.backgroundColor)
//                                    .cornerRadius(25)
//                                    .foregroundColor(row.foregroundColor)
//                                    .font(.system(size: row.BtnSize,
//                                                  weight: .medium))
//                                    .padding(3)
////                                    .border(Color.white)
//                            }
//                        }
//                    }
//                
//                }
//            }
//        }
//    }
//}

 
