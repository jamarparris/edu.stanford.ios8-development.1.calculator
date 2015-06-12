//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Jamar Parris on 3/8/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    private var userIsInTheMiddleOfTypingANumber = false
    private var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        if let digit = sender.currentTitle {
        
            if userIsInTheMiddleOfTypingANumber {
                display.text = display.text! + digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        
        if display.text!.rangeOfString(".") != nil {
            return
        }
        
        self.appendDigit(sender)

    }
    
    @IBAction func removeDigit() {
        let length = count(display.text!)
        
        if  length < 2 {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
            return
        }
        
        let currentText = display.text!
        
        display.text = currentText.substringToIndex(advance(currentText.startIndex, length - 1))
    }
    
    @IBAction func setVariable(sender: UIButton) {
        if var symbol = sender.currentTitle {
            symbol.removeAtIndex(symbol.startIndex)
            brain.variableValues[symbol] = displayValue
            userIsInTheMiddleOfTypingANumber = false
            
            if let result = brain.evaluate() {
                displayValue = result
            }
        }
    }
    
    @IBAction func getVariable(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let symbol = sender.currentTitle {
            if let result = brain.pushOperand(symbol) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
            
        }
        
        history.text = brain.description + " = "
    
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
                return
            }
        }

        displayValue = nil
    }
    
    //computed property
    var displayValue: Double? {
        get {
            //as display.text can now contain ERR string, check to see if it's numberFromString returns nil
            if display.text != nil, let value = NSNumberFormatter().numberFromString(display.text!) {
                return value.doubleValue
            }
            
            return nil
        }
        
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
        }
    }
    
    @IBAction func clearCalculator() {
        // enter resets all the flags, so reuse here
        enter()
        
        //reset calculatorBrain
        brain = CalculatorBrain()
        
        //reset display text back to original
        display.text = "0"
        history.text = " "
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //println("\(segue.identifier) called")
    
        var destinationController = segue.destinationViewController as? UIViewController
        
        //account for controllers embedded in a UINavigationController
        if let navController = destinationController as? UINavigationController {
            destinationController = navController.visibleViewController
        }
        
        //ensure it's a graphViewController
        if let graphViewController = destinationController as? GraphViewController {
            
            //ensure identifier is set
            if let identifier = segue.identifier {
                
                ////set program variable on the graphViewController
                switch identifier {
                case "showGraph": graphViewController.program = brain.program
                default: break
                }
            }
        }
    
    }
    
}

