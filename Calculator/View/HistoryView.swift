//
//  HistoryView.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    @State private var modifyHistory = false
    
    var body: some View {
        VStack {
            if !modifyHistory {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.showSheet = false
                    }, label: {
                        Text("완료")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.orange)
                            .padding()
                    })
                }
            }
            if let arr = UserDefaults.standard.array(forKey: "history") as? [History], !arr.isEmpty {
                List {
                    ForEach(arr, id: \.self) { element in
                        VStack(alignment: .leading) {
                            Text(element.historyExpr)
                                .font(.system(size: 16))
                                .foregroundColor(Color.gray)
                            Text(element.displayExpr)
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .border(Color.white)
                .scrollContentBackground(.hidden)
            }
            else {
                Group {
                    VStack(spacing: 10) {
                        Spacer()
                        Image(systemName: "clock")
                            .font(.system(size: 30))
                        Text("기록 없음")
                            .font(.system(size: 20))
                        Spacer()
                    }
                }
                .foregroundColor(Color.gray)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.deepGray)
        .tabItem {
            HStack {
                if modifyHistory {
                    Text("완료")
                        .onTapGesture {
                            modifyHistory = false
                        }
                    Spacer()
                    Text("삭제")
                }
                else {
                    Text("편집")
                        .onTapGesture {
                            modifyHistory = true
                        }
                        .foregroundColor(Color.orange)
                    Spacer()
                    Text("지우기")
                        .foregroundColor(Color.red)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
