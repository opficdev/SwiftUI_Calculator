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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("완료") {
                    historyVM.showSheet = false
                }
                .fontWeight(.semibold)
                .foregroundColor(historyVM.modifyHistory ? Color.clear : Color.orange)
                .disabled(historyVM.modifyHistory)
                .padding()
            }
            if let dateArr = UserDefaults.standard.array(forKey: "dateArr") as? [String], !dateArr.isEmpty {
                VStack {
                    ScrollView {
                        ForEach(dateArr, id: \.self) { dateString in
                            if let arr = historyVM.historyData[dateString],
                               let date = historyVM.relativeDateString(for: dateString) {
                                LazyVStack(alignment: .leading, spacing: 0) {
                                    Text(date)
                                        .foregroundColor(Color.gray)
                                        .font(.headline)
                                        .padding(.bottom)
                                    ForEach(arr.indices, id: \.self) { idx in
                                        HStack(spacing: 0) {
                                            if historyVM.modifyHistory {
                                                Button {
                                                    historyVM.historyData[dateString]?[idx].CheckToggle()
                                                } label: {
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
                                                .transition(.move(edge: .leading))
                                                .padding(.trailing)
                                            }
                                            VStack(alignment: .leading) {
                                                Rectangle()
                                                    .foregroundColor(.gray)
                                                    .frame(height: 1)
                                                    .padding(.bottom)
                                                Text(arr[idx].historyExpr)
                                                    .font(.system(size: 16))
                                                    .foregroundColor(Color.gray)
                                                Text(arr[idx].displayExpr)
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color.white)
                                                Rectangle()
                                                    .foregroundColor(idx == arr.count - 1 ? .gray : .clear)
                                                    .frame(height: 1)
                                                    .padding(.top)
                                            }
                                        }
                                    }
                                    .animation(.easeInOut, value: historyVM.modifyHistory)
                                }
                                .padding(.leading)
                            }
                        }
                    }
                }
                .toolbar {
                    if !historyVM.historyData.isEmpty {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                if historyVM.modifyHistory {
                                    Button {
                                        withAnimation {
                                            historyVM.modifyHistory = false
                                        }
                                        historyVM.resetCheck()
                                    } label: {
                                        Text("완료")
                                            .foregroundColor(Color.orange)
                                    }
                                    Spacer()
                                    Button {
                                        historyVM.removeAlert = true
                                    } label: {
                                        Text("삭제")
                                            .foregroundColor(historyVM.selectedCount == 0 ? Color.gray : Color.red)
                                    }
                                    .disabled(historyVM.selectedCount == 0)
                                }
                                else {
                                    Button {
                                        withAnimation {
                                            historyVM.modifyHistory = true
                                        }
                                    } label: {
                                        Text("편집")
                                            .foregroundColor(Color.orange)
                                    }
                                    Spacer()
                                    Button {
                                        historyVM.removeAllAlert = true
                                    } label: {
                                        Text("지우기")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                }
                .confirmationDialog("\(historyVM.selectedCount)개의 계산이 삭제됩니다. 이 동작은 취소할 수 없습니다",
                                    isPresented: $historyVM.removeAlert,
                                    titleVisibility: .visible) {
                    Button(role: .destructive) {
                        historyVM.removeHistory()
                    } label: {
                        Text("삭제")
                    }
                }
                .confirmationDialog("모든 계산이 삭제됩니다. 이 동작은 취소할 수 없습니다.",
                                    isPresented: $historyVM.removeAllAlert,
                                    titleVisibility: .visible) {
                    Button(role: .destructive) {
                        historyVM.removeAllHistory()
                        historyVM.modifyHistory = false
                    } label: {
                        Text("기록 지우기")
                    }

                }
                Spacer()
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
        .onDisappear {
            historyVM.modifyHistory = false
            historyVM.resetCheck()
        }
    }
}

#Preview {
    HistoryView()
}
