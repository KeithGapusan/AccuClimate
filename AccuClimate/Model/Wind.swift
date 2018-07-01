//
//  Wind.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class Wind: NSObject {

    var speed: Double?
    var deg : Double?
    
    public init(_ json:[String:Any]){
        self.speed = json["speed"] as? Double ?? 0.0
        self.deg = json["deg"] as? Double ?? 0.0
    }
}
/*
"wind": {
    "speed": 3.61,
    "deg": 165.001
},
*/
