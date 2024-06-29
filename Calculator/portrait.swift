//
//  Portrait.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//

import Foundation
import SwiftUI

struct Portrait: View{
    @State var num:String = numCalc.num //화면에 보여지는 수

    @State private var btnData:[[BtnType]] = [
        [.allClear,.oppo,.perc,.div],
        [._7,._8,._9,.mul],
        [._4,._5,._6,.sub],
        [._1,._2,._3,.add],
        [._0,.dot,.equal]]
    
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
//                        .border(Color.white)
                }
                ForEach(btnData,id:\.self){col in
                    HStack{
                        ForEach(col,id: \.self) {row in
                            Button{
                                let numFmt1 = NumberFormatter()
                                numFmt1.numberStyle = .decimal //지수 형태 변환 (가로 모드)
                                if row == .clear || row == .allClear{
                                    btnData[0][0] = .allClear
                                    num = numCalc.Clear()
                                }
                                else if row == .oppo{ //문제
                                    num = numCalc.Opposite()
                                }
                                else if row == .perc{
                                    num = numCalc.Percent()
                                }
                                else if row == .add{
                                    num = numCalc.Add()
                                }
                                else if row == .sub{
                                    num = numCalc.Sub()
                                }
                                else if row == .mul{ //바로 계산
                                    num = numCalc.Mul()
                                }
                                else if row == .div{ //바로 계산
                                    num = numCalc.Div()
                                }
                                else if row == .equal{
                                    num = numCalc.Equal()
                                }
                                else if row == .dot{
                                    if !num.contains(".") && num != "오류"{
                                        btnData[0][0] = .clear
                                        num = numCalc.Dot()
                                    }
                                }
                                else{ //숫자키들 모음
                                    num = numCalc.setNum(newNum:row.BtnDisplay)
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

struct Previews_portrait_Previews: PreviewProvider {
    static var previews: some View {
        return Portrait()
    }
}
