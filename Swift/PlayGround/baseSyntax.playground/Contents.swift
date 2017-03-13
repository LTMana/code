//: Playground - noun: a place where people can play

import UIKit


//变量与常量定义
var hello = "Hello, playground"

let helloStr:String = "你好swift"

let countInt:Int = 444

var count = 42.3;


var sum = Double(countInt) + count


var bbb,ccc,ddd:Int

bbb = 001
ccc = 002
ddd = 003




//变量重命名
typealias AudioSample =  Int

var textCount:AudioSample = 324



//整数取值范围

let minValue = UInt8.min
let MaxValue = UInt8.max



//输出
print("你好世界")
print("数字是:\(count)")


//逻辑判断

let orangesAreOrange = true

let turnipsAreDelicious = false

if orangesAreOrange {
    print("\(orangesAreOrange)")
}else{
    print("\(turnipsAreDelicious)")
}

//如果你在需要使用 Bool 类型的地方使用了非布尔值，Swift 的类型安全机制会报错。下面的例子会报告一个编译时错误：
//let i = 1
//if i {
//    // 这个例子不会通过编译，会报错
//}


let i = 1
if i == 1 {
    // 这个例子会编译成功
}

//元组
let http404Error = (404,"Not Found")

let (statusCode,Message) = http404Error

print("The status code is \(statusCode)")
// 输出 "The status code is 404"
print("The status message is \(Message)")
// 输出 "The status message is Not Found"

let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")

print("The status code is \(http404Error.0)")
// 输出 "The status code is 404"
print("The status message is \(http404Error.1)")



//可选类型
var possibleNumber:Int? = nil
possibleNumber = 4
//let convertedNumber = Int(possibleNumber)
print(possibleNumber!)
