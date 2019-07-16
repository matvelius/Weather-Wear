import UIKit
import GooglePlaces
import CoreLocation

class PlacesViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var whatToWearLabel: UILabel!
    
    @IBOutlet weak var mainContentStack: UIStackView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var currentLocationLatitude: Double?
    var currentLocationLongitude: Double?
    
    var locationName: String?
    var temperature: Double? = 0
    var precipitation: Double?
    var humidity: Int?
    var precipProbability: Double?
    var dewPoint: Double?
    var precipType: String?
    var visibility: Double?
    var darkskyIconName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode        
        resultsViewController?.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 40, width: view.bounds.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        searchController?.searchBar.searchBarStyle = .minimal
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainContentStack.alpha = 0
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
//        self.locationName = locationManager.location.
        self.currentLocationLatitude = locationManager.location?.coordinate.latitude
        self.currentLocationLatitude = locationManager.location?.coordinate.longitude
        
//        print(self.currentLocationLatitude)
        
        
        
//        lookUpCurrentLocation(completionHandler: { _ in print("looking up location")})
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // show alert to user
            print("location services not enabled")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
//            if let currentLatitude = locationManager.location?.coordinate.latitude, let currentLongitude = locationManager.location?.coordinate.longitude {
//                retreiveCityName(latitude: currentLatitude, longitude: currentLongitude, completionHandler: { _ in })
//            } else {
//                print("unable to determine current location")
//            }
        case .denied:
            // show alert instructing them to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show alert
            break
        case .authorizedAlways:
            break
        default: break
        }
    }
    
//    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
//        -> Void ) {
//        // Use the last reported location.
//        if let lastLocation = self.locationManager.location {
//            let geocoder = CLGeocoder()
//
//            // Look up the location and pass it to the completion handler
//            geocoder.reverseGeocodeLocation(lastLocation,
//                completionHandler: { (placemarks, error) in
//                    if error == nil {
//                        let firstLocation = placemarks?[0]
//                        print("firstLocation: \(firstLocation)")
//                        completionHandler{(_) -> () in
//                            print("firstLocation: \(firstLocation?.administrativeArea?.description)")
//                        }
//                    }
//                    else {
//                        // An error occurred during geocoding.
//                        completionHandler(nil)
//                    }
//            })
//        }
//        else {
//            // No location was available.
//            completionHandler(nil)
//        }
//    }
    
    func retreiveCityName(latitude: Double, longitude: Double, completionHandler: @escaping (String?) -> Void)
    {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler:
            {
                placeMarks, error in

//                completionHandler(placeMarks?.first?.locality)
                
                
                print(placeMarks?.first?.locality)
        })
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
        
        mainContentStack.alpha = 0
        
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
    
    
  
    func updateUI() {
        self.locationNameLabel.text = locationName
        self.currentTemperatureLabel.text = String(Int(round(temperature!))) + "°C"
        self.whatToWearLabel.text = outputPhrase
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.mainContentStack.alpha = 1
            
        })
    }
//
}

extension PlacesViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("didUpdateLocations")
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        retreiveCityName(latitude: locValue.latitude, longitude: locValue.longitude, completionHandler: { _ in })
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorization")
        print(locationManager.location?.coordinate)
    }
}
