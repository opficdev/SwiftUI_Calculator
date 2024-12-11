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
//                    .disabled()
                    ScrollView(.horizontal, showsIndicators: false) {
                        if calcVM.currentAC {   //  계산이 완료됨
                            if let answer = calcVM.displayExpr.first {
                                Text(calcVM.setNumberFmt(number: answer, round: true, portrait: true))
                                    .font(.system(size: 70))
                                    .foregroundColor(Color.white)
                            }
                        }
                        else {
                            HStack(spacing: 0) {
                                ForEach(Array(calcVM.displayExpr.reversed().enumerated()), id: \.offset) { index, element in
                                    Text(
                                        calcVM.setNumberFmt(
                                            number: element,
                                            round: calcVM.displayExpr.count > 1 && index == calcVM.displayExpr.endIndex - 1,
                                            portrait: true
                                        )
                                    )
                                    .font(.system(size: 70))
                                    .foregroundColor(Color.white)
                                }

                            }
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
//                    .disabled(calcVM.exprNumberCount(expr: calcVM.displayExpr) < 10)
                    VStack {
                        ForEach(btnData, id: \.self) { col in
                            HStack {
                                ForEach(col, id: \.self) { button in
                                    Button(action: {
                                        calcVM.handleButtonPress(button)
                                    }) {
                                        ButtonLabelView(button: button.BtnDisplay)  // size는 16 Pro 기준
                                            .frame(width: geometry.size.width / CGFloat(col.count) - 8,   // 8은 .padding()의 기본값
                                                   height: isScientific ? (geometry.size.height * 2) / (3 * CGFloat(btnData.count)) - 8 :
                                                    geometry.size.width / CGFloat(col.count) - 8,
                                                   alignment: .center
                                            )
                                            .background(button.backgroundColor)
                                            .cornerRadius(geometry.size.width / CGFloat(col.count) - 8)
                                            .foregroundColor(Color.white)
                                            .font(.system(size: (isScientific ? (geometry.size.height * 2) / (3 * CGFloat(btnData.count)) - 8 :
                                                                    geometry.size.width / CGFloat(col.count) - 8) * 0.4)
                                            )
                                    }
                                    .simultaneousGesture(
                                        LongPressGesture(minimumDuration: 0.5)
                                            .onEnded { _ in
                                                if button == BtnType.clear {
                                                    calcVM.handleButtonPress(BtnType.allClear)
                                            }
                                        }
                                    )
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
