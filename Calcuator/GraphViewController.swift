//
//  GraphViewController.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 1/19/17.
//  Copyright © 2017 Habituate. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController, GraphViewDataSource
{
    var programFunction: ((Double) -> Double)?

    fileprivate let brain = CalculatorBrain()

    @IBOutlet var graphView: GraphView!
    {
        didSet
        {
            graphView.graphViewDataSource = self
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let panRecognizer = UIPanGestureRecognizer(target: graphView, action: #selector(graphView.handlePan))
        let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: #selector(graphView.handlePinch))
        let tapRecognizer = UITapGestureRecognizer(target: graphView, action: #selector(graphView.handleTap))
        tapRecognizer.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(panRecognizer)
        view.addGestureRecognizer(pinchRecognizer)
        view.addGestureRecognizer(tapRecognizer)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func calculateY(_ x: Double) -> Double? {
        if let programFunction = programFunction {
            return programFunction(x)
        }
        return nil
    }

}
