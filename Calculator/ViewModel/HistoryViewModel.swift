//
//  HistoryViewModel.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

class HistoryViewModel: ObservableObject { 
    @Published var showSheet = false
    @Published var modifyHistory = false
    @Published var removeAllAlert = false
    @Published var removeAlert = false
    @Published var historyData: [String: [History]] = [:]
    
    //  구독 관리용 Combine 변수
    private var cancellables = Set<AnyCancellable>()
    
    private let disposeBag = DisposeBag()
    // BehaviorRelay (RxSwift 데이터 흐름 관리용)
    private let historyDataRelay = BehaviorRelay<[String: [History]]>(value: [:])
    
    init() {
        // NotificationCenter를 통해 UserDefaults 변경 알림을 구독
        NotificationCenter.default.rx.notification(UserDefaults.didChangeNotification)
            // MainScheduler에서 이벤트를 처리하도록 스케줄러 설정
            .observe(on: MainScheduler.instance)
            // 알림을 받을 때 실행될 클로저 정의
            .subscribe(onNext: { [weak self] _ in
                // self가 해제되었는지 확인, 해제된 경우 실행 중지
                guard let self = self else { return }
                if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
                    for dateString in dateArr {
                        if let data = UserDefaults.standard.data(forKey: dateString),
                           let decodeData = try? JSONDecoder().decode([String: [History]].self, from: data) {
                               // 메인 스레드에서 UI 업데이트를 위해 동기화 작업 실행
                               DispatchQueue.main.async {
                                   // Relay를 통해 Rx 기반 데이터 스트림 업데이트
                                   self.historyDataRelay.accept(decodeData)
                                   // 로컬 변수에도 데이터 업데이트
                                   self.historyData = decodeData
                            }
                        }
                    }
                }
            })
            // 메모리 누수를 방지하기 위해 disposeBag에 구독 저장
            .disposed(by: disposeBag)

        
//  MARK: Combime 코드
//        // NotificationCenter를 통해 UserDefaults 변경 알림을 구독
//        NotificationCenter.Publisher(center: NotificationCenter.default, name: UserDefaults.didChangeNotification)
//            // 클로저를 통해 알림을 받을 때 실행될 동작 정의
//            .sink { [weak self] _ in
//                // self가 해제되었는지 확인, 해제된 경우 실행 중지
//                guard let self = self else { return }
//
//                if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
//                    for dateString in dateArr {
//                        if let data = UserDefaults.standard.data(forKey: dateString),
//                           let decodedData = try? JSONDecoder().decode([String: [History]].self, from: data) {
//                            // 메인 스레드에서 UI 업데이트를 위해 동기화 작업 실행
//                            DispatchQueue.main.async {
//                                // 로컬 변수에 디코딩된 데이터 업데이트
//                                self.historyData = decodedData
//                            }
//                        }
//                    }
//                }
//            }
//            // 메모리 누수를 방지하기 위해 구독 저장
//            .store(in: &cancellables)

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
    
//  MARK: 아래 두 함수들은 Combine 코드입니다
    // 선택된 계산 기록들을 제거
//    func removeHistory() -> AnyPublisher<Void, Never> {
//        return Future { promise in
//            for keyString in self.historyData.keys {
//                let filterData = self.historyData[keyString]!.filter { !$0.isChecked }
//                
//                if filterData.isEmpty {
//                    UserDefaults.standard.removeObject(forKey: keyString)
//                    if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
//                        UserDefaults.standard.set(dateArr.filter { $0 != keyString }, forKey: "dateArr")
//                    }
//                } else if let encodeData = try? JSONEncoder().encode([keyString: filterData]) {
//                    UserDefaults.standard.set(encodeData, forKey: keyString)
//                }
//            }
//            
//            if let dateArr = UserDefaults.standard.array(forKey: "dateArr"), dateArr.isEmpty {
//                self.modifyHistory = false
//                UserDefaults.standard.removeObject(forKey: "dateArr")
//            }
//            
//            // 완료
//            promise(.success(()))
//        }
//        .eraseToAnyPublisher()
//    }
    
    // 모든 계산 기록을 제거
//    func removeAllHistory() -> AnyPublisher<Void, Never> {
//        return Future { promise in
//            if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
//                for dateString in dateArr {
//                    UserDefaults.standard.removeObject(forKey: dateString)
//                }
//            }
//            UserDefaults.standard.removeObject(forKey: "dateArr")
//            
//            // 완료
//            promise(.success(()))
//        }
//        .eraseToAnyPublisher()
//    }

    
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
    func setNumberFmt(string: String, style: NumberFormatter.Style) -> String {
        if let decimalValue = Decimal(string: string) {
            let fmt = NumberFormatter()
            fmt.numberStyle = style

            return fmt.string(for: decimalValue) ?? string
        }
        return string
    }
}
