//
//  MapViewController.swift
//  SwiftProject
//
//  Created by iosdev on 18.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, EILIndoorLocationManagerDelegate {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var locationView: EILIndoorLocationView!
    let locationManager = EILIndoorLocationManager()
    
    var location: EILLocation!
    var avatar: EILPositionView!
    var currentPosition : EILOrientedPoint!
    var navigationLayer: CAShapeLayer!
    
    @IBAction func parkButton(sender: UIButton) {
        locationView.removeObjectWithIdentifier("car1")
        let imageGreenDot = UIImage(named: "icon2")
        let greenDot = UIImageView.init(frame: CGRectMake(0, 0, 40, 40))
                        greenDot.backgroundColor = UIColor.grayColor()
        greenDot.image = imageGreenDot
        let point1 = EILOrientedPoint(x: 1.5, y: 1.5, orientation: 0)
        self.locationView.drawObjectInBackground(greenDot, withPosition: point1, identifier:"car1Parked")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let locationBuilder = EILLocationBuilder()
//        locationBuilder.setLocationName("Classroom B305-ver2")
//        locationBuilder.setLocationBoundaryPoints([
//            EILPoint(x: 0.00, y: 0.00),
//            EILPoint(x: 0.00, y: 9),
//            EILPoint(x: 9, y: 9),
//            EILPoint(x: 9, y: 0.00)])
//        
//        locationBuilder.addBeaconIdentifiedByMac("f0d9c4f70527",
//            atBoundarySegmentIndex: 0, inDistance: 5, fromSide: .LeftSide)
//        locationBuilder.addBeaconIdentifiedByMac("ce59e89bd34e",
//            atBoundarySegmentIndex: 1, inDistance: 2, fromSide: .RightSide)
//        locationBuilder.addBeaconIdentifiedByMac("e2208d08b720",
//            atBoundarySegmentIndex: 2, inDistance: 5, fromSide: .LeftSide)
//        locationBuilder.addBeaconIdentifiedByMac("de0f1c1fe1e8",
//            atBoundarySegmentIndex: 3, inDistance: 5, fromSide: .RightSide)
//        
//        locationBuilder.setLocationOrientation(230)
//        locationBuilder.addDoorsWithLength(2, atBoundarySegmentIndex: 0, inDistance: 1, fromSide: .RightSide)
//        locationBuilder.addWindowWithLength(3, atBoundarySegmentIndex: 3, inDistance: 2, fromSide: .LeftSide)
//        
//        location = locationBuilder.build()
//        // You can get them by adding your app on https://cloud.estimote.com/#/apps
        ESTConfig.setupAppID("chuongtruong290893-gmail-c-af3", andAppToken: "ce9c0eea8821ff51e583c03310f7ac89")
//        let addLocationRequest = EILRequestAddLocation(location: location)
//        addLocationRequest.sendRequestWithCompletion { (location, error) in
//            if error != nil {
//                NSLog("Error when saving location: \(error)")
//            } else {
//                NSLog("Location saved successfully: \(location!.identifier)")
//            }
//        }
        
        self.locationManager.delegate = self
        
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "classroom-b305-ver2-ajz")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                self.location = location
//                self.locationView.backgroundColor = UIColor.grayColor()
                // You can configure the location view to your liking:
                self.locationView.showTrace = false
                self.locationView.rotateOnPositionUpdate = true
                // Consult the full list of properties on:
                // http://estimote.github.io/iOS-Indoor-SDK/Classes/EILIndoorLocationView.html
                self.locationView.locationBorderColor = UIColor.purpleColor()
                self.locationView.locationBorderThickness = 4
                self.locationView.windowColor = UIColor.yellowColor()
                self.locationView.drawLocation(location)
                
                
                let imageGreenDot = UIImage(named: "greenDot")
                let greenDot = UIImageView.init(frame: CGRectMake(0, 0, 40, 40))
//                greenDot.backgroundColor = UIColor.grayColor()
                greenDot.image = imageGreenDot
                
                let imageGreenDot2 = UIImage(named: "greenDot")
                let greenDot2 = UIImageView.init(frame: CGRectMake(0, 0, 40, 40))
//                greenDot2.backgroundColor = UIColor.grayColor()
                greenDot2.image = imageGreenDot2
                
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
                greenDot.userInteractionEnabled = true
                greenDot.addGestureRecognizer(tapGestureRecognizer)
                
//                greenDot.image = UIImage(named: "greenDot")
//                let point = location.beacons[1].position
                let point1 = EILOrientedPoint(x: 1.5, y: 1.5, orientation: 0)
                let point2 = EILOrientedPoint(x: 4, y: 1.5)
                self.locationView.drawObjectInBackground(greenDot, withPosition: point1, identifier:"car1")
                self.locationView.drawObjectInBackground(greenDot2, withPosition: point2, identifier:"car2")

//                self.avatar = EILPositionView.init(image: imageGreenDot!, location: location, showAccuracyCircle: true, forViewWithBounds: self.locationView.bounds)
                
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }
    
    func imageTapped(img: AnyObject) {
        status.text = "Empty spot"
        updateNavigation()
        print("subview added")
    }
    
    func updateNavigation() {
        var path = UIBezierPath()
        let newPoint = locationView.calculatePicturePointFromRealPoint(currentPosition)
        path.moveToPoint(newPoint)
        let newPoint2 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 1.5, y: 1.5, orientation: 0))
        path.addLineToPoint(CGPoint(x: newPoint2.x, y: newPoint.y))
        path.addLineToPoint(newPoint2)
        if navigationLayer != nil {
            navigationLayer.removeFromSuperlayer()
        }
//        navigationLayer.removeFromSuperlayer()
        navigationLayer = CAShapeLayer()
        navigationLayer.path = path.CGPath
        navigationLayer.strokeColor = UIColor.blackColor().CGColor
        navigationLayer.fillColor = UIColor.clearColor().CGColor
        navigationLayer.lineDashPattern = [3,4]
        locationView.layer.insertSublayer(navigationLayer, atIndex: 0)
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didUpdatePosition position: EILOrientedPoint!, withAccuracy positionAccuracy: EILPositionAccuracy, inLocation location: EILLocation!) {
                var accuracy: String!
                switch positionAccuracy {
                case .VeryHigh: accuracy = "+/- 1.00m"
                case .High:     accuracy = "+/- 1.62m"
                case .Medium:   accuracy = "+/- 2.62m"
                case .Low:      accuracy = "+/- 4.24m"
                case .VeryLow:  accuracy = "+/- ? :-("
                default: accuracy = "dont know"
                }
                print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@", position.x, position.y, position.orientation, accuracy))
        currentPosition = position
        self.locationView.updatePosition(position)
        updateNavigation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

