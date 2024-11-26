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
        VStack(alignment: .trailing) {
            if !modifyHistory {
                Button(action: {
                    viewModel.showSheet = false
                }, label: {
                    Text("완료")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.orange)
                        .padding()
                })
            }
            if let arr = viewModel.array(forKey: "history") as? [History], !arr.isEmpty {
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
            else { // 기록 없음
                
            }
        }
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
