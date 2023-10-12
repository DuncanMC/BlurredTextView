//
//  ViewController.swift
//  BlurredTextView
//
//  Created by Duncan Champney on 10/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var blurringView: BlurringView!
    
    @IBOutlet weak var blurSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        blurringView.layer.borderWidth = 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("In \(#function)")
        // This doesn't work either
        // blurringView.updateBlurImage()
    }

    @IBAction func handleBlurSwitch(_ sender: UISwitch) {
        print("In \(#function)")
        blurringView.blur = sender.isOn
    }
    
}

