//
//  GetData.swift
//  Weather for Dummies
//
//  Created by Matvey on 7/12/19.
//  Copyright © 2019 Matvey. All rights reserved.
//

import UIKit
import GooglePlaces

extension PlacesViewController {
    
    func savePlace(_ place: GMSPlace) {
        print(place.coordinate)
        places.append(place)
    }
    
    //        let urlString = "https://api.apixu.com/v1/current.json?key=API_KEY&q=\(textInput.replacingOccurrences(of: " ", with: "%20"))"
    
    //    https://api.darksky.net/forecast/API_KEY/37.8267,-122.4233
    
    func getWeatherForPlace(_ place: GMSPlace) {

        
        let apixuURLString = "https://api.apixu.com/v1/current.json?key=\(apixuAPIKey)&q=\(place.name!.replacingOccurrences(of: " ", with: "%20"))"
        
        guard let apixuURL = URL.init(string: apixuURLString) else { print("unable to parse apixu URL")
            return
        }

        
        let apixuAPITask = URLSession.shared.dataTask(with: apixuURL) { (data, response, error) in
            
            guard let dataReceived = data else {
                print("didn't receive deta")
                return
            }
            
            do {
                let apixuJSON = try JSONSerialization.jsonObject(with: dataReceived, options: .mutableContainers) as! [String: AnyObject]
                
                
                if let location = apixuJSON["location"] {
                    self.locationName = location["name"] as? String
                } else { print("unable to parse location") }
                
                if let apixuCurrent = apixuJSON["current"] {
                    self.temperature = apixuCurrent["temp_c"] as? Double
                    self.precipitation = apixuCurrent["precip_mm"] as? Double
                    self.humidity = apixuCurrent["humidity"] as? Int
                    
                    self.getConditionImageFromJSON(apixuCurrent)
                    
                    evaluateWeather(currentTemperature: self.temperature, currentPrecipitation: self.precipitation, currentHumidity: self.humidity)
                    
                    DispatchQueue.main.async {
                        print(self.temperature!)
                        self.updateUI()
                    }
                    
                } else { print("unable to parse temperature") }
                
            } // end do
                
            catch let jsonError {
                print(jsonError)
            }
            
        }
        
        apixuAPITask.resume()
        
        
        
        // DARK SKY
        
        let darkskyURLString = "https://api.darksky.net/forecast/\(darkSkyAPIKey)/\(place.coordinate.latitude),\(place.coordinate.longitude)"
        
        print(darkskyURLString)
        
        guard let darkskyURL = URL.init(string: darkskyURLString) else { print("unable to parse darksky URL")
            return
        }
        
        print(darkskyURL)
        
        
        let darkskyAPITask = URLSession.shared.dataTask(with: darkskyURL) { (data, response, error) in
            guard let dataReceived = data else {
                print("didn't receive deta")
                return
            }
            
            do {
//                                try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let darkskyJSON = try JSONSerialization.jsonObject(with: dataReceived, options: []) as! [String: AnyObject]
                
                guard let darkskyCurrent = darkskyJSON["currently"] else { return }
                guard let dewPoint = darkskyCurrent["dewPoint"] else { return }
                
                print(dewPoint)
                
            }
            
            catch let jsonError {
                print(jsonError)
            }
            
//            catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
        }
        
        darkskyAPITask.resume()
        
    } // end task definition
    
    func getConditionImageFromJSON(_ current: AnyObject) {
        //        print(current["condition"])
        
        guard let currentCondition = current["condition"] as! [String: Any]?
            else { print("cannot get current condition")
                return
        }
        
        print(currentCondition)
        
        guard let currentConditionIconURLText: String = "https:" + (currentCondition["icon"] as! String)
            else { print("cannot get current condition URL text")
                return
        }
        
        //        guard let currentConditionIconURLRequest: URLRequest = URLRequest(url: URL(string: currentConditionIconURLText)!)
        //            else { print("cannot get create URL request")
        //                return
        //        }
        guard let currentConditionIconURL = URL(string: currentConditionIconURLText)
            else { print("cannot get URL")
                return
        }
        
        self.weatherImageView.load(url: currentConditionIconURL)
        
    }
}
