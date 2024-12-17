//
//  ModeView.swift
//  Calculator
//
//  Created by opfic on 12/17/24.
//

import SwiftUI

struct ModeView: View {
    @EnvironmentObject var calcVM: CalculatorViewModel
    @State private var kindWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.black.ignoresSafeArea().opacity(0.7)
                .onTapGesture {
                    calcVM.modeOn = false
                }
            VStack(alignment: .leading) {
                Spacer()
                HStack(spacing: 0) {
                    VStack(alignment: .leading) { // 수직으로 행을 나열
                        ForEach(0..<2, id: \.self) { row in
                            HStack(spacing: 2) { // 각 행에 열을 나열
                                ForEach(0..<2, id: \.self) { column in
                                    let index = row * 2 + column
                                    Image(systemName: symbols(index))
                                        .frame(width: 10)
                                        .font(.system(size: 10, weight: .heavy))
                                        .foregroundStyle(calcVM.scientific ? Color.white : Color.orange)
                                }
                            }
                        }
                    }
                    .frame(width: kindWidth)
                    .padding(.horizontal)
                    Text("기본")
                        .font(.system(size: 20))
                        .foregroundStyle(calcVM.scientific ? Color.white : Color.orange)
                }
                .onTapGesture {
                    calcVM.scientific = false
                    calcVM.modeOn = false
                }

                Spacer()
                HStack(spacing: 0) {
                    Group {
                        Image(systemName: "function")
                            .frame(width: kindWidth)
                            .padding(.horizontal)
                        Text("공학용")
                    }
                    .font(.system(size: 20))
                    .foregroundStyle(calcVM.scientific ? Color.orange : Color.white)
                }
                .onTapGesture {
                    calcVM.scientific = true
                    calcVM.modeOn = false
                }
     
                Spacer()
                Divider()
                    .frame(height: 1)
                    .overlay(Color.black)
                Spacer()
                
                HStack(spacing: 0) {
                    Toggle("", isOn: $calcVM.unitConversion)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .background(
                        GeometryReader { geometry in
                            Color.clear.onAppear {
                                kindWidth = geometry.size.width
                            }
                        }
                    )
                    .onChange(of: calcVM.unitConversion) { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            calcVM.modeOn = false
                        }
                    }
                    .padding(.horizontal)
                    Text("변환")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.white)
                }
                Spacer()
            }
            .frame(width: calcVM.btnSize * 2.5, height: calcVM.btnSize * 2.5)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.elseBtn)
            )
            .padding()
            .padding()
            .padding(.bottom)
        }
    }
    
    func symbols(_ index: Int) -> String {
        switch index {
        case 0: return "plus"
        case 1: return "minus"
        case 2: return "multiply"
        case 3: return "divide"
        default: return ""
        }
    }
}
