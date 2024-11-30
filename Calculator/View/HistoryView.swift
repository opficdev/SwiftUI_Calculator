//
//  HistoryView.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import SwiftUI
import UIKit

struct HistoryView: View {
    @EnvironmentObject var historyVM: HistoryViewModel
    
    init() {
        UIToolbar.appearance().barTintColor = UIColor(Color.elseBtn)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("완료") {
                    historyVM.showSheet = false
                }
                .fontWeight(.semibold)
                .foregroundColor(historyVM.modifyHistory ? Color.clear : Color.orange)
                .padding([.top, .trailing])
            }
            
            if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String], !dateArr.isEmpty {
                List {
                    ForEach(dateArr, id: \.self) { dateString in
                        if let arr = historyVM.historyData[dateString],
                           let gap = historyVM.relativeDateString(for: dateString) {
                            Text(gap)
                                .foregroundColor(Color.gray)
                                .font(.headline)
                            ForEach(arr.indices, id: \.self) { idx in
                                HStack {
                                    if historyVM.modifyHistory {
                                        Button(action: {
                                            historyVM.historyData[dateString]?[idx].CheckToggle()
                                        }) {
                                            if arr[idx].isChecked {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(Color.orange)
                                                    .font(.title3)
                                            }
                                            else {
                                                Image(systemName: "circle")
                                                    .foregroundColor(Color.gray)
                                                    .font(.title3)
                                            }
                                        }
                                        .padding(.trailing)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(arr[idx].historyExpr)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.gray)
                                        Text(arr[idx].displayExpr)
                                            .font(.system(size: 20))
                                            .foregroundColor(Color.white)
                                    }
                                }
                                .padding(.vertical)
                            }
                        }
                        else {
                            Color.clear.onAppear {
                                if let data = UserDefaults.standard.data(forKey: dateString),
                                   let dict = try? JSONDecoder().decode([String:[History]].self, from: data) {
                                    historyVM.historyData = dict
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparatorTint(Color.gray)
                    
                }
                .scrollContentBackground(.hidden) // 전체 List 배경 제거
                .listStyle(PlainListStyle())
                .toolbar {
                    if !historyVM.historyData.isEmpty {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                if historyVM.modifyHistory {
                                    Button(action: {
                                        historyVM.modifyHistory = false
                                    }) {
                                        Text("완료")
                                            .foregroundColor(Color.orange)
                                    }
                                    Spacer()
                                    Button(role: .destructive, action: {
                                        
                                    }, label: {
                                        Text("삭제")
                                    })
                                }
                                else {
                                    Button("편집") {
                                        historyVM.modifyHistory = true
                                    }
                                    .foregroundColor(Color.orange)
                                    Spacer()
                                    Button(action: {
                                        historyVM.removeAll = true
                                    }) {
                                        Text("지우기")
                                            .foregroundColor(Color.red)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                Spacer()
                Group {
                    VStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.system(size: 30))
                        Text("기록 없음")
                            .font(.system(size: 20))
                    }
                }
                .foregroundColor(Color.gray)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.deepGray)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    HistoryView()
}
