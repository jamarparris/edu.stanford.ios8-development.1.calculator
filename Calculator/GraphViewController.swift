//
//  GraphViewController.swift
//  Calculator
//
//  Created by Jamar Parris on 5/23/15.
//  Copyright (c) 2015 Jamar Parris. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "pinch:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "pan:"))
            
            var tapRecognizer = UITapGestureRecognizer(target: graphView, action: "doubletap:")
            tapRecognizer.numberOfTapsRequired = 2
            
            graphView.addGestureRecognizer(tapRecognizer)
        }
    }
}
