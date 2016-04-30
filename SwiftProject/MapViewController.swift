//
//  MapViewController.swift
//  SwiftProject
//
//  Created by iosdev on 18.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import UIKit
import CoreData

class MapViewController: UIViewController, EILIndoorLocationManagerDelegate {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var locationView: EILIndoorLocationView!
    let locationManager = EILIndoorLocationManager()
    
    var location: EILLocation!
    var avatar: EILPositionView!
    var currentPosition : EILOrientedPoint!
    var navigationLayer: CAShapeLayer!
    var corePoints: [EILOrientedPoint] = []
    var spotList: [Spot]!
    var selectedSpot: Spot?
    
    
    
    @IBAction func parkButton(sender: UIButton) {
//        let path = UIBezierPath()
//        let point1 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 0, y: 4.5))
//        let point2 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 9, y: 4.5))
//        path.moveToPoint(point1)
//        path.addLineToPoint(point2)
//        
//        let point3 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 4.5, y: 0))
//        let point4 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 4.5, y: 9))
//        path.moveToPoint(point3)
//        path.addLineToPoint(point4)
//        
//        let point5 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 0, y: 2))
//        let point6 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 9, y: 2))
//        path.moveToPoint(point5)
//        path.addLineToPoint(point6)
//        
//        let point7 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 0, y: 7))
//        let point8 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 9, y: 7))
//        path.moveToPoint(point7)
//        path.addLineToPoint(point8)
//        
//        let point9 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 2, y: 0))
//        let point10 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 2, y: 9))
//        path.moveToPoint(point9)
//        path.addLineToPoint(point10)
//        
//        let point11 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 7, y: 0))
//        let point12 = locationView.calculatePicturePointFromRealPoint(EILOrientedPoint(x: 7, y: 9))
//        path.moveToPoint(point11)
//        path.addLineToPoint(point12)
//        
//        print("meow")
//        let navigationLayer1 = CAShapeLayer()
//        navigationLayer1.path = path.CGPath
//        navigationLayer1.strokeColor = UIColor.blackColor().CGColor
//        navigationLayer1.fillColor = UIColor.clearColor().CGColor
//        navigationLayer1.lineDashPattern = [3,4]
//        locationView.layer.insertSublayer(navigationLayer1, atIndex: 0)
        if let selectedSpot = self.selectedSpot {
            selectedSpot.changeStatus()
            WebService.sharedInstance.changeStatus(selectedSpot, completionHandler: {(result) -> Void in
                    let appDelegate =
                        UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    let managedContext = appDelegate.managedObjectContext
                    
                    //2
                    let entity =  NSEntityDescription.entityForName("Spot",
                        inManagedObjectContext:managedContext)
                    
                    let savedSpot = NSManagedObject(entity: entity!,
                        insertIntoManagedObjectContext: managedContext)
                    
                    //3
                    savedSpot.setValue(selectedSpot.getId(), forKey: "id")
                savedSpot.setValue(selectedSpot.getX(), forKey: "x")
                savedSpot.setValue(selectedSpot.getY(), forKey: "y")
                savedSpot.setValue(selectedSpot.getStatus(), forKey: "status")
                    
                    //4
                    do {
                        try managedContext.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                
            })
        }
    }
    
    func test(sender: UITapGestureRecognizer) {
        let currentPoint = locationView.calculateRealPointFromPicturePoint(sender.locationInView(locationView))
        self.currentPosition = EILOrientedPoint(x: currentPoint.x, y: currentPoint.y)
        updateNavigation()
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Spot")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            let savedSpot = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        corePoints.append(EILOrientedPoint(x: 2, y: 2))
        corePoints.append(EILOrientedPoint(x: 4.5, y: 2))
        corePoints.append(EILOrientedPoint(x: 7, y: 2))
        corePoints.append(EILOrientedPoint(x: 2, y: 4.5))
        corePoints.append(EILOrientedPoint(x: 4.5, y: 4.5))
        corePoints.append(EILOrientedPoint(x: 7, y: 4.5))
        corePoints.append(EILOrientedPoint(x: 2, y: 7))
        corePoints.append(EILOrientedPoint(x: 4.5, y: 7))
        corePoints.append(EILOrientedPoint(x: 7, y: 7))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("test:"))
        locationView.userInteractionEnabled = true
        locationView.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(loading)
        loading.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        self.locationManager.delegate = self
        ESTConfig.setupAppID("chuongtruong290893-gmail-c-af3", andAppToken: "ce9c0eea8821ff51e583c03310f7ac89")
        
        // You will find the identifier on https://cloud.estimote.com/#/locations
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "classroom-b305-ver2-ajz")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                self.location = location
                
                self.locationView.showTrace = false
                self.locationView.rotateOnPositionUpdate = true
                self.locationView.locationBorderColor = UIColor.purpleColor()
                self.locationView.locationBorderThickness = 4
                self.locationView.windowColor = UIColor.yellowColor()
                self.locationView.drawLocation(location)
                
                self.locationManager.startPositionUpdatesForLocation(self.location)
                WebService.sharedInstance.getSpots({ (result) -> Void in
                    self.spotList = result
                    for spot in self.spotList {
                        self.drawSpot(spot)
                    }
                    self.loading.removeFromSuperview()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                })
            } else {
                print("can't fetch location: \(error)")
            }
        }
        
        
    }
    
    
    func spotTapped(sender: UITapGestureRecognizer) {
        let spot = sender.view as! Spot
        print("Spot tapped \(spot.getInfo())")
        print(closestPoint(spot.getCoordinate()))
//        if (!spot.getStatus()) {
            self.selectedSpot = spot
//        }
    }
    
    func updateNavigation() {
        let path = UIBezierPath()
        let spotPoint = selectedSpot!.getCoordinate()
        let currentLocationPoint = locationView.calculatePicturePointFromRealPoint(currentPosition)
        let point1 = locationView.calculatePicturePointFromRealPoint(closestPoint(currentPosition))
        let point2 = locationView.calculatePicturePointFromRealPoint(closestPoint(spotPoint))
        path.moveToPoint(currentLocationPoint)
        let destinationPoint = locationView.calculatePicturePointFromRealPoint(spotPoint)
        path.addLineToPoint(CGPoint(x: point1.x, y: currentLocationPoint.y))
        path.addLineToPoint(point1)
        path.addLineToPoint(CGPoint(x: point2.x, y: point1.y))
        path.addLineToPoint(point2)
        path.addLineToPoint(CGPoint(x: destinationPoint.x, y: point2.y))
        path.addLineToPoint(destinationPoint)
        
//        path.moveToPoint(currentLocationPoint)
//        path.addLineToPoint(CGPoint(x: currentLocationPoint.x, y: point1.y))
//        path.addLineToPoint(point1)
//        path.addLineToPoint(CGPoint(x: point1.x, y: point2.y))
//        path.addLineToPoint(point2)
//        path.addLineToPoint(CGPoint(x: point2.x, y: destinationPoint.y))
//        path.addLineToPoint(destinationPoint)
        
        if navigationLayer != nil {
            navigationLayer.removeFromSuperlayer()
        }
//        navigationLayer.removeFromSuperlayer()
        navigationLayer = CAShapeLayer()
        navigationLayer.path = path.CGPath
        navigationLayer.strokeColor = UIColor.redColor().CGColor
        navigationLayer.fillColor = UIColor.clearColor().CGColor
//        navigationLayer.lineWidth = 3
        navigationLayer.lineDashPattern = [3,6]
        navigationLayer.lineCap = kCALineCapRound
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
    
    func drawSpot(spot: Spot) {
        let identifier = "spot" + String(spot.getId())
        let point = spot.getCoordinate()
        self.locationView.drawObjectInBackground(spot, withPosition: point, identifier: identifier)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("spotTapped:"))
        spot.userInteractionEnabled = true
        spot.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func closestPoint(point: EILOrientedPoint) -> EILOrientedPoint {
        var resultPoint = corePoints[0]
        for corePoint in corePoints {
            if (point.distanceToPoint(corePoint) < point.distanceToPoint(resultPoint)) {
                resultPoint = corePoint
            }
        }
        return resultPoint
    }
}



//        Method for building the map
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
//        ESTConfig.setupAppID("chuongtruong290893-gmail-c-af3", andAppToken: "ce9c0eea8821ff51e583c03310f7ac89")
//        let addLocationRequest = EILRequestAddLocation(location: location)
//        addLocationRequest.sendRequestWithCompletion { (location, error) in
//            if error != nil {
//                NSLog("Error when saving location: \(error)")
//            } else {
//                NSLog("Location saved successfully: \(location!.identifier)")
//            }
//        }
