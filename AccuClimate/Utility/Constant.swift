//
//  Constant.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class Constant: NSObject {

}
struct appId{
    static let open_weather = "&appid=79327f55b814be950ae45929bf64ab85"
}
struct apiUrl{
    //base urls
    static let dev = "https://api.openweathermap.org/"
    static let staging = ""
    static let uat = ""
    static let prod = ""
    static let base_url = dev
    static let base_open_weather = dev
    static let weather_id = "data/2.5/weather?id="
    static let geotag = "data/2.5/weather?"
    static let coordinates = "lat=%f&lon=%f"
    static let img = "img/w/"
}

struct bundlePath {
    static let cityMin = "cityMin"
    static let cityAll = "city"
    /*
     cityMin = 20
     cityAll = 200,000++
     */
    static let city = cityMin
}
struct xibName {
    
    /* custom tableview cell */
    static let city = "MajorCityTableViewCell"
    static let city_current = "CurrentLocationTableViewCell"
    static let header_major_city = "HeaderViewCell"
    /* custom view */
    static let customLoader = "CustomLoader"
    
}
struct stringSpecialChar {
    static let degreeSymbol = "\u{00B0}"
}

struct cellIdentifier {
    // tableview
    static let city = "MajorCityTableViewCell"
    static let city_current = "CurrentLocationTableViewCell"
    static let header_major_city = "HeaderViewCell"
}

struct segueIdentifier {
    static let to_weather_details = "toDetail"
}

struct storyboardId {

}



