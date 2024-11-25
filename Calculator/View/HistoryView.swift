//
//  HistoryView.swift
//  Calculator
//
//  Created by opfic on 11/6/24.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: HistoryViewModel
    @State private var testHistory: [History]? = [
        History(historyExpr: "(-6)+5", displayExpr: "-1"),
        History(historyExpr: "456×5", displayExpr: "2,280")
    ]
    @State private var modifyHistory = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            if !modifyHistory {
                Text("완료")
                    .fontWeight(.semibold)
                    .foregroundColor(Color.orange)
                    .padding()
                    .onTapGesture {
                        viewModel.showSheet = false
                        print(viewModel.showSheet)
                    }
            }
            List {
//                if let arr = history.array(forKey: "history") as? [History] {
                if let arr = testHistory, !arr.isEmpty {
                    ForEach(arr, id: \.self) { element in
                        VStack {
                            Text(element.historyExpr)
                                .font(.system(size: 10))
                                .foregroundColor(Color.gray)
                            Text(element.displayExpr)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white)
                        }
                    }
                }
                else { // 기록 없음
                    
                }
            }
            .background(Color.deepGray)
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
