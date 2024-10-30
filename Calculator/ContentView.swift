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
    @StateObject private var calculation = Calculation()
    @State private var wasPortrait = true
    @State private var rotated = false //   한번이라도 기울어진 적이 있는가
    @State private var num = "0"
    
    var body: some View {
        VStack {
            if orientationManager.orientation == .portraitUpsideDown {
                if rotated && !wasPortrait {
                    Landscape(num: $num).environmentObject(calculation).onAppear {
                        wasPortrait = false
                    }
                }
                else {
                    Portrait(num: $num).environmentObject(calculation).onAppear {
                        rotated = true
                    }
                }
            }
            else if orientationManager.orientation.isFlat {
                if wasPortrait {
                    Portrait(num: $num)
                        .environmentObject(calculation)
                } else {
                    Landscape(num: $num)
                        .environmentObject(calculation)
                }
            }
            else if orientationManager.orientation.isLandscape {
                Landscape(num: $num).environmentObject(calculation).onAppear {
                    wasPortrait = false
                }
            }
            else {
                Portrait(num: $num).environmentObject(calculation).onAppear {
                    wasPortrait = true
                }
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

