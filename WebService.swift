//
//  WebService.swift
//  SwiftProject
//
//  Created by iosdev on 26.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebService: NSObject {
    let baseUrl = "https://boiling-springs-67739.herokuapp.com/api/v1/spots/"
    
    static let sharedInstance = WebService()
    
    func getSpots(number: Int, completionHandler:(result: [Spot])->Void ) {
        var result = [Spot]()
        Alamofire.request(.GET, baseUrl)
            .responseJSON { response in
                if (response.result.error == nil) {
                    for spot in response.result.value as! [AnyObject] {
                        let newSpot = Spot()
                        if let id = spot["id"] as? NSNumber{
                            newSpot.id = id
                        }
                        result.append(newSpot)
                    }
                    completionHandler(result: result)
                }
        }
    }
    
//    func countEmptySpots() {
//        Alamofire.request(.GET, baseUrl + "empty")
//            .responseJSON { response in
//                if (response.result.error == nil) {
//                    let json = JSON(response.result.value)
//                    if let count = json[0]["count"].string {
//                        print(count)
//                    }
//                }
//        }
//
//    }
}