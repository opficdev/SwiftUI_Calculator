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
    @State private var btnData: [[BtnType]] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer()
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(calcVM.historyExpr.joined())
                            .font(.system(size: calcVM.btnSize * 0.7))
                            .foregroundStyle(Color.gray)
                            .scaleEffect(x: -1, y: 1) // 텍스트 다시 반전
                    }
                    .frame(height: calcVM.btnSize * 0.7)  //  ScrollView 내부 Text와 크기 같을 것
                    .scaleEffect(x: -1, y: 1)
//                    .disabled()
                    ScrollView(.horizontal, showsIndicators: false) {
                        if calcVM.currentAC {   //  계산이 완료됨
                            if let answer = calcVM.displayExpr.first {
                                Text(calcVM.setNumberFmt(number: answer, round: true, portrait: true))
                                    .font(.system(size: calcVM.btnSize))
                                    .foregroundStyle(Color.white)
                                    .scaleEffect(x: -1, y: 1) // 텍스트 다시 반전
                            }
                        }
                        else {
                            HStack(spacing: 0) {
                                ForEach(Array(calcVM.displayExpr.enumerated()), id: \.offset) { index, element in
                                    Text(
                                        calcVM.setNumberFmt(
                                            number: element,
                                            round: calcVM.displayExpr.count > 1 && index == calcVM.displayExpr.endIndex - 1,
                                            portrait: true
                                        )
                                    )
                                    .font(.system(size: calcVM.btnSize))
                                    .foregroundStyle(Color.white)
                                }
                                if !calcVM.bracketCorrection() {
                                    Text(String(repeating: ")", count: calcVM.rbracketAddCount))
                                        .font(.system(size: calcVM.btnSize))
                                        .foregroundStyle(Color.gray)
                                }
                            }
                            .scaleEffect(x: -1, y: 1) // 텍스트 다시 반전
                        }
                    }
                    .scaleEffect(x: -1, y: 1)
//                    .disabled()
                    VStack {
                        ForEach(btnData, id: \.self) { col in
                            HStack {
                                ForEach(col, id: \.self) { button in
                                    Button(action: {
                                        calcVM.handleButtonPress(button)
                                    }) {
                                        ButtonLabelView(button: button.BtnDisplay)
                                            .frame(width: geometry.size.width / CGFloat(col.count) - 8,   // 8은 .padding()의 기본값
                                                   height: calcVM.scientific ? (geometry.size.height * 2) / (3 * CGFloat(btnData.count)) - 8 :
                                                    geometry.size.width / CGFloat(col.count) - 8,
                                                   alignment: .center
                                            )
                                            .background(calcVM.modeOn && button == BtnType.emoji ? Color.clear : button.backgroundColor)
                                            .cornerRadius(geometry.size.width / CGFloat(col.count) - 8)
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: (calcVM.scientific ? (geometry.size.height * 2) / (3 * CGFloat(btnData.count)) - 8 :
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
                                    .onAppear {
                                        calcVM.btnSize = geometry.size.width / CGFloat(col.count) - 16
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    btnData = calcVM.scientific ? scientificBtn + portraitBtn : portraitBtn
                    btnData[calcVM.scientific ? 5 : 0][0] = calcVM.currentAC ? .allClear : .clear
                }
                .onChange(of: calcVM.currentAC) { newValue in
                    if newValue {
                        btnData[calcVM.scientific ? 5 : 0][0] = .allClear
                    }
                    else {
                        btnData[calcVM.scientific ? 5 : 0][0] = .clear
                    }
                }
            }
        }
    }
}

