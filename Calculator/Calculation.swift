//
//  numCalc.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//
//  2 + 3 * 4 * 5 * -> 60 출력 (우선순위가 높은것들만 우선 계산)
//  2 + 3 * 4 * 5 = -> 62 출력 (식 전체 계산)

import Foundation


class Calculation{
    private static var displayNum:String = "0"  //  화면에 보여지는 수
    static var infix_Expr:[String] = ["0"]  // 입력 식(중위) / 입력이 3, + 일 경우 정상적인 연산이 되어야 하므로 ["0"]으로 초기화
    private static var isNewInput = true    //  숫자가 입력되는 것이 처음인지
    private static var lastOp = ""  //  마지막으로 입력된 연산자
    
    // 연산자 우선순위
    private static func priority(_ op: String) -> Int{
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
    private static func endsWithNumber() -> Bool{
        let last = infix_Expr.last  // nil이면 식 infix_Expr이 빈 것
        if last == nil || (last != "+" && last != "-" && last != "*" && last != "/" && last != "(" && last != ")"){
            return true
        }
        return false
    }
    
    //입력된 수식을 연산자 우선순위에 맞게 후위표기로 변경
    private static func infix_Postfix() -> [String]{
        var postfix:[String] = []
        var stack:[String] = []
        for i in infix_Expr{
            if i == "+" || i == "-" || i == "*" || i == "/"{
                while !stack.isEmpty && (priority(i) <= priority(stack.last!)){
                    postfix.append(stack.popLast()!)
                }
                stack.append(i)
            }
            else if i == "("{
                stack.append(i)
            }
            else if i == ")"{
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
        while !stack.isEmpty{
            postfix.append(stack.popLast()!)
        }
        return postfix
    }
    
    //변경된 후위표기 식을 스택을 통해 계산
    private static func calculation(endWithPrio1: Bool = true) -> String{ // endsWithPrio1: 마지막으로 식에 입력되는 연산자가 + || - 이면 참
        let postfix = infix_Postfix()
        var stack:[String] = []
        for i in postfix{
            if i != "+" && i != "-" && i != "*" && i != "/"{
                stack.append(i)
            }
            else{
                let num2 = stack.popLast()!
                let num1 = stack.popLast()!
                if i == "+"{
                    if !endWithPrio1{
                        stack.append(num2)
                        break
                    }
                    stack.append((NSDecimalNumber(string: num1).adding(NSDecimalNumber(string: num2))).stringValue)
                }
                else if i == "-"{
                    if !endWithPrio1{
                        stack.append(num2)
                        break
                    }
                    stack.append((NSDecimalNumber(string: num1).subtracting(NSDecimalNumber(string: num2))).stringValue)
                }
                else if i == "*"{
                    stack.append((NSDecimalNumber(string: num1).multiplying(by: NSDecimalNumber(string: num2))).stringValue)
                }
                else if i == "/"{
                    if num1 != "0"{
                        stack.append((NSDecimalNumber(string: num1).adding(NSDecimalNumber(string: num2))).stringValue)
                    }
                    else{   // 0으로 나누는 예외처리
                        return "오류"
                    }
                }
            }
        }
        return stack.removeLast()
    }
    
    //키패드에서 숫자 입력받는 함수
    static func setNum(newNum: String) -> String{
        if displayNum == "0" || displayNum == "오류" || isNewInput{
            displayNum = newNum
            isNewInput = false
            if infix_Expr == ["0"]{ //  초기 상태일 때
                infix_Expr[0] = newNum
            }
            else{
                infix_Expr.append(newNum)
            }
        }
        else{
            displayNum += newNum
            infix_Expr[infix_Expr.count - 1] = displayNum
        }
        return displayNum
    }
    
    //clear 버튼
    static func Clear() -> String{
        displayNum = "0"
        isNewInput = true
        lastOp = ""
        infix_Expr = ["0"]
        return displayNum
    }
    
    // +/- 버튼
    static func Opposite() -> String {
        if displayNum.first == "-"{
            displayNum.removeFirst()
        }
        else{
            displayNum = "-" + displayNum
        }
        isNewInput = true
        return displayNum
    }
    
    // % 버튼
    static func Percent() -> String {
        isNewInput = true
        return displayNum
    }
    
    // + 버튼
    static func Add() -> String {
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        displayNum = calculation()
        infix_Expr.append("+")
        lastOp = "+"
        isNewInput = true
        return displayNum
    }
    
    // - 버튼
    static func Sub() -> String {
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        displayNum = calculation()
        infix_Expr.append("-")
        lastOp = "-"
        isNewInput = true
        return displayNum
    }
    
    // * 버튼
    static func Mul() -> String {
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        displayNum = calculation(endWithPrio1: false)
        
        infix_Expr.append("*")
        lastOp = "*"
        isNewInput = true
        return displayNum
    }
    
    // / 버튼
    static func Div() -> String {
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        displayNum = calculation(endWithPrio1: false)
        infix_Expr.append("/")
        lastOp = "/"
        isNewInput = true
        return displayNum
    }
    
    // = 버튼
    static func Equal() -> String {
        if !endsWithNumber(){ //부호로 식이 끝났을 때
            infix_Expr.append(infix_Expr[infix_Expr.count - 2]) //입력이 2, + 일 때 = 을 계속 누르면 해당 연산이 계속 이어져 나가야 함
        }
        if lastOp == "="{   //연속으로 = 를 입력할 시
            lastOp = infix_Expr[infix_Expr.count - 2]
            let lastNum = infix_Expr.last!
            infix_Expr = [calculation()]
            infix_Expr.append(lastOp)
            infix_Expr.append(lastNum)
        }
        displayNum = calculation()
        isNewInput = true
        lastOp = "="
        
        return displayNum
    }
    
    // 소수점 버튼
    static func Dot() -> String {
        if displayNum == "오류"{
            displayNum = "0."
            
        }
        else if !displayNum.contains("."){
            displayNum += "."
        }
        return displayNum
    }
    
    //아래부터 공학계산기 함수
    
    static func Lbrac(){
        
    }
    static func Rbrac(){
        
    }
    static func Mc(){
        
    }
    static func Madd(){
        
    }
    static func Msub(){
        
    }
    static func Mr(){
        
    }
    static func Sec(){
        
    }
    static func X2() -> String {
        
        return displayNum
    }
    static func X3() -> String{
        
        return displayNum
    }
    static func XY(){
        
    }
    static func Ex(){
        
    }
    static func Tenx(){
        
    }
    static func Rev(){
        
    }
    static func X_2(){
        
    }
    static func X_3(){
        
    }
    static func X_y(){
        
    }
    static func Ln(){
        
    }
    static func Log10(){
        
    }
    static func Xf(){
        
    }
    static func Sin(){
        
    }
    static func Cos(){
        
    }
    static func Tan(){
        
    }
    static func E(){
        
    }
    static func EE(){
        
    }
    static func Rad(){
        
    }
    static func Sinh(){
        
    }
    static func Cosh(){
        
    }
    static func Tanh(){
        
    }
    static func Pi() -> String{
//        curr_num = NSDecimalNumber(string: "3.141592653589793")
        return displayNum
    }
    static func Rand(){
        
    }
    
}
