//
//  ViewController.swift
//  Calculator
//
//  Created by Jamar Parris on 3/8/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        
        if display.text!.rangeOfString(".") != nil {
            return
        }
        
        self.appendDigit(sender)

    }
    
    @IBAction func removeDigit() {
        
        let length = countElements(display.text!)
        
        if  length < 2 {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
            return
        }
        
        let currentText = display.text!
        
        display.text = currentText.substringToIndex(advance(currentText.startIndex, length - 1))
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        history.text = history.text! + " " + operation + " = "
        
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation { M_PI }
        default: break
        }
        
        
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
        }
    }
    
    //sqrt only takes one argument
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
        }
    }
    
    func performOperation(operation: () -> Double) {
        displayValue = operation()
    }
    
    var operandStack = Array<Double>()

    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operand stack = \(operandStack)")
        
        history.text = history.text! + " \(displayValue)"
    }
    
    //computed property
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
            
            //since enter was always called after performOperation anyways, move here
            enter()
        }
    }
    
    @IBAction func clearCalculator() {
        // enter resets all the flags, so reuse here
        enter()
        
        //empty the array
        operandStack.removeAll()
        println("operand stack = \(operandStack)")
        
        //reset display text back to original
        display.text = "0"
        history.text = ""
    }
    
}

