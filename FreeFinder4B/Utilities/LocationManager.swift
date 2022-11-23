import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization() // requesting permission from user
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
        let location = locations.last! as CLLocation
        let userLocation:CLLocation = locations[0] as CLLocation
        
        UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "LAT")
        UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "LON")
        UserDefaults().synchronize()
        completion?(location) // sending back the results
        manager.stopUpdatingLocation()
    }
    
    public func checkLocationPrefs(_ manager: CLLocationManager) -> Bool {

        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                @unknown default:
                    break
            }
        } else {
            print("Location services are not enabled")
        }
        return false
    }
    
}
