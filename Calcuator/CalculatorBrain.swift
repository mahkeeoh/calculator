//
//  Calculation.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 10/17/16.
//  Copyright © 2016 Habituate. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    fileprivate var accumulator = 0.0
    fileprivate var internalProgram = [AnyObject]()
    var variableValues = [String:Double]()
    {
        didSet
        {
            // if variable changes, rerun whole program
            program = internalProgram as CalculatorBrain.PropertyList
        }
    }
    
    func setOperand (_ operand: Double)
    {
        if pending == nil {clear()}
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func setOperand (_ variable: String)
    {
        if pending == nil {clear()}
        accumulator = variableValues[variable] ?? 0
        internalProgram.append(variable as AnyObject)
    }
    
    fileprivate var operations: Dictionary<String,Operation> = [
        "∏" : Operation.constant("∏", .pi),
        "e" : Operation.constant("e", M_E),
        "AC": Operation.restart,
        "√" : Operation.unaryOperation("√", sqrt),
        "×" : Operation.binaryOperation("×", {$0 * $1}),
        "+" : Operation.binaryOperation("+", {$0 + $1}),
        "−" : Operation.binaryOperation("−", {$0 - $1}),
        "÷" : Operation.binaryOperation("÷", {$0 / $1}),
        "cos" : Operation.unaryOperation("cos", cos),
        "sin" : Operation.unaryOperation("sin", sin),
        "tan" : Operation.unaryOperation("tan", tan),
        "×2" : Operation.unaryOperation("×2", {$0 * $0}),
        "±" : Operation.unaryOperation("±", {-$0}),
        "=" : Operation.equals
    ]
    
    fileprivate enum Operation {
        case constant(String, Double)
        case restart
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        case equals
    }
    
    func performCalculation (_ symbol: String)
    {
        internalProgram.append(symbol as AnyObject)
        if let operations = operations[symbol]
        {
            switch operations
            {
            case .restart:
                clear()
            case .constant(_, let associatedValue):
                if pending == nil {clear()}
                accumulator = associatedValue
            case .unaryOperation(_, let unaryFunction):
                accumulator = unaryFunction(accumulator)
            case .binaryOperation(_, let function):
                isPartialResult = true
                executePendingBinary()
                pending = pendingBinaryInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                executePendingBinary()
                isPartialResult = false

            }
        }
        
    }

    fileprivate func executePendingBinary()
    {
        if (pending != nil)
        {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    fileprivate var pending: pendingBinaryInfo?
    
    fileprivate struct pendingBinaryInfo
    {
        var binaryFunction: ((Double,Double) -> Double)
        var firstOperand: Double
        
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList
    {
        get
        {
            return internalProgram as CalculatorBrain.PropertyList
        }
        
        set
        {
            if let arrayOfOps = newValue as? [AnyObject]
            {
                clear()
                for op in arrayOfOps
                {
                    if let operand = op as? Double
                    {
                        setOperand(operand)
                    }
                    else if let operation = op as? String
                    {
                        if operations[operation] != nil
                        {
                            performCalculation(operation)
                        }
                        else
                        {
                            setOperand(operation)
                        }
                    }
                }
            }
        }
    }
    
    var result: Double
    {
        get
        {
            return accumulator
        }
    }
    
    func clear()
    {
        accumulator = 0.0
        pending = nil
        isPartialResult = false
        internalProgram.removeAll()
    }
    
    var description: String
    {
        var desc = ""
        var last: String?
        for item in internalProgram
        {
            if let operand = item as? Double
            {
                last = String(operand)
            }
            else if let symbol = item as? String
            {
                if let operation = operations[symbol]
                {
                    switch operation
                    {
                    case .constant(let symbol, _):
                        last = symbol
                    case .unaryOperation(let symbol, _):
                        desc = (last != nil ? desc : "") + symbol + "(" + (last ?? desc) + ")"
                        last = nil
                    case .binaryOperation(let symbol, _):
                        desc += (last ?? "") + symbol
                    case .equals:
                        desc += last ?? ""
                        last = nil
                    case .restart:
                        clear()
                    }
                }
                else
                {
                    last = symbol
                }
            }
            else
            {
                print("unable to process")
            }
        }
        return desc == "" ? last ?? "" : desc
    }
 
    
    var isPartialResult = false
}
