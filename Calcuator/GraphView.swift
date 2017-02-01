//
//  GraphView.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 1/20/17.
//  Copyright © 2017 Habituate. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class
{
    func calculateY(x: Double) -> Double
}

@IBDesignable class GraphView: UIView
{
    
    weak var graphViewDataSource: GraphViewDataSource?
    var origin: CGPoint!
    private var translation: CGPoint!
    @IBInspectable var pointsPerUnit: CGFloat = 25.0
    private var xChange: CGFloat = 0.0
    private var yChange: CGFloat = 0.0
    private var originChanged = false
    
    override func drawRect(rect: CGRect)
    {
        let drawAxis = AxesDrawer.init(color: UIColor.blackColor(), contentScaleFactor: 1.0)

        if originChanged == false
        {
            origin = CGPointMake(bounds.midX, bounds.midY)
        }
        drawAxis.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: pointsPerUnit)
        plotFunction()
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer)
    {
        
        translation = recognizer.translationInView(self)
        translation.x = translation.x + xChange
        translation.y = translation.y + yChange
        origin.x = bounds.midX + translation.x
        origin.y = bounds.midY + translation.y
        originChanged = true
        setNeedsDisplay()
        
        if recognizer.state == .Ended
        {
            xChange =  translation.x
            yChange =  translation.y
        }
    }
    
    func handlePinch(recognizer: UIPinchGestureRecognizer)
    {
        pointsPerUnit *= recognizer.scale
        recognizer.scale = 1.0
        originChanged = true
        setNeedsDisplay()
    }
    
    func handleTap(recognizer: UITapGestureRecognizer)
    {
        origin = recognizer.locationInView(self)
        xChange = origin.x - bounds.midX
        yChange = origin.y - bounds.midY
        originChanged = true
        setNeedsDisplay()
    }
    
    func plotFunction()
    {
        // find out width of x in origin units (-25 to 25 graph would be 50)
        let path = UIBezierPath()
        path.lineWidth = 1.0
        
        for xValue in 0...Int(bounds.width)
        {
            let y = graphViewDataSource!.calculateY(Double(xValue))
            let point = CGPointMake(CGFloat(xValue), CGFloat(y))
            if xValue == 0
            {
                path.moveToPoint(point)
            }
            else
            {
                path.addLineToPoint(point)
            }
        }
        UIColor.blackColor().setStroke()
        path.stroke()
    }

}
