//
//  ViewController.swift
//  TeachersCalculator
//
//  Created by Raimi bin Karim on 24/4/18.
//  Copyright © 2018 Bytehouse. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds

class ViewController: UIViewController, MFMailComposeViewControllerDelegate, GADBannerViewDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
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
    var sumView: Bool = true // true for sum, false for average
    var inputs: [Double] = []
    var obs: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Banner
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(displayViewTap))
        displayView.isUserInteractionEnabled = true
        displayView.addGestureRecognizer(tap)
        
        // Need to add swipe left manually
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeleft.direction = .left
        stackView.addGestureRecognizer(swipeleft)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showToast(controller: self, message: "Calculating cumulative sum", seconds: 1.0)
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
            if inputs.count < 100 {
                currentVal = button.tag == 0 ? 0.0 : Double(button.tag) + Double(adder)
                inputs.append(Double(currentVal))
                
                obs = obs + 1
                sum = sum + currentVal
                avg = sum/Double(obs)
                
                showDisplay()
                updateHistory()
            }
            
        // Back button
        } else if button.tag == -2 {
            if inputs.count > 0 {
                let lastInput = inputs.removeLast()
                obs = lastInput.isNaN ? obs : obs - 1
                sum = lastInput.isNaN ? sum : sum - lastInput
                avg = sum/Double(obs)
                
                showDisplay()
                removeLastLine()
            }
        
        // Copy history
        } else if button.tag == -3 {
            exportAsIs(historyView.text)
            
        // Save file
        } else if button.tag == -4 {
            let csvText = historyView.text.replacingOccurrences(of: ")\t", with: ",")
            exportAsCsv("No.,Marks\n" + csvText)
            
        // NA button
        } else if button.tag == -5 {
            if inputs.count < 100 {
                currentVal = Double.nan
                inputs.append(Double(currentVal))
                
                showDisplay()
                updateHistory()
            }
            
        // Clear button
        } else if button.tag == -1 {
            sum = 0.0
            avg = 0.0
            currentVal = 0.0
            obs = 0
            historyView.text.removeAll()
            displayView.text = "0"
            adder = 0
            setButtonTitles()
            inputs.removeAll()
            scrollTextViewToBottom(historyView)
            showToast(controller: self, message: "Cumulative sum", seconds: 0.5)
        }
    }

    @IBAction func trueLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let buttonTag = sender.view?.tag {
                setButtonTitlesPlusHalf()
                if inputs.count < 100 {
                    currentVal = buttonTag == 0 ? 0.5 : Double(buttonTag) + Double(adder) + 0.5
                    inputs.append(Double(currentVal))
                    
                    obs = obs + 1
                    sum = sum + currentVal
                    avg = sum/Double(obs)
                    
                    showDisplay()
                    updateHistory()
                }
                
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
    
    func updateHistory() {
        let currentLine = String(inputs.count) + ")\t" + numberToDisplay(inputs.last!)
        if historyView.text != "" {
            historyView.text = historyView.text + "\n"
        }
        historyView.text = historyView.text + currentLine
        scrollTextViewToBottom(historyView)
    }
    
    func removeLastLine() {
        historyView.text.removeLast()
        var lastChar = historyView.text.removeLast()
        while lastChar != "\n" && historyView.text.count > 0 {
            lastChar = historyView.text.removeLast()
        }
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
        let message = sumView ? "Cumulative sum" : "Cumulative average"
        showToast(controller: self, message: message, seconds: 0.5)
    }
    
    // Display type average or sum
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
    
    func exportAsIs(_ text: String) {
        if text.count > 0 {
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll
            ]
            present(vc, animated: true, completion: nil)
            
        } else {
            showToast(controller: self, message: "No data to copy", seconds: 0.5)
        }
    }
    
    func exportAsCsv(_ csvText: String) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        let fileName = dateString + ".csv"
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        if csvText.count > 0 {
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivityType.assignToContact,
                    UIActivityType.saveToCameraRoll
                ]
                present(vc, animated: true, completion: nil)
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
            
        } else {
            showToast(controller: self, message: "No data to share", seconds: 0.5)
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
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

func showToast(controller: UIViewController, message: String, seconds: Double) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.view.backgroundColor = UIColor.lightGray
    alert.view.alpha = 0.9
    alert.view.layer.cornerRadius = 15
    
    controller.present(alert, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
        alert.dismiss(animated: true)
    }
}

