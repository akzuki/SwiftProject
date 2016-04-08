//
//  ViewController.swift
//  SwiftProject
//
//  Created by iosdev on 8.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var emptySpotLabel: UILabel!
    @IBOutlet weak var icon1: UIButton!
    @IBOutlet weak var icon2: UIButton!
    @IBOutlet weak var icon3: UIButton!
    @IBOutlet weak var icon4: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeGradientBackground()
        emptySpotLabel.layer.borderColor = UIColor.whiteColor().CGColor
        emptySpotLabel.layer.borderWidth = 3
        makeRoundedBorder(icon1)
        makeRoundedBorder(icon2)
        makeRoundedBorder(icon3)
        makeRoundedBorder(icon4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeGradientBackground() {
        let colorTop = UIColor(red: 0.0/255.0, green: 168.0/255.0, blue: 134.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 35.0/255.0, green: 109.0/255.0, blue: 84.0/255.0, alpha: 1.0).CGColor
        let gradientBackground = CAGradientLayer()
        gradientBackground.frame = self.view.bounds
        gradientBackground.colors = [colorTop, colorBottom]
        gradientBackground.locations = [0.0, 80.0]
        self.view.layer.insertSublayer(gradientBackground, atIndex: 0)
        print("Gradient Background: Done")
    }
    
    func makeRoundedBorder(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.cornerRadius = 10
    }
    
    

}

