//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jamar Parris on 4/4/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op : Printable //protocol, used for description that returns string representation
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ConstantOperand(String, () -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ConstantOperand(let constant, _):
                    return constant
                }
                
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    var variableValues = [String: Double]()
    
    init() {
        
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.ConstantOperand("π") { M_PI })
    }
    
    var description: String {
        get {
           let (desc, _) = evaluateDescription(opStack)
           if desc != nil {
                println("brain description: \(desc!)")
                return desc!
            } else {
                println("description is nil")
            }
            
            return " "
        }
    }
    
    private func evaluateDescription(ops: [Op]) -> (resultString: String?, remainingOps: [Op]) {
        
        println("remaining ops \(ops)")
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                let operandString = "\(operand)"
                return (operandString, remainingOps)
            case .UnaryOperation(let operationString, _):
                let operandEvaluation = evaluateDescription(remainingOps)
                if let operandString = operandEvaluation.resultString {
                    println("\(operationString)(\(operandString))")
                    return ("\(operationString)(\(operandString))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let operationString, _):
                let op1Evaluation = evaluateDescription(remainingOps)
                if let operand1String = op1Evaluation.resultString {
                    let op2Evaluation = evaluateDescription(op1Evaluation.remainingOps)
                    if let operand2String = op2Evaluation.resultString {
                        let result = "\(operand2String) \(operationString) \(operand1String)"
                        return (result, op2Evaluation.remainingOps)
                    }
                }
            case .ConstantOperand(let operandString, _):
                return (operandString, remainingOps)
            }
        }
        
        return ("?", ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        
        if result != nil {
            println("\(opStack) = \(result!) with \(remainder) left over")
            //could also do let (result, _) = evaluate(opStack)
        } else {
            println("result is nil")
        }
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            // make mutable copy of array to allow removeLast, as arrays are passed by value, not reference and removeLast requires mutability
            var remainingOps = ops
            let op = remainingOps.removeLast()

            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .ConstantOperand(_, let operation):
                return (operation(), remainingOps)
            }
            
            
        }
        
        return (nil, ops)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        if let operand = variableValues[symbol] {
            opStack.append(Op.Operand(operand))
        }
        
        return evaluate()
    }
}

