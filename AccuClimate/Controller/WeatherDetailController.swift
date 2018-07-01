//
//  WeatherDetailController.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 01/07/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit
import Alamofire
import Nuke

class WeatherDetailController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cityId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tableView.register(UINib(nibName:xibName.city_current, bundle: nil), forCellReuseIdentifier: cellIdentifier.city_current)
        self.tableView.reloadData()
    }

    @IBAction func didPressedBarItem(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
}
extension WeatherDetailController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    fileprivate func setupCurrentCity(_ tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.city_current) as? CurrentLocationTableViewCell{
            let url = apiUrl.base_open_weather + apiUrl.weather_id + "\(cityId)" + appId.open_weather
            var pressure = "--"
            var humidity = "--"
            var minTemp  = "--"
            var maxTemp  = "--"
            var speed    = "--"
            var degrees  = "--"
            var currentLocation = "Loading..."
            var desc = "Loading..."
            var currentDate = "--/--/----"
            var temperature = "--"
            var icon = ""
            
            cell.getOpenWeatherById(url: url, handler: { (completed, openWeather, error) in
                if error != nil{
                    
                    cell.labelPressure.text = pressure
                    cell.labelHumidity.text = humidity
                    cell.labelMin.text = minTemp
                    cell.labelMax.text = maxTemp
                    cell.labelSpeed.text = speed
                    cell.labelDegrees.text = degrees
                    cell.labelLocation.text = currentLocation
                    cell.labelDescription.text = desc
                    cell.labelDate.text = currentDate
                    cell.labelTemperature.text = temperature
                    
                }else{
                    if let message = (openWeather?.message){
                        self.showAlert(title: "Error", message: message)
                    } else{
                        
                        if let mainDetails =  openWeather?.mainDetails!{
                            let temp = mainDetails.temp
                            let min = mainDetails.temp_min
                            let max = mainDetails.temp_max
                            let celciusMin = mainDetails.convertToCelcius(kelvin: min!)
                            let celciusMax = mainDetails.convertToCelcius(kelvin: max!)
                            let celcius = mainDetails.convertToCelcius(kelvin: temp!)
                            
                            temperature =  "\(String(describing: celcius))\(stringSpecialChar.degreeSymbol)"
                            minTemp =  "\(String(describing: celciusMin))\(stringSpecialChar.degreeSymbol)"
                            maxTemp =  "\(String(describing: celciusMax))\(stringSpecialChar.degreeSymbol)"
                            pressure =  String(format: "%.2f", mainDetails.pressure!)
                            humidity =  String(format: "%.2f", mainDetails.humidity!)
                            
                        }
                        
                        if let wind = openWeather?.wind{
                            speed = String(format:"%.1f", wind.speed!)
                            degrees = String(format:"%.1f", wind.deg!)
                        }
                        
                        if let weathers = openWeather?.weather{
                            for data in weathers{
                                desc = "\(String(describing: data.desc!)) "
                                icon = "\(String(describing: data.icon!))"
                            }
                        }
                        if let location = openWeather?.name{
                            currentLocation = location
                        }else{
                            currentLocation = "Unable to get the current location"
                        }
                        if let date = openWeather?.date{
                            
                            currentDate = DateFormatter().convertUnixTimeToDate(date)
                        }
                        cell.labelTemperature.text = temperature
                        cell.labelDescription.text = desc
                        cell.labelDescription.textColor = .white
                        cell.labelPressure.text = pressure
                        cell.labelHumidity.text = humidity
                        cell.labelMin.text = minTemp
                        cell.labelMax.text = maxTemp
                        cell.labelSpeed.text = speed
                        cell.labelDegrees.text = degrees
                        cell.labelLocation.text = currentLocation
                        cell.labelDate.text = currentDate
                        
                        
                        let imgUrlStr = apiUrl.base_open_weather + apiUrl.img + icon + ".png"
                        if let imgUrl = URL(string: imgUrlStr){
                            let options = ImageLoadingOptions(
                                placeholder: UIImage(named: "placeholder"),
                                failureImage: UIImage(named: "failure_image"),
                                contentModes: .init(
                                    success: .scaleAspectFill,
                                    failure: .center,
                                    placeholder: .center
                                )
                            )
                            Nuke.loadImage(with: imgUrl, options: options, into: cell.imgViewSymbol)
                        }
                    }
                        
                }
                    
                 
            })
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            return setupCurrentCity(tableView)
            
        default:
            return UITableViewCell()
        }
    }
}
