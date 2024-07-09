//
//  numCalc.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//  개발 중 스파게티 코드가 되어 아예 리팩터링 중

import Foundation


class Calculation{
    private static var displayNum:String = "0"  //화면에 보여지는 수
    private static var infix_Expr:[String] = []  // 입력 식(중위)
    private static var isNewInput = true    //  숫자가 입력되는 것이 처음인지
    
    private static func priority(_ op: String) -> Int{    // 연산자 우선순위
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
    
    private static func endsWithNumber() -> Bool{ // 입력된 식의 마지막이 숫자인지 판별
        let last = infix_Expr.last  // nil이면 식 infix_Expr이 빈 것
        if last == nil || (last != "+" && last != "-" && last != "*" && last != "/" && last != "(" && last != ")"){
            return true
        }
        return false
    }
    
    private static func infix_Postfix() -> [String]{ //입력된 수식을 우선순위에 맞게 후위표기로 변경
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
    
    
    private static func calculation() -> String{ //변경된 후위표기로 계산
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
                    stack.append((NSDecimalNumber(string: num1).adding(NSDecimalNumber(string: num2))).stringValue)
                }
                else if i == "-"{
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
        return stack.popLast()!
    }
    
    
    
    static func setNum(newNum:String) -> String{ //키패드에서 숫자 입력받는 부분
        if displayNum == "0" || displayNum == "오류" || isNewInput{
            displayNum = newNum
            isNewInput = false
            infix_Expr.append(displayNum)
        }
        else{
            displayNum += newNum
            infix_Expr[infix_Expr.count - 1] = displayNum
        }
        return displayNum
    }
    
    static func Clear() -> String{ //clear 버튼
        displayNum = "0"
        isNewInput = true
        infix_Expr.removeAll()
        return displayNum
    }
    
    static func Opposite() -> String { // +/- 버튼
        if displayNum.first == "-"{
            displayNum.removeFirst()
        }
        else{
            displayNum = "-" + displayNum
        }
        isNewInput = true
        return displayNum
    }
    
    static func Percent() -> String { // % 버튼
        isNewInput = true
        return displayNum
    }
    
    static func Add() -> String { // + 버튼
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        infix_Expr.append("+")
        isNewInput = true
        return displayNum
    }
    
    static func Sub() -> String { // - 버튼
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        infix_Expr.append("-")
        isNewInput = true
        return displayNum
    }
    
    static func Mul() -> String { // * 버튼
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        infix_Expr.append("*")
        isNewInput = true
        return displayNum
    }
    
    static func Div() -> String { // / 버튼
        if !endsWithNumber(){
            infix_Expr.removeLast()
        }
        infix_Expr.append("/")
        isNewInput = true
        return displayNum
    }
    
    static func Equal() -> String {  // = 버튼
        if !endsWithNumber(){ //부호로 식이 끝났을 때
            infix_Expr.removeLast()
        }
        displayNum = calculation()
        isNewInput = true
        return displayNum
    }
    
    static func Dot() -> String { // 소수점 버튼
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
