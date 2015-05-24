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
        
        let axesOrigin = origin ?? convertPoint(center, fromView: superview)
        
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxesInRect(bounds, origin: axesOrigin, pointsPerUnit: scale)
    }

}
