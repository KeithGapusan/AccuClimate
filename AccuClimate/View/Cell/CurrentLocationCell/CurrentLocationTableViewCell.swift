//
//  CurrentLocationTableViewCell.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 01/07/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit
import Alamofire

class CurrentLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelMin: UILabel!
    @IBOutlet weak var labelMax: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelDegrees: UILabel!
    @IBOutlet weak var imgViewSymbol: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func getOpenWeatherById(url:String,  handler:@escaping(_ completed :Bool, _ dataResponse:OpenWeather?, _ error:NSError?) -> Void){
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
