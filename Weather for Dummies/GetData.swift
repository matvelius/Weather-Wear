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
//        print(place.coordinate)
        places.append(place)
    }
    
    //        let urlString = "https://api.apixu.com/v1/current.json?key=API_KEY&q=\(textInput.replacingOccurrences(of: " ", with: "%20"))"
    
    //    https://api.darksky.net/forecast/API_KEY/37.8267,-122.4233
    
    func getWeatherForPlace() {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        let apixuURLString = "https://api.apixu.com/v1/current.json?key=\(apixuAPIKey)&q=\(locationName!.replacingOccurrences(of: " ", with: "%20"))"
        
        print("apixuURLString: \(apixuURLString)")
        
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
 
                } else { print("unable to parse current weather from apiXU") }
                
                DispatchQueue.main.async {
                    dispatchGroup.leave()
                }
                
            } // end do
                
                
                
            catch let jsonError {
                print("jsonError: \(jsonError)")
            }
            
        }
        
        apixuAPITask.resume()
        
        
        dispatchGroup.enter()
        
        // DARK SKY
        
        let darkskyURLString = "https://api.darksky.net/forecast/\(darkSkyAPIKey)/\(currentLocationLatitude!),\(currentLocationLongitude!)?units=si"
        
        print("darkskyURLString: \(darkskyURLString)")
        
        guard let darkskyURL = URL.init(string: darkskyURLString) else { print("unable to parse darksky URL")
            return
        }
        
        print("darkskyURL: \(darkskyURL)")
        
        
        let darkskyAPITask = URLSession.shared.dataTask(with: darkskyURL) { (data, response, error) in
            
            guard let dataReceived = data else {
                print("didn't receive deta")
                return
            }
            
            do {
//                                try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let darkskyJSON = try JSONSerialization.jsonObject(with: dataReceived, options: []) as! [String: AnyObject]
                
                if let darkskyCurrent = darkskyJSON["daily"] {
                    //                guard let dewPoint = darkskyCurrent["dewPoint"] else { return }
                    guard let darkskyCurrentData = darkskyCurrent["data"] as? [[String: AnyObject]] else {
                        print("unable to fetch darkskyCurrentData")
                        return
                    }
                    
                    if let location = darkskyCurrentData[0]["location"] {
                        self.locationName = location["name"] as? String
                    } else { print("unable to parse location") }
                    
//                    if let apixuCurrent = apixuJSON["current"] {
//                    self.temperature = darkskyCurrentData[0]["temp_c"] as? Double
//                    self.precipitation = darkskyCurrentData[0]["precip_mm"] as? Double
//                    self.humidity = darkskyCurrentData[0]["humidity"] as? Int
                    
//                    self.getConditionImageFromJSON(apixuCurrent)
                    
//                    } else { print("unable to parse current weather from apiXU") }
                    
                    self.precipProbability = darkskyCurrentData[0]["precipProbability"] as? Double
                    self.dewPoint = darkskyCurrentData[0]["dewPoint"] as? Double
                    self.precipType = darkskyCurrentData[0]["precipType"] as? String
                    self.visibility = darkskyCurrentData[0]["visibility"] as? Double
                    self.darkskyIconName = darkskyCurrentData[0]["icon"] as? String
                    
                    evaluateWeather(
                        currentTemperature: self.temperature,
                        currentPrecipitation: self.precipitation,
                        currentHumidity: self.humidity,
                        currentPrecipProbability: self.precipProbability,
                        currentDewPoint: self.dewPoint,
                        currentPrecipType: self.precipType,
                        currentVisibility: self.visibility,
                        darkskyIconName: self.darkskyIconName
                    )
                    
                    DispatchQueue.main.async {
                        dispatchGroup.leave()
                    }
                    
                } else { print("unable to parse current weather from darkSky") }

          
            }
            
            catch let jsonError {
                print("jsonError: \(jsonError)")
            }
            
//            catch let error as NSError {
//                print("Failed to load: \(error.localizedDescription)")
//            }
        }
        
        darkskyAPITask.resume()
        
        dispatchGroup.notify(queue: .main) {
            self.updateUI()
            self.removeActivityIndicator()
        }
        
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
