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
//    @State private var isScientific = false //  후에 UserDefaults로 옮길 것
    
    let ud = UserDefaults.standard
    
    init() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = .dark   //  앱을 다크모드로 설정
            }
        }    
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Button(action: {
                    historyVM.showSheet = true
                }, label: {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.orange)
                })
//            if orientation.isPortrait {
                PortraitView()
                    .environmentObject(calcVM)
                    .padding(.bottom)
//                }
//                else {  //가로모드
//
//                }
                
            }
            .padding()
            .sheet(isPresented: $historyVM.showSheet) {
                HistoryView()
                    .environmentObject(historyVM)
                    .environmentObject(calcVM)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .background(Color.black)
            if calcVM.modeOn {
                ModeView()
                    .environmentObject(calcVM)
            }
        }
    }
}


#Preview {
    ContentView()
}
