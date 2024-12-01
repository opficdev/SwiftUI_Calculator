//
//  ContentView.swift
//  Calculator
//
//  Created by 최윤진 on 2023/07/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var orientation = OrientationViewModel()
    @StateObject private var historyVM = HistoryViewModel()
    @StateObject private var calcVM = CalculatorViewModel()
    @State private var isScientific = false //  후에 UserDefaults로 옮길 것
    
    let ud = UserDefaults.standard
    
    init() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                historyVM.showSheet = true
            }, label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 22))
                    .foregroundColor(Color.orange)
            })
            .padding()
            if orientation.isPortrait {
                PortraitView(isScientific: $isScientific)
                    .environmentObject(calcVM)
                    .padding()
                    .padding(.bottom)
            }
            else {  //가로모드
                
            }
           
        }
        .sheet(isPresented: $historyVM.showSheet) {
            HistoryView()
                .environmentObject(historyVM)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .background(Color.black)
    }
}


#Preview {
    ContentView()
}
