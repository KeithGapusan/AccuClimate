//
//  ViewController.swift
//  AccuClimate
//
//  Created by Keith Gapusan on 28/06/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit
import Alamofire
import Nuke
import CoreLocation

class WeatherController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var cityPager =  [[City]]()
    var cityList = [City]()
    var city : City!
    var pagerCounter = 0
    var numOfCity = 0
    var locationManager:CLLocationManager!
    var longitude = 0.0
    var latitude = 0.0
    var flagLoaded = 0
    var viewLoader: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        viewLoader = CustomLoader.instanceFromNib()
        self.view.addSubview(viewLoader.view)
        numOfCity = self.initCities()
        let citySet1 = cityPager[pagerCounter]
        cityList = citySet1
        determineMyCurrentLocation()
    }
    override func viewDidAppear(_ animated: Bool) {

        tableViewSetup()
        viewLoader.view.removeFromSuperview()
    }
    @IBAction func didPressedBarButton(_ sender: UIBarButtonItem) {
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at:
        self.tableView.indexPathsForVisibleRows!, with: .none)
        self.tableView.endUpdates()
    }
    fileprivate func tableViewSetup() {
        self.tableView.register(UINib(nibName:xibName.city, bundle: nil), forCellReuseIdentifier:cellIdentifier.city)
        self.tableView.register(UINib(nibName:xibName.city_current, bundle: nil), forCellReuseIdentifier: cellIdentifier.city_current)
        self.tableView.register(UINib(nibName:xibName.header_major_city, bundle: nil), forCellReuseIdentifier: cellIdentifier.header_major_city)
     
        self.tableView.estimatedRowHeight = 194.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(60))
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(20))
        self.tableView.tableFooterView = spinner
        self.tableView.reloadData()
    }
    func initCities()->Int{
        /**
            This method is used to generate a internal pagination of cities based on the json file.
            The bundle resource path below:
            'cityMin' contains 23 cities
            'city' contains 200,000+ cities
         **/
        
        var numberOfElements = 0
        if let path = Bundle.main.path(forResource: bundlePath.city, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
               
                var initCity = [City]()
                if let j = jsonResult as? [Any]{
                   numberOfElements = j.count
                   var counter = 0
                    for data in j{
                        if let dict = data as? [String:Any]{
                            if let city = City.init(json: dict){
                                if counter != 9{
                                    initCity.append(city)
                                    counter = counter + 1
                                }else{
                                    initCity.append(city)
                                    cityPager.append(initCity)
                                    initCity.removeAll()
                                    counter = 0
                                }
                            }
                        }else{
                            print("Something went wrong")
                        }
                    }
                    cityPager.append(initCity)
                   return numberOfElements
                }
            } catch {
                // handle error
                return numberOfElements
            }
        }else{
            return numberOfElements
        }
            return numberOfElements
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.to_weather_details{
            if let vc = segue.destination as? WeatherDetailController{
                vc.cityId = sender as! Int
            }
        }
    }
}


extension WeatherController:CLLocationManagerDelegate{
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        longitude = userLocation.coordinate.longitude
        latitude = userLocation.coordinate.latitude
        if flagLoaded == 0{
            self.flagLoaded = 1
            self.tableView.reloadData()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}


extension WeatherController : UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return cityList.count
        }
    }
    fileprivate func setupMajorCity(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.city) as? MajorCityTableViewCell{
            let cityData = cityList[indexPath.row]
            cell.labelCity.text = cityData.name
            let url = apiUrl.base_open_weather + apiUrl.weather_id + "\(cityData.id)" + appId.open_weather
            cell.labelDescription.text = "......"
            cell.labelDescription.textColor = UIColor.clear
            cell.getOpenWeather(url: url, handler: { (completion, openWeather, error) in
                var desc = ""
                var icon = ""
                if error  != nil{
                    cell.labelDescription.text = "Something went wrong, try again later. (\(error!.code))."
                    cell.labelDescription.textColor = .black
                    cell.labelTemp.text = "--.-" + stringSpecialChar.degreeSymbol
                    
                }else{
                    if let message = (openWeather?.message){
                       // self.showAlert(title: "Error", message: message)
                    } else{
                    let temp =  (openWeather?.mainDetails?.temp)! // kelvin
                    let celcius =  openWeather?.mainDetails?.convertToCelcius(kelvin: temp)
                    if let weathers = openWeather?.weather{
                        for data in weathers{
                            desc = "\(desc)\(String(describing: data.desc!)) "
                            icon = "\(String(describing: data.icon!))"
                        }
                    }
                    cell.labelTemp.text = "\(String(describing: celcius!))\(stringSpecialChar.degreeSymbol)"
                    cell.labelDescription.text = desc
                    cell.labelDescription.textColor = .black
                    
                    let imgUrlStr = apiUrl.base_open_weather + apiUrl.img + icon + ".png"
                    let imgUrl = URL(string: imgUrlStr)
                    let options = ImageLoadingOptions(
                        placeholder: UIImage(named: "placeholder"),
                        failureImage: UIImage(named: "failure_image"),
                        contentModes: .init(
                            success: .scaleAspectFill,
                            failure: .center,
                            placeholder: .center
                        )
                    )
                    Nuke.loadImage(with: imgUrl!, options: options, into: cell.imgViewSymbol)
                }
              
                }
            })
            return cell
        }else{
            return UITableViewCell()
            
        }
    }
    
    fileprivate func setupCurrentCity(_ tableView: UITableView) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.city_current) as? CurrentLocationTableViewCell{
            //et url = apiUrl.base_open_weather + apiUrl.weather_id + "\(cityData)&appid=5d0c85cb38d6ede3024a1e10a3b23912"
            
            let coordinate = String(format: apiUrl.coordinates, latitude, longitude) + appId.open_weather
            let url = apiUrl.base_open_weather + apiUrl.geotag + coordinate
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
                        if let mainDetails =  openWeather?.mainDetails{
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
                                placeholder: UIImage(named: "placeholder"), // temporary
                                failureImage: UIImage(named: "failure_image"), // temporary
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
            
        case 1:
            return setupMajorCity(tableView, indexPath)
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
            if indexPath.row == cityList.count - 1{
                let counter = self.cityList.count / 10 //to determine the index number of cityPage
                if (cityList.count < numOfCity){
                    if ((cityPager.count < counter) != true){
                        self.cityList.append(contentsOf: cityPager[counter])
                        self.tableView.reloadData()
                      
                        tableView.tableFooterView?.isHidden = false
                    }
                }else{
                    tableView.tableFooterView?.isHidden = true
                }
            }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            print(cityList[indexPath.row].id)
            performSegue(withIdentifier: segueIdentifier.to_weather_details, sender: cityList[indexPath.row].id)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            
            let  headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 60.0))
            print(tableView.bounds.width)
            if let headerCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.header_major_city) as? HeaderViewCell{
                headerCell.frame = headerView.frame
                headerCell.labelDate.text = Date().currentDateWithFormat()
                headerView.addSubview(headerCell)
            }
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }else{
            return UITableViewAutomaticDimension
        }
    }
}
