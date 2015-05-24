//
//  GraphView.swift
//  Calculator
//
//  Created by Jamar Parris on 5/23/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    
}

@IBDesignable
class GraphView: UIView {
    
    weak var dataSource: GraphViewDataSource?
    private var axesDrawer = AxesDrawer()
    
    @IBInspectable
    var scale: CGFloat = 50 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var origin: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        origin = origin ?? convertPoint(center, fromView: superview)
        
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            scale *= gesture.scale
            
            //reset to 1 to make it incremental
            gesture.scale = 1
        default:break
        }
    }
    
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough //just use the one right below
        case .Changed:
            let translation = gesture.translationInView(self)
            let x = origin!.x + translation.x
            let y = origin!.y + translation.y
            
            origin = CGPoint(x: x, y: y)
            
            //reset to zero so that it's incremental
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }

    func doubletap(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            //change origin to the place user double tapped
            origin = gesture.locationInView(self)
        default: break
        }
    }
}
