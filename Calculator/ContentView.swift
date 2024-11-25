//
//  ContentView.swift
//  Calculator
//
//  Created by 최윤진 on 2023/07/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var orientation = OrientationViewModel()
    @StateObject private var calcViewModel = CalculatorViewModel()
    @StateObject private var historyViewModel = HistoryViewModel()
//    @State private var sheetOn = false
    @State private var isScientific = false //  후에 UserDefaults로 옮길 것
    
    let ud = UserDefaults.standard
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                historyViewModel.showSheet = true
            }, label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 22))
                    .foregroundColor(Color.orange)
            })
            .padding()
            if orientation.isPortrait {
                PortraitView(isScientific: $isScientific)
                    .environmentObject(calcViewModel)
                    .padding()
                    .padding(.bottom)
            }
            else {
                
            }
           
        }
        .sheet(isPresented: $historyViewModel.showSheet) {
            HistoryView()
                .environmentObject(historyViewModel)
                .presentationDetents([.fraction(0.5), .large])
                .presentationDragIndicator(.visible)
        }
        .background(Color.black)
    }
}


#Preview {
    ContentView()
}
