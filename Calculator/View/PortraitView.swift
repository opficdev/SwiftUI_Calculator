//
//  PortraitView.swift
//  Calculator
//
//  Created by opfic on 11/18/24.
//

import SwiftUI
import UIKit

struct PortraitView: View {
    @EnvironmentObject var calcVM: CalculatorViewModel
    @Binding var isScientific: Bool
    @State private var btnData: [[BtnType]] = []
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            Text(calcVM.historyExpr.joined())
                                .font(.system(size: 40))
                                .foregroundColor(Color.gray)
                            
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)   //  ScrollView를 우측에서 좌측으로
                    .disabled(true)
                    ScrollView(.horizontal, showsIndicators: false) {
                        if calcVM.currentAC {   //  계산이 완료됨
                            if let answer = calcVM.displayExpr.first {
                                Text(calcVM.setNumberFmt(string: answer, scale: 10, style: .decimal))  //  우선 .decimal 로만
                                    .font(.system(size: 70))
                                    .foregroundColor(Color.white)
                            }
                        }
                        else {
                            HStack(spacing: 0) {
                                ForEach(calcVM.displayExpr.reversed(), id: \.self) { element in
                                    Text(calcVM.setNumberFmt(string: element, style: .decimal))
                                        .font(.system(size: 70))
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
//                    .disabled()    //  조건은 생각해 봐야함
                    VStack {
                        ForEach(btnData, id: \.self) { col in
                            HStack {
                                ForEach(col, id: \.self) { button in
                                    Button(action: {
                                        calcVM.handleButtonPress(button)
                                    }) {
                                        ButtonLabelView(button: button.BtnDisplay)  // size는 16 Pro 기준
                                            .frame(width: geometry.size.width / CGFloat(col.count) - 8,   // 8은 .padding()의 기본값
                                                   height: isScientific ? (geometry.size.height * 2) / (3 * CGFloat(btnData.count)) - 8 : geometry.size.width / CGFloat(col.count) - 8,
                                                   alignment: .center)
                                            .background(button.backgroundColor)
                                            .cornerRadius(geometry.size.width / CGFloat(col.count) - 8)
                                            .foregroundColor(Color.white)
                                            .font(.system(size: isScientific ? 20 : 35))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                btnData = isScientific ? scientificBtn + portraitBtn : portraitBtn
                btnData[isScientific ? 5 : 0][0] = calcVM.currentAC ? .allClear : .clear
            }
            .onChange(of: calcVM.currentAC) { newValue in
                if newValue {
                    btnData[isScientific ? 5 : 0][0] = .allClear
                }
                else {
                    btnData[isScientific ? 5 : 0][0] = .clear
                }
            }
        }
    }
}

#Preview {
    PortraitView(isScientific: .constant(false))
        .environmentObject(CalculatorViewModel())
}
