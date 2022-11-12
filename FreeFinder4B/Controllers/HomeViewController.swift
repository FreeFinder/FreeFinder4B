import UIKit
import MapKit
import RealmSwift
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMap();

    }
    
    func addCurrLocation(with location: CLLocation) {
        let pin = MKPointAnnotation()
        pin.coordinate = location.coordinate
        mapView.setRegion(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(
                                latitudeDelta: 0.005,
                                longitudeDelta: 0.005
                            )
        ),
                          animated: true)
        mapView.addAnnotation(pin)
    }
    
    private func loadMap() {
        if (mapView != nil) {
            view.insetsLayoutMarginsFromSafeArea = false
            let initialLocation = CLLocation(latitude: 41.7886, longitude: -87.5987)
            mapView.centerToLocation(initialLocation)
            Task{
                await refresh()
                // get location of user
                LocationManager.shared.getUserLocation { [weak self] location in
                    DispatchQueue.main.async {
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.addCurrLocation(with: location)
                    }
                }
            }
        }
    }
    
    func refresh() async -> [Item] {
        let user = User(email: "mongodb@gmail.com");
        await user.db_add_user()
        let observer = await AppData(user: user);
        mapView!.removeAnnotations(mapView!.annotations)
        let items = await observer.db_get_all_items();
        for item in items{
            mapView.addAnnotation(item)
        }
        return items
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}


