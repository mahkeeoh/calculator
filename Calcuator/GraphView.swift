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
    func calculateY(_ x: Double) -> Double?
}

@IBDesignable class GraphView: UIView
{
    
    weak var graphViewDataSource: GraphViewDataSource?
    var origin: CGPoint! {didSet {setNeedsDisplay()}}
    fileprivate var translation: CGPoint!
    @IBInspectable var pointsPerUnit: CGFloat = 25.0 {didSet {setNeedsDisplay()}}

    
    override func draw(_ rect: CGRect)
    {
        let axisDraw = AxesDrawer.init(color: UIColor.black, contentScaleFactor: contentScaleFactor)

        origin = origin ?? CGPoint(x: bounds.midX, y: bounds.midY)

        axisDraw.drawAxes(bounds, origin: origin!, pointsPerUnit: pointsPerUnit)
        
        plotFunction()
    }
    
    func handlePan(_ recognizer: UIPanGestureRecognizer)
    {
        switch recognizer.state {
        case .changed, .ended:
            let translation = recognizer.translation(in: self)
            origin.x += translation.x
            origin.y += translation.y
            recognizer.setTranslation(CGPoint(), in: self)
        default: break
        }
        
    }
    
    func handlePinch(_ recognizer: UIPinchGestureRecognizer)
    {
        switch recognizer.state {
        case .changed, .ended:
            pointsPerUnit *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    func handleTap(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == .ended {
            origin = recognizer.location(in: self)
        }
    }
    
    func plotFunction()
    {
        if graphViewDataSource != nil
        {
            // find out width of x in origin units (-25 to 25 graph would be 50)
            let path = UIBezierPath()
            path.lineWidth = 1.0
            let width = Int(bounds.width * contentScaleFactor)
            var point = CGPoint()
            var emptyPath = true
            for xValue in 0...width {
                point.x = CGFloat(xValue) / contentScaleFactor
                if let y = graphViewDataSource!.calculateY(Double((point.x - origin.x) / pointsPerUnit)) {
                    if !y.isNormal && !y.isZero {
                        emptyPath = true
                        continue
                    }
                    
                    point.y = origin.y - CGFloat(y) * pointsPerUnit
                    
                    if emptyPath {
                        path.move(to: point)
                        emptyPath = false
                    }
                    else {
                        path.addLine(to: point)
                    }
                }
            }
            UIColor.black.setStroke()
            path.stroke()
        }
    }

}
