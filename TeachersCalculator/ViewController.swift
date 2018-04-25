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
    
    var sum: Double = 0.0
    
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
    

    @IBAction func buttonTap(_ button: UIButton) {
        if (button.tag != -1) {
            sum = sum + Double(button.tag)
            displayView.text = String(sum)
        } else {
            sum = 0.0
            displayView.text = "0"
        }
    }
    
    
}

