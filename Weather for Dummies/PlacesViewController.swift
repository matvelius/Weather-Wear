import UIKit
import GooglePlaces

class PlacesViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode        
        resultsViewController?.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    
}

var places = [GMSPlace]()

// Handle the user's selection.
extension PlacesViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        savePlace(place)
        getWeatherForPlace(place)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func savePlace(_ place: GMSPlace) {
        places.append(place)
        print(places)
    }
    
    func getWeatherForPlace(_ place: GMSPlace) {
//        let urlString = "https://api.apixu.com/v1/current.json?key=f19bd582e9a142e4baa155854193006&q=\(textInput.replacingOccurrences(of: " ", with: "%20"))"
        let urlString = "https://api.apixu.com/v1/current.json?key=f19bd582e9a142e4baa155854193006&q=\(place.name!.replacingOccurrences(of: " ", with: "%20"))"
        

        //        var locationName: String?
        //        var temperature: Double?
        //
        print(urlString)

        guard let url = URL.init(string: urlString) else {
            print("unable to parse URL")
            return
        }
        
        var locationName: String?
        var temperature: Double?
        
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
                        print(temperature!)
//                        updateUI()
//                        self.locationLabel.text = locationName
//                        self.tempLabel.text = String(Int(round(temperature!))) + "°C"
                    }

                } else {
                    print("unable to parse temperature")
                }



            }
            catch let jsonError {
                print(jsonError)
            }
        
        }
        
        task.resume()
        
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let textInput = searchBar.text else {
//            print("not text")
//            return
//        }
//
//
//        let urlString = "https://api.apixu.com/v1/current.json?key=f19bd582e9a142e4baa155854193006&q=\(textInput.replacingOccurrences(of: " ", with: "%20"))"
//
//
//        var locationName: String?
//        var temperature: Double?
//
//        print(urlString)
//
//
//        guard let url = URL.init(string: urlString) else {
//            print("unable to parse URL")
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            guard let dataReceived = data else {
//                print("didn't receive deta")
//                return
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: dataReceived, options: .mutableContainers) as! [String: AnyObject]
//
//                if let location = json["location"] {
//                    locationName = location["name"] as? String
//                } else {
//                    print("unable to parse location")
//                }
//
//                if let current = json["current"] {
//                    temperature = current["temp_c"] as? Double
//                    //                    temperature.append(" °C")
//
//                    DispatchQueue.main.async {
//                        self.locationLabel.text = locationName
//                        self.tempLabel.text = String(Int(round(temperature!))) + "°C"
//                    }
//
//                } else {
//                    print("unable to parse temperature")
//                }
//
//
//
//            }
//            catch let jsonError {
//                print(jsonError)
//            }
//
//        }
//
//        print(url)
//
//        task.resume()
//
//    }
//
}
