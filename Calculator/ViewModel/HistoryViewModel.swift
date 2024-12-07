//
//  HistoryViewModel.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class HistoryViewModel: ObservableObject { 
    @Published var showSheet = false
    @Published var modifyHistory = false
    @Published var removeAllAlert = false
    @Published var removeAlert = false
    @Published var historyData: [String: [History]] = [:]
    
    private let disposeBag = DisposeBag()
    // BehaviorRelay (RxSwift 데이터 흐름 관리용)
    private let historyDataRelay = BehaviorRelay<[String: [History]]>(value: [:])
    
    init() {
        //  UserDefaults의 변화를 HistoryData 변수에 즉시 동기화 시킴
        NotificationCenter.default.rx.notification(UserDefaults.didChangeNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
                    for dateString in dateArr {
                        if let data = UserDefaults.standard.data(forKey: dateString),
                           let decodeData = try? JSONDecoder().decode([String: [History]].self, from: data) {
                               DispatchQueue.main.async {
                                   self.historyDataRelay.accept(decodeData)
                                   self.historyData = decodeData
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    //  기록 수정 모드에서 선택된 기록의 갯수를 반환
    var selectedCount: Int {
        return historyData.values.reduce(0) { count, historyItems in
            count + historyItems.filter { $0.isChecked }.count
        }
    }
    
    // 오늘 날짜를 yyyy-MM-dd 형식으로 반환
    var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    // 날짜를 오늘, 어제 등 비교형으로 변환 후 반환
    func relativeDateString(for dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.doesRelativeDateFormatting = true
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    //  선택된 계산 기록들을 제거
    @discardableResult
    func removeHistory() -> Completable {
        return Completable.create { completable in
            for keyString in self.historyData.keys {
                let filterData = self.historyData[keyString]!.filter { !$0.isChecked }
                
                if filterData.isEmpty {
                    UserDefaults.standard.removeObject(forKey: keyString)
                    if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
                        UserDefaults.standard.set(dateArr.filter { $0 != keyString }, forKey: "dateArr")
                    }
                }
                else if let encodeData = try? JSONEncoder().encode([keyString: filterData]) {
                    UserDefaults.standard.set(encodeData, forKey: keyString)
                }
            }
            if let dateArr = UserDefaults.standard.array(forKey: "dateArr"), dateArr.isEmpty {
                self.modifyHistory = false
                UserDefaults.standard.removeObject(forKey: "dateArr")
            }
            
            // 작업 완료 알림
            completable(.completed)
            return Disposables.create()
        }
    }
    
    //  모든 계산 기록을 제거
    @discardableResult
    func removeAllHistory() -> Completable {
        return Completable.create { completable in
            if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
                for dateString in dateArr {
                    UserDefaults.standard.removeObject(forKey: dateString)
                }
            }
            UserDefaults.standard.removeObject(forKey: "dateArr")
            completable(.completed)
            return Disposables.create()
        }
    }
    
    //  선택 된 후 삭제하지 않았을 시 체크를 원복시켜주는 함수
    func resetCheck() {
        for keyString in historyData.keys {
            if let items = historyData[keyString] {
                historyData[keyString] = items.map { item in
                    var newItem = item
                    newItem.isChecked = false
                    return newItem
                }
            }
        }
    }
    
    func setNumberFmt(string: String, scale: Int16 = Int16.max ,style: NumberFormatter.Style) -> String {
        if let _ = Double(string) {
            let fmt = NumberFormatter()
            fmt.numberStyle = style
            
            let decimalNumber = NSDecimalNumber(string: string)
            let handler = NSDecimalNumberHandler(
                roundingMode: .plain,
                scale: scale - 1,
                raiseOnExactness: false,
                raiseOnOverflow: false,
                raiseOnUnderflow: false,
                raiseOnDivideByZero: false
            )
            
            return decimalNumber.rounding(accordingToBehavior: handler).stringValue
        }
        
        return string
    }
}
