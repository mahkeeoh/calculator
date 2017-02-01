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
    var programFunction: AnyObject?
    {
        didSet
        {
            if programFunction != nil
            {
                brain.program = programFunction!
            }
        }
    }
    private let brain = CalculatorBrain()

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
    

    func calculateY(x: Double) -> Double
    {
        brain.variableValues["M"] = x
        return brain.result
    }

}
