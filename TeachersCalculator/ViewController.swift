//
//  ViewController.swift
//  TeachersCalculator
//
//  Created by Raimi bin Karim on 24/4/18.
//  Copyright © 2018 Bytehouse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lastButton: UITextView!
    @IBOutlet weak var displayView: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var sum: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
//        self.button.addGestureRecognizer(longPress)
//
        //print(displayView.isUserInteractionEnabled)
    }
    
    @IBAction func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("Swipe registered.")
        }
    }
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("True swipe registered.")
        }
    }
    
    @IBAction func buttonTap(_ button: UIButton) {
        if (button.tag != -1) {
            lastButton.text = String(button.tag)
            sum = sum + Double(button.tag)
            displayView.text = String(sum)
        } else {
            sum = 0.0
            lastButton.text = "0"
            displayView.text = "0"
        }
    }

    @IBAction func trueLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            print("True long press registered.")
        }
    }
    
}

