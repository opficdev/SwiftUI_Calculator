//
//  ContentView.swift
//  Calculator
//
//  Created by 최윤진 on 2023/07/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var orientation = OrientationViewModel()
    @StateObject private var viewModel = CalculatorViewModel()
    @State private var sheetOn = false
    @State private var isScientific = false //  후에 UserDefaults로 옮길 것
    
    let ud = UserDefaults.standard
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                sheetOn = true
            }, label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 22))
                    .foregroundColor(Color.orange)
            })
            .padding()
            if orientation.isPortrait {
                PortraitView(isScientific: $isScientific)
                    .environmentObject(viewModel)
                    .padding()
                    .padding(.bottom)
            }
            else {
                
            }
           
        }
        .sheet(isPresented: $sheetOn) {
            HistoryView()
                .presentationDetents([.fraction(0.5), .large])
        }
        .background(Color.black)
    }
}


#Preview {
    ContentView()
}
