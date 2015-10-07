//
//  CalculatorController.swift
//  Пулька
//
//  Created by Admin on 29.08.15.
//  Copyright (c) 2015 Алексей. All rights reserved.
//

import UIKit //переделать логику калькулятора, чтобы было как в айфоновском калькуляторе
//тестировал на 5 айфоне, нужно поработать с constraints

//добавить функционал в AC/C?

//сделать стирание цифр! то есть пишешь 788, стираешь послуднюю цифру и получаешь 78

//привести в соответствие с MVC

//сделать ли первоначальный отступ цифры?

//для операций взять логику калькулятора айфона, чтобы 6*6-6*6 было равно 0 (т е приоритет операций ввести)

//сделать операцию %

//пофиксил баг: число на экране калькулятора, жмешь кнопку назад, включаешь опять калькулятор, видишь 0, жмешь арифметическую операцию, появляется старое число

//при большем наборе чисел будет вид 1e+

//на ipad air слева полоса белая (как и в основной UI для строк) (т е доработать constraints)

//вместе с изменением размера кнопок сделать изменение их содержимого (т е поработать с шрифтами)

//зайти в калькулятор, сменить ориентацию экрана, выйти из калькулятора, на симуляторе баг с анимацией в таком случае

//возможно при вводе цифр сделать уменьшение шрифта результата до какой-то степени, а больше фиксированного количества символов не реагировать на ввод

//осторожно с конвертированием из double в менее объемные типы, а то например если вводить много 9, то приложение может вылететь, в данном случае будет показывать Inf (в версии без обрезания вывода на экран)

//чтобы AC менялась на <-, которая стирала бы последний введенный символ

var x:Double = 0 //current
var y:Double = 0 //previous
var operationActive = 0
var enterFlag = true
var yFlag = true
var hasPoint = false
var power = 1.0 //сделать Int
//var numCount = 0
//let numMax = 9




class CalculatorController: UIViewController {
    var indexPath:Int? = nil
    var controllerIndex:String = ""
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    @IBAction func cancelClick(sender: UIBarButtonItem) {
        self.clearAllCrear(nil)
        self.navigationController?.popViewControllerAnimated(true)
         NSNotificationCenter.defaultCenter().postNotificationName("ReloadDataInTable", object: nil)
    }
    
    func printResult() { //убираем .0 //пофиксил лаги, как например 0.0 не ставится, но если нажать 1, то будет уже 0.01

        switch x.description {
        case let z where z.hasSuffix(".0"):
            self.result.text = String(format: "%.0f", x)
        default:
            self.result.text = x.description
            
        }
//        self.result.text = x.description
    }
    
    func updateScreen() {
        switch x.description {
        case let z where z.hasSuffix(".0"):
            if hasPoint {
                if power == 1.0 {
                    self.result.text = String(format: "%.0f", x)+"."
                } else {
                    self.result.text = String(format: "%.\(Int(power)-1) f", x)
                }
            } else {
                self.result.text = String(format: "%.0f", x)
            }
        default:
            self.result.text = String(format: "%.\(Int(power)-1) f", x)
            
        }
    }
    
    func sign(x:Double) -> Double {
//        return x<0?-1:1
        if x<0 {
           return -1
        } else {
            return 1
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        printResult() //чтобы при возвращении в калькулятор было высвечено текущее число
        let doneButton:UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "addSum:")
        
   
        
        self.navigationItem.setRightBarButtonItem(doneButton, animated: true)
        updateScreen()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    func addSum(sender:UIButton) {
        let sum = result.text
        let number = NSNumberFormatter().numberFromString(sum!)
        let doubleSum = number!.doubleValue
        print("?")
        if (controllerIndex == "singeltone"){
            if (doubleSum != 0 || SingletoneArray.singletone.arrayOfConatcs[indexPath!].sum.count == 0){
                print("asd?")
                SingletoneArray.singletone.arrayOfConatcs[indexPath!].sum.append(doubleSum)
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadDataInTable", object: nil)
            }
        } else if (controllerIndex == "favorite") {
            if (doubleSum != 0 || SingletoneArray.singletone.arrayForSum[indexPath!].sum.count == 0){
                SingletoneArray.singletone.arrayForSum[indexPath!].sum.append(doubleSum)
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadDataInFavorite", object: nil)
            }
        }
        self.clearAllCrear(nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func numberClick(sender: UIButton) { //а если знак сменить и дописывать числа, тоже нужно учесть
        if enterFlag {
            x=0
            enterFlag=false
//            numCount = 0
            hasPoint=false
            power = 1.0
        }
        
//        if numCount<numMax {
        if !hasPoint {
//            x=x*10 + Double(sender.tag)
            x=x*10 + Double(sender.tag)*sign(x)
//            printResult()
            updateScreen()
            //        self.result.text = String(format:"%f", x)

        }
        else {
//            x = x + Double(sender.tag)/pow(10, power)
            x = x + Double(sender.tag)/pow(10, power)*sign(x)
            power++
//            printResult()
            updateScreen()
        }
//        }
//        numCount++
            }
    
    @IBAction func operationClick(sender: UIButton) {
        if !enterFlag && yFlag {
            switch operationActive {
            case 1001:
                x=y / x
            case 1002:
                x=y * x
            case 1003:
                x=y - x
            case 1004:
                x=y + x
                
            default:
                printResult() //поведение стандартного калькулятора тут применение последней операции, т е 8+2+1=11=12=...
//                self.result.text = x.description //1005 подходит  //скорее всего нужен printResult()
            }
        }
        operationActive = sender.tag
        y=x
//        printResult()
        enterFlag = true
        yFlag = true
//        hasPoint=false
//        power = 1.0
        printResult()
    }
    
    @IBAction func inverseClick(sender: UIButton) {
        x = -x
//        printResult()
//        updateScreen()
        if enterFlag {
            printResult()
        } else {
            updateScreen()
        }
    }
    
    @IBAction func decimalClick(sender: UIButton) {
        if !hasPoint {
            hasPoint=true
//            printResult()
//            updateScreen()
        }
        if enterFlag {
            printResult()
        } else {
            updateScreen()
        }
    }
    
    @IBAction func clearAllCrear(sender: AnyObject?) {
        hasPoint = false
        x=0
        y=0
//        printResult()
        operationActive = 0
        enterFlag = true
        yFlag = true
        hasPoint = false
        power = 1.0
        printResult()
    }
    
    
    
    @IBAction func percentClick(sender: UIButton) {
//        x = x/100
////        hasPoint=true
////        yFlag=false
//        enterFlag = true
//        power = 0
//        printResult()
    }
    
    
    @IBOutlet weak var result: UILabel! //скролить в сторону или округлять?
}