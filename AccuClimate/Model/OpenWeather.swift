//
//  OpenWeather.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class OpenWeather: NSObject {

    var weather = [Weather]()
    var id : Int?
    var mainDetails : MainDetails?
    var base : String?
    var wind : Wind?
    var rain : Rain?
    var clouds : Clouds?
    var date : Double?
    var system : System?
    var name: String?
    var message : String?
    
    public init(_ json: [String:Any]){
        if let message =  json["message"] as? String{
            self.message = message
        }else{
            if let weatherAray = json["weather"] as? [Any]{
                for element in weatherAray{
                    self.weather.append(Weather.init(element as! [String : Any]))
                }
            }
            self.id = json["id"] as?  Int ?? 0
            if let main =  json["main"] as? [String:Any]{
                self.mainDetails = MainDetails.init(main)
            }
            self.base = json["wind"] as? String ?? ""
            
            if let wind = json["wind"] as? [String:Any]{
                self.wind = Wind.init(wind)
            }
            
            if let rain = json["rain"] as? [String:Any]{
                self.rain = Rain.init(rain)
            }
            
            if let cloud = json["clouds"] as? [String:Any]{
                self.clouds = Clouds.init(cloud)
            }
            
            self.date  = json["dt"] as? Double ?? 0.0
            if let system = json["system"] as? [String:Any]{
                self.system = System.init(system)
            }
            
            self.name = json["name"] as? String ?? ""
            
            }
        }
      
}
/*
{
    "coord": {
        "lon": -0.13,
        "lat": 51.51
    },
    "weather": [
    {
    "id": 500,
    "main": "Rain",
    "description": "light rain",
    "icon": "10n"
    }
    ],
    "base": "cmc stations",
    "main": {
        "temp": 286.164,
        "pressure": 1017.58,
        "humidity": 96,
        "temp_min": 286.164,
        "temp_max": 286.164,
        "sea_level": 1027.69,
        "grnd_level": 1017.58
    },
    "wind": {
        "speed": 3.61,
        "deg": 165.001
    },
    "rain": {
        "3h": 0.185
    },
    "clouds": {
        "all": 80
    },
    "dt": 1446583128,
    "sys": {
        "message": 0.003,
        "country": "GB",
        "sunrise": 1446533902,
        "sunset": 1446568141
    },
    "id": 2643743,
    "name": "London",
    "cod": 200
}
*/
