//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by 최윤진 on 10/31/24.
//

import SwiftUI

class CalculatorViewModel: ObservableObject {
    @Published var displayNum:String = "0"  //  화면에 보여지는 수(흰색)
    @Published var history = "" // 회색으로 나타나는 기존 계산식
    @Published var currentAC = true // AC 버튼 on off
    @Published var showSelection = false // 모드 선택 버튼 on off
    private var infix_Expr:[String] = []  // 입력 식(중위)
    private var isError = false // 현재 계산 중 에러가 발생했는지
    private var newNumInput = true // 새로운 숫자가 입력되는지
    private let fmt = NumberFormatter()

    
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
        let last = infix_Expr.last
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
    private func calculation() -> String {
       let postfix = infix_Postfix()
       var stack:[String] = []
        for i in postfix{
            if i != "+" && i != "-" && i != "*" && i != "/" {
                stack.append(i)
            }
            else {
                if let num2 = stack.popLast(), let num1 = stack.popLast() {
                    if i == "+"{
                        stack.append((NSDecimalNumber(string: num1).adding(NSDecimalNumber(string: num2))).stringValue)
                    }
                    else if i == "-" {
                        stack.append((NSDecimalNumber(string: num1).subtracting(NSDecimalNumber(string: num2))).stringValue)
                    }
                    else if i == "*" {
                        stack.append((NSDecimalNumber(string: num1).multiplying(by: NSDecimalNumber(string: num2))).stringValue)
                    }
                    else if i == "/" {
                        if num2 != "0" {
                            stack.append((NSDecimalNumber(string: num1).dividing(by: NSDecimalNumber(string: num2))).stringValue)
                        }
                        else{   // 0으로 나누는 예외처리
                            isError = true
                            return "정의되지 않음"
                        }
                    }
                }
                else {
                    isError = true
                    newNumInput = false
                    return displayNum //  계산 중 오류 있었을 때인데 다양한 케이스가 존재할 수 있음
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
        if button == .add {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append("0")
                }
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                    displayNum.removeLast()
                }
                infix_Expr.append("+")
                displayNum += "+"
                newNumInput = true
            }
        }
        else if button == .sub {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append("0")
                }
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                    displayNum.removeLast()
                }
                infix_Expr.append("-")
                displayNum += "-"
                newNumInput = true
            }
        }
        else if button == .mul {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append("0")
                }
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                    displayNum.removeLast()
                }
                infix_Expr.append("*")
                displayNum += "x"
                newNumInput = true
            }
        }
        else if button == .div {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append("0")
                }
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                    displayNum.removeLast()
                }
                infix_Expr.append("/")
                displayNum += "÷"
                newNumInput = true
            }
        }
        else if button == .equal {
            if !bracketCorrection() { // 괄호 쌍이 안맞을 경우
                let bracGap = infix_Expr.filter({ $0 == "(" }).count - infix_Expr.filter({ $0 == ")" }).count
                if bracGap < 0 {
                    infix_Expr = Array(repeating: "(", count: -bracGap) + infix_Expr
                } else {
                    infix_Expr += Array(repeating: ")", count: bracGap)
                }
            }
            if infix_Expr.isEmpty {
                return
            }
            newNumInput = true
            history = displayNum
            print(history)
            displayNum = calculation()
            infix_Expr = [displayNum]
        }
        else if button == .allClear {
            displayNum = "0"
            isError = false
            newNumInput = true
            infix_Expr.removeAll()
        }
        else if button == .clear {
            displayNum.removeLast()
            if displayNum.isEmpty {
                displayNum = "0"
            }
            if !infix_Expr.isEmpty {
                let last = infix_Expr.removeLast()
                if let _num = Int(last) {    // 문자열이 Int 형변환이 되면
                    let num = String(_num)
                    if num.count > 1 {  // 숫자가 2자리 이상인 경우
                        let index = num.index(num.endIndex, offsetBy: -1)
                        let tmp = String(num[..<index])
                        infix_Expr.append(tmp)
                    }
                }
            }
        }
        else if button == .dot {
            if isError {
                displayNum = "0."
            }
            else if !displayNum.contains(".") {
                displayNum += "."
            }
        }
        else if button == .lbrac {
            if !isError {
                if endsWithNumber() && !infix_Expr.isEmpty {
                    infix_Expr.append("*")
                }
                infix_Expr.append("(")
            }
        }
        else if button == .rbrac {
            if !isError {
                if endsWithNumber() && !infix_Expr.isEmpty {
                    infix_Expr.append("*")
                }
                infix_Expr.append(")")
            }
        }
        else if button == .mc {
            // 메모리 클리어 처리
        }
        else if button == .m_add {
            // 메모리 추가 처리
        }
        else if button == .m_sub {
            // 메모리 감소 처리
        }
        else if button == .mr {
            // 메모리 리콜 처리
        }
        else if button == .oppo {
            if !isError {
                // 값의 부호를 변경하는 코드
            }
        }
        else if button == .perc {
            if !isError {
                // 백분율 계산 처리
            }
        }
        else if button == ._2nd {
            // 2차 기능 처리
        }
        else if button == .x2 {
            // x^2 처리
        }
        else if button == .x3 {
            // x^3 처리
        }
        else if button == .xy {
            // x^y 처리
        }
        else if button == .ex {
            // e^x 처리
        }
        else if button == .tenx {
            // 10^x 처리
        }
        else if button == .rev {
            // 역수 처리
        }
        else if button == .x_2 {
            // x^(1/2) 처리
        }
        else if button == .x_3 {
            // x^(1/3) 처리
        }
        else if button == .x_y {
            // x^(1/y) 처리
        }
        else if button == .ln {
            // 자연 로그 처리
        }
        else if button == .log10 {
            // 상용 로그 처리
        }
        else if button == .xf {
            // 팩토리얼 처리
        }
        else if button == .sin {
            // 사인 처리
        }
        else if button == .cos {
            // 코사인 처리
        }
        else if button == .tan {
            // 탄젠트 처리
        }
        else if button == .e {
            // 자연 상수 e 처리
        }
        else if button == .EE {
            // 과학 표기법 E 처리
        }
        else if button == .rad {
            // 라디안 변환 처리
        }
        else if button == .sinh {
            // 쌍곡선 사인 처리
        }
        else if button == .cosh {
            // 쌍곡선 코사인 처리
        }
        else if button == .tanh {
            // 쌍곡선 탄젠트 처리
        }
        else if button == .pi {
            // 원주율 π 처리
        }
        else if button == .rand {
            // 랜덤 값 처리
        }
        else if button == .emoji {
            
        }
        else { //  숫자 버튼을 눌렀을 때
            if let num: String = button.BtnDisplay.string {
                if isError {
                    newNumInput = false
                    infix_Expr = [num]
                    displayNum = num
                }
                else if newNumInput {
                    newNumInput = false
                    infix_Expr.append(num)
                    if displayNum == "0" && num == "0" {
                        newNumInput = true
                        infix_Expr.removeAll()
                        displayNum = "0"
                    }
                    else if displayNum == "0" {
                        displayNum = num
                    }
                    else {
                        displayNum += num
                    }
                }
                else {
                    infix_Expr[infix_Expr.count - 1] += num
                    displayNum += num
                }
            }
        }
        
        // 아래 조건문들은 위에 있는 조건문들에 다 일일이 쓰면 currentAC 관련 코드를 넣으면 더러워질 것 같아서 따로 빼놓음
        if button == .equal || infix_Expr.isEmpty {
            currentAC = true
        }
        else if button == .clear {
            if displayNum == "0" || isError {
                currentAC = true
            }
        }
        else if button == .emoji {
            // 이 경우엔 currentAC 값을 유지한다
        }
        else {
            if !isError {
                currentAC = false
            }
        }
    }
}

