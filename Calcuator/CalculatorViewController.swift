//
//  ViewController.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 10/9/16.
//  Copyright © 2016 Habituate. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate
{
    @IBOutlet weak var calcDisplay: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    fileprivate var isCurrentlyTyping = false
    
    override func awakeFromNib() {
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.content == self {
            if let svc = secondaryViewController.content as? GraphViewController {
                return true
            }
        }
        return false
    }
    
    @IBAction fileprivate func buttonClicked(_ sender: UIButton)
    {
        if isCurrentlyTyping
        {
            if !((sender.currentTitle! == ".") && (calcDisplay.text?.range(of: ".")) != nil)
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

    fileprivate var displayValue: Double?
        {
        get {
            return Double(calcDisplay.text!)
        }
        
        set {
            calcDisplay.text = String(newValue!)
            historyDisplay.text = brain.description + (!brain.description.isEmpty ? (brain.isPartialResult ? "..." : "=") :"")
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
    
    fileprivate var brain = CalculatorBrain()
    
    @IBAction fileprivate func operationClicked(_ sender: UIButton)
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !brain.isPartialResult
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail"
        {
//            var destinationVC = segue.destination
//            if let navigationVC = destinationVC as? UINavigationController {
//                destinationVC = navigationVC.visibleViewController ?? destinationVC
//            }
          //  if let vc = destinationVC as? GraphViewController
            if let vc = segue.destination.content as? GraphViewController
            {
                vc.programFunction = { (xValue: Double) -> Double in
                    
                    self.brain.variableValues["M"] = xValue
                    self.brain.program = self.brain.program
                    print(self.brain.result)
                    return Double(self.brain.result)
                    
                }
            }
        }
    }
    
    
}

extension UIViewController {
    
    var content: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.visibleViewController ?? self
        }
        else {
            return self
        }
    }
}

