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
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    var variableValues = [String:Double]()
    {
        didSet
        {
            // if variable changes, rerun whole program
            program = internalProgram
        }
    }
    
    func setOperand (operand: Double)
    {
        if pending == nil {clear()}
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func setOperand (variable: String)
    {
        if pending == nil {clear()}
        accumulator = variableValues[variable] ?? 0
        internalProgram.append(variable)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "∏" : Operation.Constant("∏", M_PI),
        "e" : Operation.Constant("e", M_E),
        "AC": Operation.Restart,
        "√" : Operation.UnaryOperation("√", sqrt),
        "×" : Operation.BinaryOperation("×", {$0 * $1}),
        "+" : Operation.BinaryOperation("+", {$0 + $1}),
        "−" : Operation.BinaryOperation("−", {$0 - $1}),
        "÷" : Operation.BinaryOperation("÷", {$0 / $1}),
        "cos" : Operation.UnaryOperation("cos", cos),
        "sin" : Operation.UnaryOperation("sin", sin),
        "tan" : Operation.UnaryOperation("tan", tan),
        "×2" : Operation.UnaryOperation("×2", {$0 * $0}),
        "±" : Operation.UnaryOperation("±", {-$0}),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(String, Double)
        case Restart
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Equals
    }
    
    func performCalculation (symbol: String)
    {
        internalProgram.append(symbol)
        if let operations = operations[symbol]
        {
            switch operations
            {
            case .Restart:
                clear()
            case .Constant(_, let associatedValue):
                if pending == nil {clear()}
                accumulator = associatedValue
            case .UnaryOperation(_, let unaryFunction):
                accumulator = unaryFunction(accumulator)
            case .BinaryOperation(_, let function):
                isPartialResult = true
                executePendingBinary()
                pending = pendingBinaryInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinary()
                isPartialResult = false

            }
        }
        
    }

    private func executePendingBinary()
    {
        if (pending != nil)
        {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }

    private var pending: pendingBinaryInfo?
    
    private struct pendingBinaryInfo
    {
        var binaryFunction: ((Double,Double) -> Double)
        var firstOperand: Double
        
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList
    {
        get
        {
            return internalProgram
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
                    case .Constant(let symbol, _):
                        last = symbol
                    case .UnaryOperation(let symbol, _):
                        desc = (last != nil ? desc : "") + symbol + "(" + (last ?? desc) + ")"
                        last = nil
                    case .BinaryOperation(let symbol, _):
                        desc += (last ?? "") + symbol
                    case .Equals:
                        desc += last ?? ""
                        last = nil
                    case .Restart:
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
