//
//  MajorCityTableViewCell.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 30/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit
import Alamofire

class MajorCityTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var imgViewSymbol: UIImageView!
    


    func getOpenWeather(url:String,  handler:@escaping(_ completed :Bool, _ dataResponse:OpenWeather?, _ error:NSError?) -> Void){
        Alamofire.request(url, method:.get).responseJSON { response in
            var openWeather : OpenWeather?
            
            if response.error != nil{
                handler(true, openWeather,response.error! as NSError)
            }else{
                if ((response.result.value)  != nil) {
                    let data =  response.result.value as! [String:Any]
                    openWeather = OpenWeather.init(data)
                    
  
                    handler(true, openWeather,nil)
                }else{
                    handler(true, openWeather,nil)
                }
            }
        }
    }
}
