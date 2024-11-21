//
//  PortraitView.swift
//  Calculator
//
//  Created by opfic on 11/18/24.
//

import SwiftUI
import UIKit

struct PortraitView: View {
    @EnvironmentObject var viewModel: CalculatorViewModel
    @Binding var isScientific: Bool
    @State private var btnData: [[BtnType]] = []
    private let WIDTH = iPhonePointRes.currentDeviceWidth() ?? 0
    private let HEIGHT = iPhonePointRes.currentDeviceHeight() ?? 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                Text(viewModel.history)
                    .font(.system(size: 60))
                    .foregroundColor(Color.gray)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                Text(viewModel.displayExpr)
                    .font(.system(size: 80))
                    .foregroundColor(Color.white)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .border(Color.white)
                
                VStack {
                    ForEach(btnData, id: \.self) { col in
                        HStack {
                            ForEach(col, id: \.self) { button in
                                Button(action: {
                                    viewModel.handleButtonPress(button)
                                }) {
                                    ButtonLabelView(button: button.BtnDisplay)  // size는 16Pro 기준
                                        .frame(width: WIDTH / CGFloat(col.count) - 8,   // 8은 .padding()의 기본값
                                               height: isScientific ? (HEIGHT * 2) / (3 * CGFloat(btnData.count)) - 8 : WIDTH / CGFloat(col.count) - 8,
                                               alignment: .center)
                                        .background(button.backgroundColor)
                                        .cornerRadius(WIDTH / CGFloat(col.count) - 8)
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
            btnData[isScientific ? 5 : 0][0] = viewModel.currentAC ? .allClear : .clear
        }
        .onChange(of: viewModel.currentAC) { newValue in // iOS 17 이상 문법
            if newValue {
                btnData[isScientific ? 5 : 0][0] = .allClear
            }
            else {
                btnData[isScientific ? 5 : 0][0] = .clear
            }
        }
    }
}

#Preview {
    PortraitView(isScientific: .constant(false))
        .environmentObject(CalculatorViewModel())
}
