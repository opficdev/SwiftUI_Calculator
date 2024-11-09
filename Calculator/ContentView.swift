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
    let ud = UserDefaults.standard
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                sheetOn = true
            }, label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 25))
                    .foregroundColor(Color.orange)
            })
            .padding(.horizontal)
            BasicView()
                .environmentObject(OrientationViewModel())
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $sheetOn) {
            
        }
        .background(Color.black)
    }
}



#Preview {
    ContentView()
        .environmentObject(OrientationViewModel())
        .environmentObject(CalculatorViewModel())
}
