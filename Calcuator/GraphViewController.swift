//
//  GraphViewController.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 1/19/17.
//  Copyright © 2017 Habituate. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController
{

    @IBOutlet weak var graphView: GraphView!
    // insert function here in "didSet" to draw program in graph
    {
        didSet
        {
            // here we want to take the "program" from calculatorBrain and convert it into a working function
            // for graphView to use.... possibly take the part of calcBrain that already converts to workable function?
            // ex. sqrt(m) vs. sqrtsymbol(m)
            // then graph view is as simple as iterating over all x values in view and corresponding y values
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
