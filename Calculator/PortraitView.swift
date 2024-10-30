//
//  Portrait.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//

import Foundation
import SwiftUI

struct Portrait: View{
    @Binding var num: String //화면에 보여지는 수
    @State private var btnData: [[BtnType]] = [
        [.allClear,.oppo,.perc,.div],
        [._7,._8,._9,.mul],
        [._4,._5,._6,.sub],
        [._1,._2,._3,.add],
        [._0,.dot,.equal]
    ]
    @EnvironmentObject var calc: Calculation
        
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                Spacer().frame(maxHeight:200)
                HStack {
                    Text(num)
                        .frame(maxWidth:350,maxHeight:100,alignment:.trailing)
                        .font(.system(size: 90,weight:.light))
                        .foregroundColor(Color.white)
                        .minimumScaleFactor(0.65)
                        .lineLimit(1)
                }
                ForEach(btnData,id: \.self){col in
                    HStack{
                        ForEach(col,id: \.self) {row in
                            Button{
                                let numFmt1 = NumberFormatter()
                                numFmt1.numberStyle = .decimal //지수 형태 변환 (가로 모드)
                                if row == .clear || row == .allClear{
                                    btnData[0][0] = .allClear
                                    num = calc.Clear()
                                }
                                else if row == .oppo{
                                    num = calc.Opposite()
                                }
                                else if row == .perc{
                                    num = calc.Percent()
                                }
                                else if row == .add{
                                    num = calc.Add()
                                }
                                else if row == .sub{
                                    num = calc.Sub()
                                }
                                else if row == .mul{
                                    num = calc.Mul()
                                }
                                else if row == .div{ 
                                    num = calc.Div()
                                }
                                else if row == .equal{
                                    num = calc.Equal()
                                }
                                else if row == .dot{
                                    btnData[0][0] = .clear
                                    num = calc.Dot()
                                }
                                else{ //숫자키들 모음
                                    btnData[0][0] = .clear
                                    num = calc.setNum(newNum:row.BtnDisplay)
                                }
                            }label: {
                                Text(row.BtnDisplay)
                                    .padding(row == .some(._0) ? 30 : 0 )
                                    .frame(width: row == .some(._0) ? 182 : 80, height:80,
                                           alignment: row == .some(._0) ? .leading : .center)
                                    .background(row.backgroundColor)
                                    .cornerRadius(40)
                                    .foregroundColor(row.foregroundColor)
                                    .font(.system(size: row.backgroundColor == Color.orange ? 45 : 35,
                                                  weight: row == .some(.dot) || row.backgroundColor == Color.orange ? .medium : .regular))
                                    .padding(6)
//                                    .border(Color.white)
                            }
                        }
                    }
                }
            }
        }
    }
}
