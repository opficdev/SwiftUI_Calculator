//
//  ContentView.swift
//  Calculator
//
//  Created by 최윤진 on 2023/07/25.
//

import SwiftUI
import UIKit
import Foundation

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

// An example view to demonstrate the solution
struct ContentView: View {
    @State var orientation = UIDeviceOrientation.portrait
    @State var portraited:Bool = true

    var body: some View {
        Group{
            if orientation.isLandscape{
                Landscape().onAppear{
                    portraited = false
                }
            }
            else if orientation.isFlat {
                if portraited{
                    Portrait()
                }
                else{
                    Landscape()
                }
            }
            else { //Unknown 상태이거나 portrait 상태
                Portrait().onAppear{
                    portraited = true
                }
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
