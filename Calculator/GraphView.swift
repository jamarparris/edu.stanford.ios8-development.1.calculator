//
//  GraphView.swift
//  Calculator
//
//  Created by Jamar Parris on 5/23/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func yValueForXValue(x: Double) -> Double?
}

@IBDesignable
class GraphView: UIView {
    
    var graphColor: UIColor = UIColor.blackColor()
    var axesColor: UIColor = UIColor.blueColor()
    
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
        axesDrawer.color = axesColor
        
        axesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
        
        //draw graph
        drawGraphInRect(bounds, origin: origin!, pointsPerUnit: scale)
    }
    
    private func drawGraphInRect(rect: CGRect, origin: CGPoint, pointsPerUnit: CGFloat) {
        if ((origin.x >= bounds.minX) && (origin.x <= bounds.maxX)) || ((origin.y >= bounds.minY) && (origin.y <= bounds.maxY))
        {
            CGContextSaveGState(UIGraphicsGetCurrentContext())
            graphColor.set()
            
            let path = UIBezierPath()
            
            //find out what the points per hashmark are
            //find out what the starting x value is
            //find out what each pixel represents in terms of incremental x value
        
            let minimumPointsPerHashmark = axesDrawer.minimumPointsPerHashmark
            var unitsPerHashmark = minimumPointsPerHashmark / pointsPerUnit
            if unitsPerHashmark < 1 {
                unitsPerHashmark = pow(10, ceil(log10(unitsPerHashmark)))
            } else {
                unitsPerHashmark = floor(unitsPerHashmark)
            }
            
            let pointsPerHashmark = pointsPerUnit * unitsPerHashmark
            
            //this is the value of X to the far left of the axis
            var x = -((origin.x - bounds.minX) / pointsPerHashmark)
            let incrementalX = 1/pointsPerHashmark
            
            //println("unitsPerHashmark: \(unitsPerHashmark), incrementalX: \(incrementalX)")
            
            var shouldMoveToPoint = true
            for (var xPos = bounds.minX; xPos < bounds.maxX; xPos++) {
            
                if let y = self.dataSource?.yValueForXValue(Double(x)) {
                    
                    //get value we need to apply to origin to calculate position
                    let yPosDiff = (CGFloat(y) * pointsPerHashmark)
                    
                    //if positive result, subtract to reduce yPos go up on graph
                    //if negative, -(-) = + to increase yPos to go down on graph
                    let yPos = origin.y - yPosDiff
                    //println("x: \(x), xPos: \(xPos), originX: \(origin.x), maxX: \(bounds.maxX), y: \(y), yPos: \(yPos), yPosDiff: \(yPosDiff)")
                    
                    let point = CGPoint(x: xPos, y: yPos)
                    
                    if shouldMoveToPoint {
                        //previous move was not valid y
                        path.moveToPoint(point)
                    } else {
                        //previous move was valid so add line from it
                        path.addLineToPoint(point)
                    }
                    
                    shouldMoveToPoint = false
                    
                } else {
                    //if no y value, force next iteration to moveToPoint
                    shouldMoveToPoint = true
                }
                
                //update x value for next pixel
                x += incrementalX
            }
            
            path.stroke()
            CGContextRestoreGState(UIGraphicsGetCurrentContext())
        }
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
