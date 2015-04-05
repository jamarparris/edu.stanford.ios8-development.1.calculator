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
    var brain = CalculatorBrain()
    
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
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            
            history.text = history.text! + " " + operation + " = "
            
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            history.text = history.text! + " \(displayValue)"
        } else {
            displayValue = 0
        }
        
    }
    
    //computed property
    var displayValue: Double {
        // in assignment2, need to make this optional and change displayValue = 0 to nil)
        get {
            println(display.text)
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set {
            display.text = "\(newValue)"
        }
    }
    
    @IBAction func clearCalculator() {
        // enter resets all the flags, so reuse here
        enter()
        
        //reset calculatorBrain
        brain = CalculatorBrain()
        
        //reset display text back to original
        display.text = "0"
        history.text = ""
    }
    
}

