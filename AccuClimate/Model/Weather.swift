//
//  Weather.swift
//  AccuClimate
//
//  Created by Keith Gapusan on 29/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class Weather: NSObject {

    var id: Int
    var main: String?
    var desc: String?
    var icon:String?
    
    public init(_ json: [String:Any]){
        self.id = json["id"] as! Int
        self.main  = json["main"] as? String ?? ""
        self.desc  = json["description"] as? String ?? ""
        self.icon   = json["icon"] as? String  ?? ""
    }
    
}
/*
 "weather": [
    {
    "id": 803,
    "main": "Clouds",
    "description": "broken clouds",
    "icon": "04d"
    }
]
*/
