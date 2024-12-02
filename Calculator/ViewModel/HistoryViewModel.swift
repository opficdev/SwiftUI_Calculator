//
//  HistoryViewModel.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import Foundation

class HistoryViewModel: ObservableObject { 
    @Published var showSheet = false
    @Published var modifyHistory = false
    @Published var removeAllAlert = false
    @Published var removeAlert = false
    @Published var historyData: [String: [History]] = [:]
    
    var selectedCount: Int {
        return historyData.values.reduce(0) { count, historyItems in
            count + historyItems.filter { $0.isChecked }.count
        }
    }
    
    var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
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
    
    func removeHistory() {
        for keyString in historyData.keys {
            historyData[keyString] = historyData[keyString]!.filter { !$0.isChecked }
            if historyData[keyString]!.isEmpty {
                UserDefaults.standard.removeObject(forKey: keyString)
                if var dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
                    UserDefaults.standard.set(dateArr.filter { $0 != keyString}, forKey: "dateArr")
                }
            }
        }
        if let encodeDict = try? JSONEncoder().encode(historyData) {
            UserDefaults.standard.set(encodeDict, forKey: today)
        }
        
    }
    
    func removeAllHistory() {
        if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
            for dateString in dateArr {
                UserDefaults.standard.removeObject(forKey: dateString)
            }
        }
        UserDefaults.standard.removeObject(forKey: "dateArr")
        historyData.removeAll()
    }
}
