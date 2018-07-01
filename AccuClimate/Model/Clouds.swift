//
//  Clouds.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class Clouds: NSObject {

    var cloud : Int?
    
    public init(_ json:[String:Any]){
        self.cloud = json["all"] as? Int ?? 0
    }
}

/*
"clouds": {
    "all": 80
},

*/
