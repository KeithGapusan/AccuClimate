//
//  MainDetails.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class MainDetails: NSObject {
    var temp: Double?
    var pressure : Double?
    var humidity : Int?
    var temp_min : Double?
    var temp_max : Double?
    var sea_level : Double?
    var grnd_level : Double?

    public init(_ json:[String:Any]){
        self.temp = json["temp"] as? Double ?? 0.0
        self.pressure = json["pressure"] as? Double ?? 0.0
        self.humidity = json["humidity"] as? Int ?? 0
        self.temp_min  = json["temp_min"] as? Double ?? 0.0
        self.temp_max  = json["temp_max"] as? Double ?? 0.0
        self.sea_level = json["sea_level"] as? Double ?? 0.0
        self.grnd_level  = json["grnd_level"] as? Double ?? 0.0
    }
    
    func convertToCelcius(kelvin: Double) -> String{
        return String(format: "%.0f", kelvin - 273.15)
    }
}

/*"main": {
    "temp": 286.164,
    "pressure": 1017.58,
    "humidity": 96,
    "temp_min": 286.164,
    "temp_max": 286.164,
    "sea_level": 1027.69,
    "grnd_level": 1017.58
}*/
