//
//  numCalc.swift
//  Calculator
//
//  Created by 최윤진 on 2023/08/10.
//

import Foundation

class numCalc{
    static var num:String = "0"//화면에 보여지는 수
    static var prevnum = NSDecimalNumber.zero // 과거의 계산이 된 수
    static var prevop = "" //과거의 계산에 사용된 마지막 연산자
    static var currentnum = NSDecimalNumber.zero // 입력된 수
    static var currentop = "" //입력된 수를 연산할 연산자

    static func setNum(newNum:String) -> String{ //키패드에서 숫자 입력받는 부분
        if num == "0" || num == "오류"{
            num = newNum
        }
        else{
            num += newNum
        }
        return num
    }
    
    static func modifyNum(){
        
    }

    static func Clear() -> String{
        num = "0"
        currentnum = 0
        return num
    }

    static func Opposite() -> String {
        if num.first == "-"{
            num.removeFirst()
        }
        else{
            num = "-" + num
        }
        currentnum = currentnum.multiplying(by: -1)
        return num
    }

    static func Percent() -> String {
        if currentnum != 0 && num != "오류"{
            currentnum = currentnum.dividing(by: 100)
            modifyNum()
        }
        return num
    }

    static func Add() -> String {
        currentnum = NSDecimalNumber(string: num)
        if prevop == "+"{
            
        }
        else if prevop == "-"{
            
        }
        else if prevop == "*"{
            
        }
        else if prevop == "/"{
            
        }
        
        prevop = "+"
       return num
    }

    static func Sub() -> String {
      
        return num
    }

    static func Mul() -> String {
     
        return num
    }

    static func Div() -> String {
    
        return num
    }

    static func Equal() -> String {  
      
        return num
    }

    static func Dot() -> String {
        if !num.contains(".") && num != "오류"{
            num += "."
        }
        return num
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
        currentnum = currentnum.multiplying(by: currentnum)
        modifyNum()
        return num
    }
    static func X3() -> String{
        currentnum = NSDecimalNumber(string:"\(pow(currentnum.decimalValue,3))")
        modifyNum()
        return num
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
        currentnum = NSDecimalNumber(string: "3.141592653589793")
        modifyNum()
        return num
    }
    static func Rand(){

    }

}
