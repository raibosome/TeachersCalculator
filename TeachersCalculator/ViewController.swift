//
//  ViewController.swift
//  TeachersCalculator
//
//  Created by Raimi bin Karim on 24/4/18.
//  Copyright © 2018 Bytehouse. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var historyView: UITextView!
    @IBOutlet weak var displayView: UILabel!
    @IBOutlet weak var button0: MyButton!
    @IBOutlet weak var button1: MyButton!
    @IBOutlet weak var button2: MyButton!
    @IBOutlet weak var button3: MyButton!
    @IBOutlet weak var button4: MyButton!
    @IBOutlet weak var button5: MyButton!
    @IBOutlet weak var button6: MyButton!
    @IBOutlet weak var button7: MyButton!
    @IBOutlet weak var button8: MyButton!
    @IBOutlet weak var button9: MyButton!
    @IBOutlet weak var button10: MyButton!
    
    var sum: Double = 0.0
    var avg: Double = 0.0
    var currentVal: Double = 0
    var adder: Int = 0
    var noOfTaps: Int = 0
    var record: String = ""
    var sumView: Bool = true // true for sum, false for average
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(displayViewTap))
        displayView.isUserInteractionEnabled = true
        displayView.addGestureRecognizer(tap)
        
        // Need to add swipe left manually
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeleft.direction = .left
        stackView.addGestureRecognizer(swipeleft)
    }
    
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.right {
            if adder <= 80 {
                adder = adder + 10
            }
        } else {
            if adder >= 10 {
                adder = adder - 10
            }
        }
        if sender.state == .ended {
            setButtonTitles()
        }
    }
    
    @IBAction func buttonTap(_ button: MyButton) {
        if 0 ... 10 ~= button.tag {
            currentVal = Double(button.tag) + Double(adder)
            historyView.text = numberToDisplay(currentVal)
            sum = sum + currentVal
            avg = (avg * Double(noOfTaps) + currentVal)/Double(noOfTaps + 1)
            showDisplay()
            noOfTaps = noOfTaps + 1
            history()

        } else if button.tag == -3 {
            writeFile()
            
        } else {
            sum = 0.0
            historyView.text = "0"
            displayView.text = "0"
            adder = 0
            setButtonTitles()
            record = ""
            noOfTaps = 0
        }
    }

    @IBAction func trueLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let buttonTag = sender.view?.tag {
                setButtonTitlesPlusHalf()
                currentVal = Double(buttonTag) + Double(adder) + 0.5
                historyView.text = numberToDisplay(currentVal)
                sum = sum + currentVal
                avg = (avg * Double(noOfTaps) + currentVal)/Double(noOfTaps + 1)
                showDisplay()
                noOfTaps = noOfTaps + 1
                history()
            } else {
                print("Unable to unwrap view")
            }
            
        } else if sender.state == .ended {
            setButtonTitles()
        }
    }
    
    func numberToDisplay(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) > 0 {
            return String(format: "%.1f", value)
        } else {
            return String(format: "%.0f", value)
        }
    }
    
    func setButtonTitles() {
        button1.setTitle(String(1 + adder), for: UIControlState.normal)
        button2.setTitle(String(2 + adder), for: UIControlState.normal)
        button3.setTitle(String(3 + adder), for: UIControlState.normal)
        button4.setTitle(String(4 + adder), for: UIControlState.normal)
        button5.setTitle(String(5 + adder), for: UIControlState.normal)
        button6.setTitle(String(6 + adder), for: UIControlState.normal)
        button7.setTitle(String(7 + adder), for: UIControlState.normal)
        button8.setTitle(String(8 + adder), for: UIControlState.normal)
        button9.setTitle(String(9 + adder), for: UIControlState.normal)
        button10.setTitle(String(10 + adder), for: UIControlState.normal)
        button0.setTitle(String(0), for: UIControlState.normal)
    }
    
    func setButtonTitlesPlusHalf() {
        button1.setTitle(String(Double(adder) + 1.5), for: UIControlState.normal)
        button2.setTitle(String(Double(adder) + 2.5), for: UIControlState.normal)
        button3.setTitle(String(Double(adder) + 3.5), for: UIControlState.normal)
        button4.setTitle(String(Double(adder) + 4.5), for: UIControlState.normal)
        button5.setTitle(String(Double(adder) + 5.5), for: UIControlState.normal)
        button6.setTitle(String(Double(adder) + 6.5), for: UIControlState.normal)
        button7.setTitle(String(Double(adder) + 7.5), for: UIControlState.normal)
        button8.setTitle(String(Double(adder) + 8.5), for: UIControlState.normal)
        button9.setTitle(String(Double(adder) + 9.5), for: UIControlState.normal)
        button10.setTitle(String(Double(adder) + 10.5), for: UIControlState.normal)
        button0.setTitle(String(0.5), for: UIControlState.normal)
    }
    
    func history() {
        let currentLine = String(noOfTaps) + "\t" + numberToDisplay(currentVal)
        record = record + currentLine + "\n"
        historyView.text = record
        
        scrollTextViewToBottom(historyView)
    }
    
    func scrollTextViewToBottom(_ textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(1, location)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
    @objc
    func displayViewTap(sender:UITapGestureRecognizer) {
        sumView = !sumView
        showDisplay()
    }
    
    func showDisplay() {
        displayView.text = sumView ? numberToDisplay(sum) : numberToDisplay(avg)
    }
    
    @objc
    func swipeLeft(sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            if adder <= 80 {
                adder = adder + 10
            }
        } else {
            if adder >= 10 {
                adder = adder - 10
            }
        }
        if sender.state == .ended {
            setButtonTitles()
        }
    }
    
    func writeFile() {
        print("Trying to write file but to no avail.")
    }
    
}

@IBDesignable class MyButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    
}
