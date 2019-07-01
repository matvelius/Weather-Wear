//
//  ViewController.swift
//  Weather for Dummies
//
//  Created by Matvey on 6/30/19.
//  Copyright © 2019 Matvey. All rights reserved.
//

// CURRENT WEATHER
// https://api.apixu.com/v1/current.json?key=f19bd582e9a142e4baa155854193006&q=Paris

// FORECAST
// https://api.apixu.com/v1/forecast.json?key=f19bd582e9a142e4baa155854193006&q=Paris



import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let textInput = searchBar.text else {
            print("not text")
            return
        }
        
        
        let urlString = "https://api.apixu.com/v1/current.json?key=f19bd582e9a142e4baa155854193006&q=\(textInput.replacingOccurrences(of: " ", with: "%20"))"
        
        
        var locationName: String?
        var temperature: Double?
        
        print(urlString)
        
        
        guard let url = URL.init(string: urlString) else {
            print("unable to parse URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let dataReceived = data else {
                print("didn't receive deta")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: dataReceived, options: .mutableContainers) as! [String: AnyObject]
                
                if let location = json["location"] {
                    locationName = location["name"] as? String
                } else {
                    print("unable to parse location")
                }
                
                if let current = json["current"] {
                    temperature = current["temp_c"] as? Double
//                    temperature.append(" °C")
                    
                    DispatchQueue.main.async {
                        self.locationLabel.text = locationName
                        self.tempLabel.text = String(Int(round(temperature!))) + "°C"
                    }
                    
                } else {
                     print("unable to parse temperature")
                }
                
                
                
            }
            catch let jsonError {
                print(jsonError)
            }
            
        }
        
        print(url)
        
        task.resume()
        
    }
    
}
    
    

