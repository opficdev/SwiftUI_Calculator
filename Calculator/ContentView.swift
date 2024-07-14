//
//  ContentView.swift
//  Calculator
//
//  Created by 최윤진 on 2023/07/25.
//

import SwiftUI
import UIKit
import Combine

class DeviceOrientationManager: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    private var orientationDidChange: AnyCancellable?
    
    init() {
        orientationDidChange = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { $0.object as? UIDevice }
            .map { $0.orientation }
            .assign(to: \.orientation, on: self)
    }
}

struct ContentView: View {
    @StateObject private var orientationManager = DeviceOrientationManager()
    @State private var wasPortrait = true
    
    var body: some View {
        VStack {
            if orientationManager.orientation.isFlat {
                if wasPortrait{
                    Portrait()
                }
                else{
                    Landscape()
                }
            }
            else if orientationManager.orientation.isPortrait {
                Portrait().onAppear(){
                    wasPortrait = true
                }
            }
            else if orientationManager.orientation.isLandscape {
                Landscape().onAppear(){
                    wasPortrait = false
                }
            }
            else {
                Text("Unknown orientation")
            }
        }
        .onAppear {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        .onDisappear {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }
}

extension UIDeviceOrientation {
    var isFlat: Bool {
        return self == .faceUp || self == .faceDown
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
