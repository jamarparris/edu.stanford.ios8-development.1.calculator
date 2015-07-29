//
//  GraphViewController.swift
//  Calculator
//
//  Created by Jamar Parris on 5/23/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    private var brain = CalculatorBrain()
    
    //use program variable to configure brain
    var program: PropertyList? = nil {
        didSet {
            println("setting program: \(program)")
            brain.program = program!
            
            //update title to display last entered expression in brain
            self.title = brain.description.componentsSeparatedByString(", ").last
        }
    }

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            //setup dataSource delegate
            graphView.dataSource = self
            
            //add gestures
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "pinch:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "pan:"))
            
            var tapRecognizer = UITapGestureRecognizer(target: graphView, action: "doubletap:")
            tapRecognizer.numberOfTapsRequired = 2
            
            graphView.addGestureRecognizer(tapRecognizer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //graphViewDataSource method
    func yValueForXValue(x: Double) -> Double? {
        brain.variableValues["M"] = x
        println(brain.variableValues)
        return brain.evaluate()
    }
}
