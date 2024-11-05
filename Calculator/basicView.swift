//
//  Portrait.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//

import SwiftUI

struct Portrait: View {
    @EnvironmentObject var viewModel: CalculatorViewModel
    @State private var btnData: [[BtnType]] = [
        [.allClear, .oppo, .perc, .div],
        [._7, ._8, ._9, .mul],
        [._4, ._5, ._6, .sub],
        [._1, ._2, ._3, .add],
        [.emoji, ._0, .dot, .equal]
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Spacer().frame(maxHeight: 200)
                HStack {
                    Text(viewModel.displayNum)
                        .frame(maxWidth: 350, maxHeight: 100, alignment: .trailing)
                        .font(.system(size: 90, weight: .light))
                        .foregroundColor(Color.white)
                        .minimumScaleFactor(0.65)
                        .lineLimit(1)
                        .onAppear() {
                            if viewModel.currentAC {
                                btnData[0][0] = .allClear
                            }
                            else {
                                btnData[0][0] = .clear
                            }
                        }
                        .onChange(of: viewModel.currentAC) { newValue in
                            if newValue {
                                btnData[0][0] = .allClear
                            }
                            else {
                                btnData[0][0] = .clear
                            }
                        }
                }
                ForEach(btnData, id: \.self) { col in
                    HStack {
                        ForEach(col, id: \.self) { button in
                            Button(action: {
                                viewModel.handleButtonPress(button)
                            }) {
                                ButtonLabelView(button: button.BtnDisplay)
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .background(button.backgroundColor)
                                    .cornerRadius(40)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 35))
                                    .padding(6)
                            }
                            .onLongPressGesture() {} onPressingChanged: { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    if let buttonImage = button.BtnDisplay.image,
                                        buttonImage == Image(systemName: "delete.backward") {
                                        btnData[0][0] = .allClear
                                        viewModel.handleButtonPress(.allClear)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
