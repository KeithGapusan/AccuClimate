//
//  System.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class System: NSObject {

    var message : String?
    var country : String?
    var sunrise: Double?
    var sunset: Double?
    
    public init (_ json: [String:Any]){
        self.message =  json["message"] as? String ?? ""
        self.country = json["country"] as? String ?? ""
        self.sunset = json["sunrise"] as? Double ?? 0.0
        self.sunrise = json["sunset"] as? Double ?? 0.0
    }
}


/*
"sys": {
    "message": 0.003,
    "country": "GB",
    "sunrise": 1446533902,
    "sunset": 1446568141
},*/
