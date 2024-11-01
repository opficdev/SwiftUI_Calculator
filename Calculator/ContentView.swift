//
//  ContentView.swift
//  Calculator
//
//  Created by 최윤진 on 2023/07/25.
//

import SwiftUI
import UIKit
import Combine

// ViewModel 역할: Orientation 관리와 뷰 상태 관리
class OrientationViewModel: ObservableObject {
    private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @Published var isPortrait: Bool = true
    
    private var orientationDidChange: AnyCancellable?
    
    init() {
        updateOrientation(UIDevice.current.orientation)
        // Orientation 변경사항을 관찰
        orientationDidChange = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { $0.object as? UIDevice }
            .map { $0.orientation }
            .sink { [weak self] newOrientation in
                self?.updateOrientation(newOrientation)
            }
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    // Orientation 상태를 업데이트하는 함수
    private func updateOrientation(_ newOrientation: UIDeviceOrientation) {
        orientation = newOrientation
        switch orientation {
//        case .portrait:
//            isPortrait = true
        case .landscapeLeft, .landscapeRight, .portraitUpsideDown:
                isPortrait = false
//        case .faceUp, .faceDown, .portraitUpsideDown:
//            break
        default:
            isPortrait = true
            break
        }
    }
    
    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
}

struct ContentView: View {
    @StateObject private var orientation = OrientationViewModel()
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        VStack {
            if orientation.isPortrait {
                Portrait()
                    .environmentObject(orientation)
                    .environmentObject(viewModel)
            } else {
                Landscape()
                    .environmentObject(orientation)
                    .environmentObject(viewModel)
            }
        }
    }
}

extension UIDeviceOrientation {
    var isFlat: Bool {
        return self == .faceUp || self == .faceDown
    }
}
