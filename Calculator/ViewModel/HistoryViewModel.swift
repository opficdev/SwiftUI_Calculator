//
//  HistoryViewModel.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import Foundation

class HistoryViewModel: ObservableObject { // @AppStorage로 뷰마다 바인딩이 가능하지만 MVVM 패턴을 따르기 위해 UserDefaults 뷰모델 정의
    @Published var defaults = UserDefaults.standard
    @Published var showSheet = false
    
    init() {}
    
    func set(_ value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func object(forKey key: String) -> Any? {
        return defaults.object(forKey: key)
    }
    
    func string(forKey key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    func bool(forKey key: String) -> Bool? {
        return defaults.bool(forKey: key)
    }
    
    func array(forKey key: String) -> Array<Any>? {
        return defaults.array(forKey: key)
    }
    
    func removeObject(foKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func clear() {
//        let allKey = defaults.dictionaryRepresentation().keys
//        for key in allKey {
//            defaults.removeObject(forKey: key)
//        }
        if let appDomain = Bundle.main.bundleIdentifier {
                defaults.removePersistentDomain(forName: appDomain)
            }
    }
    
    func register(defaults values: [String: Any]) {
        defaults.register(defaults: values)
    }
}
