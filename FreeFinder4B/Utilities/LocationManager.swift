import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
	static let shared = LocationManager()
	let manager = CLLocationManager()
	var completion: ((CLLocation) -> Void)?
	
	
	/// Gets the users current location
	/// - Parameter completion: a callback utilziing the location to be called once the location is found
	public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
		self.completion = completion
		manager.requestWhenInUseAuthorization() // requesting permission from user
		manager.delegate = self
		manager.startUpdatingLocation()
	}
	
	/// Sets the users current location to local storage
	/// - Parameters:
	///   - manager: a phone location manager object
	///   - locations: list of locations
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else {
			return
		}
		let userLocation:CLLocation = locations[0] as CLLocation
		
		UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "LAT")
		UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "LON")
		UserDefaults().synchronize()
		completion?(location) // sending back the results
		manager.stopUpdatingLocation()
	}
	
	/// Checks whether a user is granting access to location preferences
	/// - Returns: a boolean of whether the user is granting access to location preferences
	public func checkLocationPrefs() -> Bool {
		let manager = CLLocationManager()
		
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
