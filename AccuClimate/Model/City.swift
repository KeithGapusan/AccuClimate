//
//  City.swift
//  AccuClimate
//
//  Created by Keith Gapusan on 28/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import Foundation

class City:NSObject{
    var id : Int = 0
    var name : String
    var country : String?
    var coord : [String:Double]
    var weakweather : [Weather]?
    
    
    public init?(json:[String:Any]){
        self.id = json["id"] as! Int
        self.name = json["name"] as? String ?? ""
        self.country = json["country"] as?  String ?? ""
        self.coord = json["coord"] as! [String:Double]
        self.weakweather = json["weather"] as? [Weather]
         
    }
    
    func setWeather(wether: Weather){
        self.weakweather = [wether]
    }
    
}
/*{
    "id": 519188,
    "name": "Novinki",
    "country": "RU",
    "coord": {
        "lon": 37.666668,
        "lat": 55.683334
    }
},
*/
