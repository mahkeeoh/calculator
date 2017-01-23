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
    var translation: CGPoint?
    @IBInspectable var scaleFactor: CGFloat = 1.0
    
    override func drawRect(rect: CGRect)
    {
        let drawAxis = AxesDrawer.init(color: UIColor.blackColor(), contentScaleFactor: scaleFactor)
        if (translation == nil)
        {
            translation = CGPointMake(0.0, 0.0)
        }
        origin = CGPointMake(rect.midX + translation!.x, rect.midY + translation!.y)
        drawAxis.drawAxesInRect(rect, origin: origin!, pointsPerUnit: 5.0)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer)
    {
        translation = recognizer.translationInView(self)
        self.setNeedsDisplay()
    }

}
