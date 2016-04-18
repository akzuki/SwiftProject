//
//  MapViewController.swift
//  SwiftProject
//
//  Created by iosdev on 18.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, EILIndoorLocationManagerDelegate {
    
    @IBOutlet weak var locationView: EILIndoorLocationView!
    let locationManager = EILIndoorLocationManager()
    
    var location: EILLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // You can get them by adding your app on https://cloud.estimote.com/#/apps
        ESTConfig.setupAppID("chuongtruong290893-gmail-c-af3", andAppToken: "ce9c0eea8821ff51e583c03310f7ac89")
        
        self.locationManager.delegate = self
        
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "chuongtruong290893-s-location-fjt")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                self.location = location
                self.locationView.backgroundColor = UIColor.grayColor()
                // You can configure the location view to your liking:
                self.locationView.showTrace = false
                self.locationView.rotateOnPositionUpdate = false
                // Consult the full list of properties on:
                // http://estimote.github.io/iOS-Indoor-SDK/Classes/EILIndoorLocationView.html
                self.locationView.locationBorderColor = UIColor.purpleColor()
                self.locationView.locationBorderThickness = 4
                self.locationView.drawLocation(location)
                
                let imageGreenDot = UIImage(named: "greenDot")
                let greenDot = UIImageView.init(frame: CGRectMake(0, 0, 20, 20))
                greenDot.image = imageGreenDot
                
//                greenDot.image = UIImage(named: "greenDot")
//                let point = location.beacons[1].position
                let point = EILOrientedPoint(x: 0.20, y: 1.5, orientation: 0)
                self.locationView.drawObjectInForeground(greenDot, withPosition: point, identifier:"printer")
                
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didUpdatePosition position: EILOrientedPoint!, withAccuracy positionAccuracy: EILPositionAccuracy, inLocation location: EILLocation!) {
        //        var accuracy: String!
        //        switch positionAccuracy {
        //        case .VeryHigh: accuracy = "+/- 1.00m"
        //        case .High:     accuracy = "+/- 1.62m"
        //        case .Medium:   accuracy = "+/- 2.62m"
        //        case .Low:      accuracy = "+/- 4.24m"
        //        case .VeryLow:  accuracy = "+/- ? :-("
        //        }
        //        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@", position.x, position.y, position.orientation, accuracy))
        
        self.locationView.updatePosition(position)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

