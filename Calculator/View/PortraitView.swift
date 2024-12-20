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
    @State private var btnData: [[BtnType]] = portraitBtn
    @State private var historyWidth: CGFloat = 0
    @State private var displayWidth: CGFloat = 0
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer()
                    HStack(alignment:. bottom, spacing: 0) {
                        if calcVM.scientific {
                            Text("Rad") // 우선 Rad로 고정.
                                .foregroundStyle(Color.white)
                        }
                        VStack(spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                if calcVM.currentAC {
                                    Text(calcVM.historyExpr.joined())
                                        .font(.system(size: calcVM.btnSize * 0.5))  // 얘도 수정이 있긴 해야하는데 displayExpr보다는 변화량이 작음
                                        .foregroundStyle(Color.gray)
                                        .scaleEffect(x: -1, y: 1) // 텍스트 다시 반전
                                        .background(
                                            GeometryReader { geo in
                                                Color.clear
                                                    .onAppear {
                                                        historyWidth = geo.size.width
                                                }
                                                    .onChange(of: calcVM.displayExpr) { _ in
                                                        historyWidth = geo.size.width
                                                }
                                            }
                                        )
                                        .onTapGesture {
                                            calcVM.currentAC = false
                                        }
                                }
                            }
                            .frame(height: calcVM.btnSize * 0.7)  //  ScrollView 내부 Text와 크기 같을 것
                            .scaleEffect(x: -1, y: 1)
                            .disabled(calcVM.scrollUnavailable(innerWidth: historyWidth, outerWidth: geometry.size.width))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    if calcVM.currentAC {   //  계산이 완료됨
                                        if let answer = calcVM.displayExpr.first {
                                            Text(calcVM.setNumberFmt(number: answer, round: true, portrait: true))
                                                .font(.system(size: calcVM.btnSize))
                                                .foregroundStyle(Color.white)
                                        }
                                    }
                                    else {
                                        ForEach(Array(calcVM.displayExpr.enumerated()), id: \.offset) { index, element in
                                            Text(calcVM.setNumberFmt(
                                                number: element,
                                                round: !calcVM.historyExpr.isEmpty && calcVM.displayExpr.count > 1 && index == 0,
                                                portrait: true
                                            ))
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: calcVM.btnSize))
                                            
                                        }
                                        if !calcVM.bracketCorrection() {
                                            Text(String(repeating: ")", count: calcVM.rbracketAddCount))
                                                .foregroundStyle(Color.gray)
                                                .font(.system(size: calcVM.btnSize))
                                        }
                                    }
                                }
                                .frame(height: calcVM.btnSize)
                                .scaleEffect(x: -1, y: 1) // 텍스트 다시 반전
                                .background(
                                    GeometryReader { geo in
                                        Color.clear
                                            .onAppear {
                                                displayWidth = geo.size.width
                                        }
                                            .onChange(of: calcVM.displayExpr) { _ in
                                                displayWidth = geo.size.width
                                        }
                                    }
                                )
                            }
                            .scaleEffect(x: -1, y: 1)
                            .disabled(calcVM.scrollUnavailable(innerWidth: displayWidth, outerWidth: geometry.size.width))
                        }
                    }
                    .padding(.bottom)
                    
                    VStack {
                        if calcVM.scientific {
                            ForEach(scientificBtn, id: \.self) { col in
                                HStack {
                                    ForEach(col, id: \.self) { button in
                                        Button(action: {
                                            calcVM.handleButtonPress(button)
                                        }) {
                                            ButtonLabelView(button: button.BtnDisplay)
                                                .frame(width: geometry.size.width / CGFloat(col.count) - 8,   // 8은 .padding()의 기본값
                                                       height: geometry.size.height / CGFloat(btnData.count) * 0.3,
                                                       alignment: .center
                                                )
                                                .background(calcVM.modeOn && button == BtnType.emoji ? Color.clear : button.backgroundColor)
                                                .cornerRadius(geometry.size.width / CGFloat(col.count) - 8)
                                                .foregroundStyle(Color.white)
                                                .font(.system(size: 13))    // 얘는 어차피 공학 모드일때만 나와서 고정함
                                        }
                                    }
                                }
                            }
                        }
                        ForEach(btnData, id: \.self) { col in
                            HStack {
                                ForEach(col, id: \.self) { button in
                                    Button(action: {
                                        calcVM.handleButtonPress(button)
                                    }) {
                                        ButtonLabelView(button: button.BtnDisplay)
                                            .frame(width: geometry.size.width / CGFloat(col.count) - 8,   // 8은 .padding()의 기본값
                                                   height: calcVM.scientific ? geometry.size.height / CGFloat(btnData.count) * 0.3 :
                                                    geometry.size.width / CGFloat(col.count) - 8,
                                                   alignment: .center
                                            )
                                            .background(calcVM.modeOn && button == BtnType.emoji ? Color.clear : button.backgroundColor)
                                            .cornerRadius(geometry.size.width / CGFloat(col.count) - 8)
                                            .foregroundStyle(Color.white)
                                            .font(.system(size: (calcVM.scientific ? 17 : geometry.size.width * 0.5 / CGFloat(col.count) - 8)))
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
                .onChange(of: calcVM.currentAC) { newValue in
                    if newValue {
                        btnData[0][0] = .allClear
                    }
                    else {
                        btnData[0][0] = .clear
                    }
                }
            }
        }
    }
}

