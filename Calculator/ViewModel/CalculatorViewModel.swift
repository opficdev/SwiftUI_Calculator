//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by 최윤진 on 10/31/24.
//

import SwiftUI
import Combine

class CalculatorViewModel: ObservableObject {
    @Published var displayNum:String = "0"  //  화면에 보여지는 수
    @Published var currentAC = true // AC 버튼 on off
    @Published var showSelection = false // 모드 선택 버튼 on off
    private var infix_Expr:[String] = ["0"]  // 입력 식(중위) / 입력이 3, + 일 경우 정상적인 연산이 되어야 하므로 ["0"]으로 초기화
    private var isNewInput = true    //  숫자가 입력되는 것이 처음인지
    
    var isEmpty: Bool {
        return infix_Expr == ["0"]
    }
    
    // 연산자 우선순위
    private func priority(_ op: String) -> Int {
        if op == "(" || op == ")"{
            return 0
        }
        if op == "+" || op == "-"{
            return 1
        }
        if op == "*" || op == "/"{
            return 2
        }
        return -1
    }
    
    // 입력된 식의 마지막이 숫자인지 판별
    private func endsWithNumber() -> Bool {
        let last = infix_Expr.last  // nil이면 식 infix_Expr이 빈 것
        if last == nil || (last != "+" && last != "-" && last != "*" && last != "/"){
            return true
        }
        return false
    }
    
    //입력된 수식을 연산자 우선순위에 맞게 후위표기로 변경
    private func infix_Postfix() -> [String] {
       var postfix:[String] = []
       var stack:[String] = []
        for i in infix_Expr{
            if i == "+" || i == "-" || i == "*" || i == "/" {
                while !stack.isEmpty && (priority(i) <= priority(stack.last!)){
                    postfix.append(stack.popLast()!)
                }
                stack.append(i)
            }
            else if i == "(" {
                stack.append(i)
            }
            else if i == ")" {
                var top_op = stack.popLast()!
                while top_op != "("{
                    postfix.append(top_op)
                    top_op = stack.popLast()!
                }
            }
            else{
                postfix.append(i)
            }
        }
        while !stack.isEmpty {
            postfix.append(stack.popLast()!)
        }
        return postfix
    }
    
    //변경된 후위표기 식을 스택을 통해 계산
    private func calculation() -> String { // endsWithPrio1: 마지막으로 식에 입력되는 연산자가 + || - 이면 참
       let postfix = infix_Postfix()
       var stack:[String] = []
        for i in postfix{
            if i != "+" && i != "-" && i != "*" && i != "/" {
                stack.append(i)
            }
            else {
                if let num2 = stack.popLast(), let num1 = stack.popLast() {
                    if i == "+"{
//                        if !endWithPrio1 {
//                            stack.append(num2)
//                            break
//                        }
                        stack.append((NSDecimalNumber(string: num1).adding(NSDecimalNumber(string: num2))).stringValue)
                    }
                    else if i == "-" {
//                        if !endWithPrio1{
//                            stack.append(num2)
//                            break
//                        }
                        stack.append((NSDecimalNumber(string: num1).subtracting(NSDecimalNumber(string: num2))).stringValue)
                    }
                    else if i == "*" {
                        stack.append((NSDecimalNumber(string: num1).multiplying(by: NSDecimalNumber(string: num2))).stringValue)
                    }
                    else if i == "/" {
                        if num1 != "0" {
                            stack.append((NSDecimalNumber(string: num1).adding(NSDecimalNumber(string: num2))).stringValue)
                        }
                        else{   // 0으로 나누는 예외처리
                            return "오류"
                        }
                    }
                }
                else {
                    return "오류"
                }
            }
        }
        return stack.removeLast()
    }
    
    private func bracketCorrection() -> Bool { // 괄호 쌍이 안맞을 때
        var stack: [String] = infix_Expr.filter { $0 == "(" || $0 == ")" }
        
        while stack.count > 0 {
            var count = 0
            for i in 1..<stack.count {
                if stack[i - 1] == "(" && stack[i] == ")" {
                    stack.removeSubrange((i - 1)..<i + 1)
                    count = 1
                    break
                }
            }
            if count == 0 {
                break
            }
        }
        return stack.count == 0
    }

    
    func handleButtonPress(_ button: BtnType) {
        if button == .lbrac {
            if displayNum != "오류" {
                if endsWithNumber() && !isEmpty {
                    infix_Expr.append("*")
                }
                infix_Expr.append("(")
            }
        }
        else if button == .rbrac {
            if displayNum != "오류" {
                if endsWithNumber() && !isEmpty {
                    infix_Expr.append("*")
                }
                infix_Expr.append(")")
            }
        }
        else if button == .mc {
            
        }
        else if button == .m_add {
            
        }
        else if button == .m_sub {
            
        }
        else if button == .mr {
            
        }
        else if button == .allClear {
            displayNum = "0"
            isNewInput = true
            infix_Expr = ["0"]
        }
        else if button == .clear {
            displayNum.removeLast()
            if displayNum.isEmpty {
                displayNum = "0"
            }
        }
        else if button == .oppo {
            if displayNum.first == "-" {
                displayNum.removeFirst()
            }
            else{
                displayNum = "-" + displayNum
            }
            isNewInput = true
        }
        else if button == .perc {
            if displayNum != "오류" {
                
            }
            isNewInput = true
        }
        else if button == .div {
            if displayNum != "오류"{
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                }
                infix_Expr.append("/")
                isNewInput = true
            }
        }
        else if button == .sec {
            
        }
        else if button == .x2 {
            
        }
        else if button == .x3 {
            
        }
        else if button == .xy {
            
        }
        else if button == .ex {
            
        }
        else if button == .tenx {
            
        }
        else if button == .mul {
            if displayNum != "오류" {
                if !endsWithNumber(){
                    infix_Expr.removeLast()
                }
                infix_Expr.append("*")
                isNewInput = true
            }
        }
        else if button == .rev {
            
        }
        else if button == .x_2 {
            
        }
        else if button == .x_3 {
            
        }
        else if button == .x_y {
            
        }
        else if button == .ln {
            
        }
        else if button == .log10 {
            
        }
        else if button == .sub {
            if displayNum != "오류" {
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                }
                infix_Expr.append("-")
                isNewInput = true
            }
        }
        else if button == .xf {
            
        }
        else if button == .sin {
            
        }
        else if button == .cos {
            
        }
        else if button == .tan {
            
        }
        else if button == .e {
            
        }
        else if button == .EE {
            
        }
        else if button == .add {
            if displayNum != "오류" {
                if !endsWithNumber(){
                    infix_Expr.removeLast()
                }
                infix_Expr.append("+")
                isNewInput = true
            }
        }
        else if button == .rad {
            
        }
        else if button == .sinh {
            
        }
        else if button == .cosh {
            
        }
        else if button == .tanh {
            
        }
        else if button == .pi {
            
        }
        else if button == .rand {
            
        }
        else if button == .dot {
            if displayNum == "오류" {
                displayNum = "0."
            }
            else if !displayNum.contains(".") {
                displayNum += "."
            }
        }
        else if button == .equal {
            if !endsWithNumber() { //부호로 식이 끝났을 때
                infix_Expr.append(infix_Expr[infix_Expr.count - 2]) //입력이 2, + 일 때 = 을 계속 누르면 해당 연산이 계속 이어져 나가야 함
            }
            if !bracketCorrection() { // 괄호 쌍이 안맞을 경우
                let bracGap = infix_Expr.filter({ $0 == "(" }).count - infix_Expr.filter({ $0 == ")" }).count
                if bracGap < 0 {
                    infix_Expr = Array(repeating: "(", count: -bracGap) + infix_Expr
                }
                else {
                    infix_Expr += Array(repeating: ")", count: bracGap)
                }
            }
            displayNum = calculation()
            isNewInput = true
        }
        else if button == .emoji {
            
        }
        else { //  숫자 버튼을 눌렀을 때
            if let num: String = button.BtnDisplay.string {
                if displayNum == "0" || displayNum == "오류" || isNewInput{
                    displayNum = num
                    isNewInput = false
                    if infix_Expr == ["0"] { //  초기 상태일 때
                        infix_Expr[0] = num
                    }
                    else {
                        infix_Expr.append(num)
                    }
                }
                else {
                    displayNum += num
                    infix_Expr[infix_Expr.count - 1] = displayNum
                }
            }
        }
        
        if button == .allClear || button == .clear || button == .equal {
            currentAC = true
        }
        else if button == .emoji {
            // 이 경우엔 currentAC 값을 유지한다
        }
        else {
            currentAC = false
        }
    }

}

