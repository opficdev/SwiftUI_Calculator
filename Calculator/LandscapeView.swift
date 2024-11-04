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
