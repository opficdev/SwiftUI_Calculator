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
        [._0, .dot, .equal]
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
                            if viewModel.displayNum == "0" {
                                btnData[0][0] = .allClear
                            }
                            else {
                                btnData[0][0] = .clear
                            }
                        }
                        .onChange(of: viewModel.displayNum) { newValue in
                            if newValue == "0" {
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
                                Text(button.BtnDisplay)
                                    .padding(button == .some(._0) ? 30 : 0)
                                    .frame(width: button == .some(._0) ? 182 : 80, height: 80,
                                           alignment: button == .some(._0) ? .leading : .center)
                                    .background(button.backgroundColor)
                                    .cornerRadius(40)
                                    .foregroundColor(button.foregroundColor)
                                    .font(.system(size: button.backgroundColor == Color.orange ? 45 : 35,
                                                  weight: button == .some(.dot) || button.backgroundColor == Color.orange ? .medium : .regular))
                                    .padding(6)
                            }
                        }
                    }
                }
            }
        }
    }
}
