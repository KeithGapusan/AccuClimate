//
//  Extensions.swift
//  AccuClimate
//
//  Created by Keith Randell Gapusan on 01/07/2018.
//  Copyright © 2018 Keith Gapusan. All rights reserved.
//

import UIKit

class Extensions: NSObject {

}
extension DateFormatter{
    func convertUnixTimeToDate(_ unixtimeInterval:Double) -> String{
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MMMM dd EEEE yyyy"
        return dateFormatter.string(from: date)
    }
    
    func convertUnixTimeToDate(_ unixtimeInterval:Double, dateFormat : String) -> String{
        let date = Date(timeIntervalSince1970: unixtimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    

}

extension Date{
    func currentDateWithFormat() -> String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MMMM dd yyyy"
        return formatter.string(from: now)
    }
}

extension UIViewController{
    func showAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style:.cancel, handler:nil))
        
        self.present(alert, animated: true)
        
    }
}
