//
//  OrientationViewModel.swift
//  Calculator
//
//  Created by opfic on 11/5/24.
//


import SwiftUI
import UIKit
import RxSwift
import RxCocoa
import Combine

// ViewModel 역할: Orientation 관리와 뷰 상태 관리
class OrientationViewModel: ObservableObject {
    private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @Published var isPortrait: Bool = true
    
    private let disposeBag = DisposeBag()
    
    private var orientationSubscription: AnyCancellable?
    
    init() {
        updateOrientation(UIDevice.current.orientation)
        
        // Orientation 변경사항을 관찰
        NotificationCenter.default.rx.notification(UIDevice.orientationDidChangeNotification)
            .compactMap { $0.object as? UIDevice }
            .map { $0.orientation }
            .subscribe(onNext: { [weak self] newOrientation in
                self?.updateOrientation(newOrientation)
            })
            .disposed(by: disposeBag)
        
//  MARK: Combine 관련 코드
//        orientationSubscription = NotificationCenter.default
//                .publisher(for: UIDevice.orientationDidChangeNotification)
//                .compactMap { $0.object as? UIDevice }
//                .map { $0.orientation }
//                .sink { [weak self] newOrientation in
//                    self?.updateOrientation(newOrientation)
//                }
        
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
