//
//  ViewController.swift
//  TeachersCalculator
//
//  Created by Raimi bin Karim on 24/4/18.
//  Copyright © 2018 Bytehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayView: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(displayView.isUserInteractionEnabled)
    }

    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("tada")
        }
    }
    
    @IBAction func cdcdcd(_ sender: Any) {
    }
    

}

