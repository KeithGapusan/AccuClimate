//
//  Rain.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class Rain: NSObject {

    var rain : Double?
    
    public init(_ json:[String:Any]){
        self.rain = json["3h"] as? Double ?? 0.0
    }
}
/*
"rain": {
    "3h": 0.185
},
*/
