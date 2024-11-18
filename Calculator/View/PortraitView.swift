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
    let WIDTH = iPhonePointRes.currentDeviceWidth() ?? 0
    let HEIGHT = iPhonePointRes.currentDeviceHeight() ?? 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 0){
                Spacer()
                Text(viewModel.displayNum)
                    .font(.system(size: isScientific ? (HEIGHT * 2) / (3 * 10) : WIDTH / 4, weight: .regular))
                    .foregroundColor(Color.white)
                    .minimumScaleFactor(0.65)
                    .lineLimit(1)
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
        .onChange(of: viewModel.currentAC) { newValue in
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
