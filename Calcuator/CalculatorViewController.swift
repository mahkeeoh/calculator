//
//  ViewController.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 10/9/16.
//  Copyright © 2016 Habituate. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController
{
    @IBOutlet weak var calcDisplay: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    private var isCurrentlyTyping = false
    
    @IBAction private func buttonClicked(sender: UIButton)
    {
        if isCurrentlyTyping
        {
            if !((sender.currentTitle! == ".") && (calcDisplay.text?.rangeOfString(".")) != nil)
            {
                let  currentDigits = calcDisplay.text
                calcDisplay.text = currentDigits! + sender.currentTitle!
            }
        }
        else
        {
            if sender.currentTitle! == "."
            {
                calcDisplay.text = "0."
            }
            else
            {
                calcDisplay.text =  sender.currentTitle!
            }
        }
        isCurrentlyTyping = true
    }

    private var displayValue: Double?
        {
        get {
            return Double(calcDisplay.text!)
        }
        
        set {
            calcDisplay.text = String(newValue!)
            historyDisplay.text = brain.description + (!brain.description.isEmpty ? (brain.isPartialResult ? "..." : "=") :"")
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save()
    {
        savedProgram = brain.program
    }
    
    @IBAction func restore()
    {
        if savedProgram != nil
        {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func setVariable()
    {
        isCurrentlyTyping = false
        brain.variableValues["M"] = displayValue
        displayValue = brain.result
    }
    
    @IBAction func insertVariable()
    {
        brain.setOperand("M")
        displayValue = brain.result
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func operationClicked(sender: UIButton)
    {
        if isCurrentlyTyping
        {
            brain.setOperand(displayValue!)
            isCurrentlyTyping = false
        }
        
        if let performOperation = sender.currentTitle
        {
            brain.performCalculation(performOperation)
        }
        displayValue = brain.result
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool
    {
        if (brain.isPartialResult != true)
        {
            return true
        }
        
        else
        {
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail"
        {
            let navController = segue.destinationViewController as? UINavigationController
            if let vc = navController?.topViewController as? GraphViewController
            {
                vc.programFunction = brain.program
            }
        }
    }
    
    
}

