//
//  numCalc.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//  개발 중 스파게티 코드가 되어 아예 리팩터링 중

import Foundation

class Calculation{
    static var displayNum:String = "0"//화면에 보여지는 수
    static var prev_num = NSDecimalNumber.zero // 과거의 계산이 된 수
    static var prev_op = "" //과거의 계산에 사용된 마지막 연산자
    static var curr_num = NSDecimalNumber.zero // 입력된 수
    static var curr_op = "" //입력된 수를 연산할 연산자

    static func setNum(newNum:String) -> String{ //키패드에서 숫자 입력받는 부분
        if displayNum == "0" || displayNum == "오류"{
            displayNum = newNum
        }
        else{
            displayNum += newNum
        }
        return displayNum
    }

    static func Clear() -> String{ //clear 버튼
        displayNum = "0"
        curr_num = 0
        return displayNum
    }

    static func Opposite() -> String { // - 버튼
        if displayNum.first == "-"{
            displayNum.removeFirst()
        }
        else{
            displayNum = "-" + displayNum
        }
        curr_num = curr_num.multiplying(by: -1)
        return displayNum
    }

    static func Percent() -> String { // % 버튼
        if curr_num != 0 && displayNum != "오류"{
            curr_num = curr_num.dividing(by: 100)
        }
        return displayNum
    }
    
     static func Add() -> String { // + 버튼
        curr_num = NSDecimalNumber(string: displayNum)
        if prev_op == "+"{
            
        }
        else if prev_op == "-"{
            
        }
        else if prev_op == "*"{
            
        }
        else if prev_op == "/"{
            
        }
        
        prev_op = "+"
       return displayNum
    }

    static func Sub() -> String { // - 버튼
      
        return displayNum
    }

    static func Mul() -> String { // * 버튼
     
        return displayNum
    }

    static func Div() -> String { // / 버튼
    
        return displayNum
    }

    static func Equal() -> String {  // = 버튼
      
        return displayNum
    }

    static func Dot() -> String { // 소수점 버튼
        if !displayNum.contains(".") && displayNum != "오류"{
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
        curr_num = curr_num.multiplying(by: curr_num)
        return displayNum
    }
    static func X3() -> String{
        curr_num = NSDecimalNumber(string:"\(pow(curr_num.decimalValue,3))")
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
        curr_num = NSDecimalNumber(string: "3.141592653589793")
        return displayNum
    }
    static func Rand(){

    }

}
