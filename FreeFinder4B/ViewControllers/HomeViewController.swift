import UIKit
import MapKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMap();

    }
    
    private func loadMap() {
        if (mapView != nil) {
            view.insetsLayoutMarginsFromSafeArea = false
            let initialLocation = CLLocation(latitude: 41.7886, longitude: -87.5987)
            mapView.centerToLocation(initialLocation)
            Task{
                await refresh()
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


