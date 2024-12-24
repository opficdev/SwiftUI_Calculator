//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by 최윤진 on 10/31/24.
//

import SwiftUI

class CalculatorViewModel: ObservableObject {
    @Published var scientific = UserDefaults.standard.bool(forKey: "scientific") {
        didSet {
            UserDefaults.standard.set(scientific, forKey: "scientific")
        }
    }
    @Published var unitConversion = UserDefaults.standard.bool(forKey: "unitConversion") {
        didSet {
            UserDefaults.standard.set(unitConversion, forKey: "unitConversion")
        }
    }
//    @Published var historyExpr: [String] = [] // 회색으로 나타나는 기존 계산식
//    @Published var displayExpr: [String] = ["0"]  //  화면에 보여지는 수(흰색)
    @Published var historyExpr: [Token] = [] // 회색으로 나타나는 기존 계산식
    @Published var displayExpr: [Token] = [Token(value: "0", automatic: false)]
    @Published var currentAC = true // AC 버튼 on off
    @Published var id = UUID()  //  현재 수식에 설정되는 UUID
    @Published var btnSize: CGFloat = 0
    @Published var modeOn = false
//    private var infix_Expr:[String] = []  // 입력 식(중위)
    private var infix_Expr: [Token] = []  // 입력 식(중위)
    private var isError = false // 현재 계산 중 에러가 발생했는지
    private var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    var rbracketAddCount = 0
    
    // 연산자 우선순위
    private func priority(_ op: String) -> Int {
        if op == "(" || op == ")" {
            return 0
        }
        if op == "+" || op == "-" {
            return 1
        }
        if op == "×" || op == "÷" || op == "%" {
            return 2
        }
        return -1
    }
    
    // 입력된 식의 마지막이 숫자인지 판별
    private func endsWithNumber() -> Bool {
        let last = infix_Expr.last?.value
        if last == nil || priority(last!) == -1 {
            return true
        }
        return false
    }
    
    //입력된 수식을 연산자 우선순위에 맞게 후위표기로 변경
    private func infix_Postfix() -> [String] {
       var postfix:[String] = []
       var stack:[String] = []
        for tokenValue in (infix_Expr.map { $0.value }) {
            if tokenValue == "+" || tokenValue == "-" || tokenValue == "×" || tokenValue == "÷" {
                while !stack.isEmpty && (priority(tokenValue) <= priority(stack.last!)){
                    postfix.append(stack.popLast()!)
                }
                stack.append(tokenValue)
            }
            else if tokenValue == "(" {
                stack.append(tokenValue)
            }
            else if tokenValue == ")" {
                var top_op = stack.popLast()!
                while top_op != "("{
                    postfix.append(top_op)
                    top_op = stack.popLast()!
                }
            }
            else{
                postfix.append(tokenValue)
            }
        }
        while !stack.isEmpty {
            postfix.append(stack.popLast()!)
        }
        return postfix
    }
    
    //변경된 후위표기 식을 스택을 통해 계산
    private func calculation() -> [Token] {
       let postfix = infix_Postfix()
       var stack:[String] = []
        for i in postfix{
            if i != "+" && i != "-" && i != "×" && i != "÷" && i != "%" {
                stack.append(i)
            }
            else {
                if let str2 = stack.last, let str1 = stack.secondLast,
                   let num1 = Decimal(string: str1), let num2 = Decimal(string: str2) {
                    stack.removeLast(); stack.removeLast()
                    if i == "+"{
                        stack.append("\(num1 + num2)")
                    }
                    else if i == "-" {
                        stack.append("\(num1 - num2)")
                    }
                    else if i == "×" {
                        stack.append("\(num1 * num2)")
                    }
                    else if i == "÷" {
                        if str2 != "0" {
                            stack.append("\(num1 / num2)")
                        }
                        else{   // 0으로 나누는 예외처리
                            isError = true
                            return [Token(value: "정의되지 않음")]
                        }
                    }
                    else if i == "%" {
                        stack.append("\(num1)")
                        stack.append("\(num2 / 100)")
                    }
                }
                else if let str = stack.last, let num = Decimal(string: str), i == "%" {
                    stack.removeLast()
                    stack.append("\(num / 100)")
                }
                //  잘못된 입력으로 인해 popLast() 들에 의해 데이터가 소멸된다면 복구시켜야 할 소요는 있지 않을까?
                else {
                    isError = true
                    return displayExpr //  계산 중 오류 있었을 때인데 다양한 케이스가 존재할 수 있음
                }
            }
        }
        return [Token(value: stack.removeLast())]
    }
    
    private func isRawExpr() -> Bool {
        return !infix_Expr.map { $0.value } .contains {
            ["+", "-", "×", "÷", "%"].contains($0)  //  priority()로 어떻게 할 수 있을듯?
        }
    }
    
    func bracketCorrection() -> Bool { // 괄호 쌍이 안맞을 때
        var stack: [String] = infix_Expr.filter { $0.value == "(" || $0.value == ")" }.map { $0.value }
        
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
        rbracketAddCount = stack.count
        return stack.count == 0
    }
    
    func setNumberFmt(number: String, round: Bool = false, portrait: Bool, historic: Bool = false) -> String {
        if -1 < priority(number) || isError {  //  숫자 아님 or 계산 오류일 시
            return number
        }
        
        let fmt = NumberFormatter()
        
        if round {
            fmt.numberStyle = .scientific
            fmt.exponentSymbol = "e"
            guard let sci = fmt.string(for: Decimal(string: number)) else { return number }
            
            if let eIndex = sci.firstIndex(of: "e") {
                let exponent = Int(sci[sci.index(after: eIndex)...].filter{ $0 != "-" })!   //  e뒤에 숫자
                
                if portrait {
                    if exponent < (number.contains(".") ? 8 : 9) {
                        fmt.numberStyle = .decimal
                        fmt.maximumFractionDigits = number.first! == "0" ? 8 + exponent : 9 - number.filter{ $0 != "-" }.split(separator: ".").first!.count    //  first가 오류날 수 있는 경우는 number.filter 의 결과가 "" 일때
                        return fmt.string(for: Decimal(string: number))!
                    }
                    
                    if exponent <= 18 || abs(Decimal(string: number)!) < 1 {
                        fmt.maximumFractionDigits = exponent - (number.contains(".") ? 1 : 3)
                        return fmt.string(for: Decimal(string: number))!
                    }
                    
                    if let first = (sci.split(separator: "e").map { String($0) }).first {
                        if var firstNum = first.split(separator: ".").first {
                            firstNum = firstNum.split(separator: "-").last!
                            if firstNum.count == 1  {
                                //  [-500, 0] 부분
                                if Decimal(string: "\(Int(firstNum)!)" + String(repeating: "9", count: exponent))! - Decimal(499) <= abs(Decimal(string: number)!) &&
                                    abs(Decimal(string: number)!) <= Decimal(string: "\(Int(firstNum)! + 1)" + String(repeating: "0", count: exponent))! {
                                    fmt.maximumFractionDigits = exponent - (number.contains(".") ? 1 : 3)
                                    return fmt.string(for: Decimal(string: number))!
                                }
                                //  (0, 500] 부분
                                if Decimal(string: "\(Int(firstNum)! - 1)" + String(repeating: "9", count: exponent))! <= abs(Decimal(string: number)!) &&
                                    abs(Decimal(string: number)!) <= Decimal(string: "\(Int(firstNum)!)" + String(repeating: "0", count: exponent))! + Decimal(500) {
                                    fmt.maximumFractionDigits = exponent - (number.contains(".") ? 1 : 3)
                                    return fmt.string(for: Decimal(string: number))!
                                }
                            }
                        }
                    }
                    fmt.numberStyle = .decimal
                    return fmt.string(for: Decimal(string: number))!
                }
                else {  //  가로 모드
                    
                }
            }
        }
        
        fmt.numberStyle = .decimal
        
        let dotIndex = number.firstIndex(of: ".") ?? number.endIndex
        var returnValue = fmt.string(for: Decimal(string: String(number[..<dotIndex])))!
        if historic && returnValue.last == "." {    // history일 경우에는 n. 형태로 나오지 않게 함
            returnValue.removeLast()
        }
        let fraction = String(number[dotIndex...])
        if number.contains("-") && returnValue.first != "-" {
            returnValue = "-" + returnValue
        }
        return returnValue + fraction
    }
    
    func scrollUnavailable(innerWidth: CGFloat, outerWidth: CGFloat) -> Bool {
        if currentAC {
//            let sizeArr = (0...9).reversed().map { Double($0) * 0.1 }
//            for num in sizeArr {
//                
//            }
        }
        return innerWidth <= outerWidth
    }
    
    func tapHistyrExpr() {
        currentAC = false
//        infix_Expr = historyExpr.map { Token(value: $0, automatic: false) }
        infix_Expr = historyExpr
        displayExpr = infix_Expr
        historyExpr.removeAll()
    }
    
    func handleButtonPress(_ button: BtnType) {
        if button == .add {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "0"))
                }
                if !endsWithNumber() {
                    if let lastValue = infix_Expr.last?.value {
                        if priority(lastValue) != 0 && lastValue != "%" { //    lastValue가 괄호가 아닐 때 and % 아닐 때
                            infix_Expr.removeLast()
                            displayExpr.removeLast()
                        }
                    }
                }
                infix_Expr.append(Token(value: "+"))
                displayExpr.append(Token(value: "+"))
            }
        }
        else if button == .sub {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "0"))
                }
                if !endsWithNumber() {
                    if let lastValue = infix_Expr.last?.value {
                        if priority(lastValue) != 0 { //    lastValue가 괄호가 아닐 때
                            infix_Expr.removeLast()
                            displayExpr.removeLast()
                        }
                    }
                }
                infix_Expr.append(Token(value: "-"))
                displayExpr.append(Token(value: "-"))
            }
        }
        else if button == .mul {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "0"))
                }
                if !endsWithNumber() {
                    if let lastValue = infix_Expr.last?.value {
                        if priority(lastValue) != 0 { //    lastValue가 괄호가 아닐 때
                            infix_Expr.removeLast()
                            displayExpr.removeLast()
                        }
                    }
                }
                infix_Expr.append(Token(value: "×"))
                displayExpr.append(Token(value: "×"))
            }
        }
        else if button == .div {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "0"))
                }
                if !endsWithNumber() {
                    if let lastValue = infix_Expr.last?.value {
                        if priority(lastValue) != 0 { //    lastValue가 괄호가 아닐 때
                            infix_Expr.removeLast()
                            displayExpr.removeLast()
                        }
                    }
                }
                infix_Expr.append(Token(value: "÷"))
                displayExpr.append(Token(value: "÷"))
            }
        }
        else if button == .equal {
            if !bracketCorrection() { // 괄호 쌍이 안맞을 경우
                let bracGap = infix_Expr.filter({ $0.value == "(" }).count - infix_Expr.filter({ $0.value == ")" }).count
                if bracGap < 0 {
                    infix_Expr = Array(repeating: Token(value: "("), count: -bracGap) + infix_Expr
                }
                else {
                    infix_Expr += Array(repeating: Token(value: ")"), count: bracGap)
                }
                displayExpr = infix_Expr
            }
            if infix_Expr.isEmpty || isRawExpr() {
                return
            }
//            historyExpr = displayExpr.enumerated().map { index, item in
//                var modItem = item  // 복사본 생성
//                modItem.automatic = false  // 복사본 수정
//                return setNumberFmt(
//                    number: modItem.value,
//                    round: displayExpr.count > 1 && index == 0,
//                    portrait: true,
//                    historic: true
//                )
//            }
            historyExpr = displayExpr
            displayExpr = calculation()
            currentAC = true
            infix_Expr = displayExpr
            
            if !isError {
                id = UUID()
                
                var historyData = [today: [History(id: id, historyExpr: historyExpr, displayExpr: displayExpr)]]
                if let data = UserDefaults.standard.data(forKey: today) {
                    if let decodeData = try? JSONDecoder().decode([String: [History]].self, from: data), let todayValue = decodeData[today] {
                        if let firstValue = todayValue.first, firstValue.historyExpr != historyData[today]!.first?.historyExpr {    //  마지막에 저장된 수식과 다를 경우만 새로 저장
                            historyData[today] = historyData[today]! + todayValue
                        }
                        else {
                            historyData[today] = todayValue
                        }
                    }
                }
                else {  //  저장되는 날짜만 따로 모으는 코드
                    if let arr = UserDefaults.standard.array(forKey: "dateArr") as? [String] {
                        UserDefaults.standard.set([today] + arr, forKey: "dateArr")
                    }
                    else {
                        UserDefaults.standard.set([today], forKey: "dateArr")
                    }
                }
                if let encodeData = try? JSONEncoder().encode(historyData) {
                    UserDefaults.standard.set(encodeData, forKey: today)
                }
            }
        }
        else if button == .allClear {
            displayExpr = [Token(value: "0")]
            isError = false
            infix_Expr.removeAll()
            historyExpr.removeAll()
        }
        else if button == .clear {
            displayExpr.removeLast()
            if !infix_Expr.isEmpty {
                let last = infix_Expr.removeLast().value
                if priority(last) == -1 && !isError {
                    if last.count > 1 {
                        let index = last.index(last.endIndex, offsetBy: -1)
                        infix_Expr.append(Token(value: String(last[..<index])))
                    }
                    displayExpr = infix_Expr
                }
            }
            if displayExpr.isEmpty {
                displayExpr = [Token(value: "0")]
            }
            
        }
        else if button == .dot {
            if isError || infix_Expr.isEmpty {
                infix_Expr = [Token(value: "0.")]
            }
            else if endsWithNumber() && !infix_Expr.last!.value.contains(".") {
                infix_Expr[infix_Expr.endIndex - 1].value += "."
            }
            displayExpr = infix_Expr
        }
        else if button == .oppo {
            if !isError {
                if displayExpr != [Token(value: "0")] { //  0일때는 동작 안함
                    if endsWithNumber() {   //  수식이 숫자로 끝날 시
                        if let num = infix_Expr.popLast() {  //  endsWithNumber()가 infix_Expr이 비어있을 시 nil 반환
                            if let op = infix_Expr.last?.value, op == "-" { // 마지막 연산자가 - 일 경우에는 +로 자동 변경
                                infix_Expr[infix_Expr.endIndex - 1].value = "+"
                                infix_Expr.append(num)
                            }
                            else {
                                infix_Expr.append(Token(value: "("))    //  괄호쌍은 숫자와 분리해야 함
                                infix_Expr.append(Token(value: "-\(num.value)"))
                                infix_Expr.append(Token(value: ")"))
                            }
                        }
                    }
                    else if infix_Expr.last?.value == ")" { // 닫히는 괄호일 시
                        infix_Expr.removeLast()
                        let num = String(infix_Expr.removeLast().value.dropFirst())
                        infix_Expr[infix_Expr.endIndex - 1] = Token(value: num)
                    }
                    displayExpr = infix_Expr
                }
            }
        }
        else if button == .perc {
            if !isError {
                if infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "0"))
                }
                if !endsWithNumber() {
                    infix_Expr.removeLast()
                    displayExpr.removeLast()
                }
                infix_Expr.append(Token(value: "0"))
                displayExpr.append(Token(value: "0"))
            }
        }
        else if button == .lbrac {
            if !isError {
                if endsWithNumber() && !infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "×"))
                }
                infix_Expr.append(Token(value: "("))
            }
        }
        else if button == .rbrac {
            if !isError {
                if endsWithNumber() && !infix_Expr.isEmpty {
                    infix_Expr.append(Token(value: "×"))
                }
                infix_Expr.append(Token(value: ")"))
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
            modeOn = true
        }
        else { //  숫자 버튼을 눌렀을 때
            if let num: String = button.BtnDisplay.string {
                if isError {
                    historyExpr.removeAll()
                    infix_Expr = [Token(value: num)]
                    displayExpr = [Token(value: num)]
                    isError = false //  새로운 계산 식이 시작이므로 다시 에러 플래그를 false로
                }
                else if let last = infix_Expr.last?.value {
                    if let decimalValue = Decimal(string: last), priority(last) == -1 {  //  수식이 숫자로 끝났을 때, priority() 가 있는 이유는 +,-가 Decimal()에 반환값이 0이기 때문
                        if decimalValue == 0 {
                            if last == "0" {
                                infix_Expr = [Token(value: num)]
                            }
                            else if last.contains(".") {
                                infix_Expr[infix_Expr.endIndex - 1].value += num
                            }
                            else {
                                infix_Expr.append(Token(value: num))
                            }
                        }
                        else if currentAC {
                            infix_Expr = [Token(value: num)]
                        }
                        else {
                            infix_Expr[infix_Expr.endIndex - 1].value += num
                        }
                        displayExpr = infix_Expr
                    }
                    else {
                        if bracketCorrection() {
                            if last.last == "." {    //  소수점으로 끝나는 상태일 때
                                infix_Expr[infix_Expr.endIndex - 1].value += num
                            }
                            else {
                                if last.last == ")" {
                                    infix_Expr.append(Token(value: "×", automatic: true))   //  사용자가 입력하지 않아도 자동으로 들어간걸 알아보도록
                                }
                                infix_Expr.append(Token(value: num))
                            }
                            displayExpr = infix_Expr
                        }
                        else {
                            infix_Expr[infix_Expr.endIndex - 1].value = num
                            infix_Expr.append(Token(value: ")"))
                        }
                    }
                }
                else {
                    infix_Expr = [Token(value: num)]
                    displayExpr = [Token(value: num)]
                }
                
            }
        }
        
        // 아래 조건문들은 위에 있는 조건문들에 다 일일이 쓰면 currentAC 관련 코드를 넣으면 더러워질 것 같아서 따로 빼놓음
        if infix_Expr.isEmpty {
            currentAC = true
        }
        else if button == .clear {
            if displayExpr == [Token(value: "0")] || isError {
                currentAC = true
            }
        }
        else if button == .equal || button == .emoji {   // equal은 특수성 때문에 위쪽 조건문에서 처리했음
            // 이 경우엔 currentAC 값을 유지한다
        }
        else {
            if !isError && infix_Expr.last?.value != "0" {
                currentAC = false
            }
        }
        
        if !currentAC { //  !currentAC는 현재 수식이 입력 중이라는 것을 의미함
//            historyExpr.removeAll()
        }
    }
}

extension Array {
    var secondLast: Element? {
        count > 1 ? self[count - 2] : nil
    }
}
