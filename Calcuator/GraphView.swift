//
//  GraphView.swift
//  Calcuator
//
//  Created by Mikael Olezeski on 1/20/17.
//  Copyright © 2017 Habituate. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView
{
    var origin: CGPoint?
    private var translation: CGPoint = CGPointMake(0.0, 0.0)
    @IBInspectable var pointsPerUnit: CGFloat = 5.0
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
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer)
    {
        
        translation = recognizer.translationInView(self)
        translation.x = translation.x + xChange
        translation.y = translation.y + yChange
        origin!.x = bounds.midX + translation.x
        origin!.y = bounds.midY + translation.y
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
        // need to edit xchange/ychange to account for new origin
        originChanged = true
        setNeedsDisplay()
    }

}
