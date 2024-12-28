//
//  HistoryView.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import SwiftUI
import UIKit
import RxSwift

struct HistoryView: View {
    @EnvironmentObject var historyVM: HistoryViewModel
    @EnvironmentObject var calcVM: CalculatorViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("완료") {
                    historyVM.showSheet = false
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(historyVM.modifyHistory ? Color.clear : Color.orange)
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
                                        .foregroundStyle(Color.gray)
                                        .font(.title3)
                                        .padding([.bottom, .leading])
                                    ForEach(arr.indices, id: \.self) { idx in
                                        HStack(spacing: 0) {
                                            if historyVM.modifyHistory {
                                                Button {
                                                    historyVM.historyData[dateString]?[idx].CheckToggle()
                                                } label: {
                                                    if arr[idx].isChecked {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundStyle(Color.orange)
                                                            .font(.title3)
                                                    }
                                                    else {
                                                        Image(systemName: "circle")
                                                            .foregroundStyle(Color.gray)
                                                            .font(.title3)
                                                    }
                                                }
                                                .transition(AnyTransition.opacity.combined(with: .move(edge: .leading)))
                                                .padding(.trailing)
                                            }
                                            VStack(alignment: .leading) {
                                                Divider()
                                                    .padding(.bottom)
                                                Text(arr[idx].historyExpr.map{ historyVM.setNumberFmt(string: $0.value, style: .decimal) }.joined())
                                                    .foregroundStyle(Color.gray)
                                                Text(historyVM.setNumberFmt(string: arr[idx].displayExpr.map{$0.value}.joined(), style: .decimal))
                                                    .font(.title3)
                                                    .foregroundStyle(Color.white)
                                                Divider()
                                                    .padding(.top)
                                            }
                                        }
                                        .padding(.leading)
                                        .background((historyVM.modifyHistory && arr[idx].isChecked) ||
                                                    (!historyVM.modifyHistory && arr[idx].id == calcVM.id)
                                                    ? Color.gray.opacity(0.1) : Color.clear)
                                        .contentShape(Rectangle()) // HStack의 터치 영역 확장
                                        .onTapGesture {
                                            if !historyVM.modifyHistory {
                                                calcVM.id = arr[idx].id
                                                calcVM.historyExpr = arr[idx].historyExpr
                                                calcVM.displayExpr = arr[idx].displayExpr
                                                calcVM.currentAC = true
                                                calcVM.undefined = false
                                                calcVM.exprError = false
                                                historyVM.showSheet = false
                                            }
                                        }
                                    }
                                    .animation(.easeIn(duration: 0.2), value: historyVM.modifyHistory)
                                }
                                .padding(.top)
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
                                            .foregroundStyle(Color.orange)
                                    }
                                    Spacer()
                                    Button {
                                        historyVM.removeAlert = true
                                    } label: {
                                        Text("삭제")
                                            .foregroundStyle(historyVM.selectedCount == 0 ? Color.gray : Color.red)
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
                                            .foregroundStyle(Color.orange)
                                    }
                                    Spacer()
                                    Button {
                                        historyVM.removeAllAlert = true
                                    } label: {
                                        Text("지우기")
                                            .foregroundStyle(.red)
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
                            .subscribe(
                                onCompleted: {},
                                onError: { error in
                                    print("에러 발생: \(error.localizedDescription)")
                                }
                            )
                            .disposed(by: historyVM.disposeBag)
                    } label: {
                        Text("삭제")
                    }
                }
                .confirmationDialog("모든 계산이 삭제됩니다. 이 동작은 취소할 수 없습니다.",
                                    isPresented: $historyVM.removeAllAlert,
                                    titleVisibility: .visible) {
                    Button(role: .destructive) {
                        historyVM.removeAllHistory()
                            .subscribe(
                                onCompleted: {},
                                onError: { error in print("에러 발생: \(error)") }
                            )
                            .disposed(by: historyVM.disposeBag)
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
                .foregroundStyle(Color.gray)
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
        .environmentObject(HistoryViewModel())
        .environmentObject(CalculatorViewModel())
}
