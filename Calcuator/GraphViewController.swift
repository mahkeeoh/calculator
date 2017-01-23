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

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let panRecognizer = UIPanGestureRecognizer(target: view, action: #selector(GraphView.handlePan))
        view.addGestureRecognizer(panRecognizer)
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
