//
//  AppEntity.swift
//  SwiftProject
//
//  Created by iosdev on 26.4.2016.
//  Copyright © 2016 iosdev. All rights reserved.
//

import Foundation

class Spot {
    var id: NSNumber = 0
    var x: String = ""
    var y: String = ""
    var status : Bool?
    
    
    func changeStatus() {
        if let _status = status {
            status = !_status
        }
    }
}
