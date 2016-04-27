//
//  WebService.swift
//  SwiftProject
//
//  Created by iosdev on 26.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import Foundation
import Alamofire
//import PromiseKit

class WebService: NSObject {
    let baseUrl = "https://boiling-springs-67739.herokuapp.com/api/v1/spots"
    
    static let sharedInstance = WebService()
    
    private override init(){}
    
    func getAllSpots() {
        Alamofire.request(.GET, baseUrl)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
}






