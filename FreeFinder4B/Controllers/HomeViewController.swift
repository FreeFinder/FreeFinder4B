import UIKit
import MapKit
import RealmSwift
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMap();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.delegate = self
        loadMap();
    }
    
    func addCurrLocation(with location: CLLocation) {
        let currLocation = MKPointAnnotation()
        currLocation.coordinate = location.coordinate
        mapView.centerToLocation(location)
        mapView.addAnnotation(currLocation)
    }
    
    private func loadMap() {
        if (mapView != nil) {
            view.insetsLayoutMarginsFromSafeArea = false
            Task{
                await refresh();
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
        list_items = items;
        for item in items{
            mapView.addAnnotation(item)
        }
        return items
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView? {
     guard let annotation = annotation as? Item else {
        return nil
      }
      
        let identifier = "item";
        var annotationView : MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            // 5
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.calloutOffset = CGPoint(x: -5, y: 5)
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
         }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let item = view.annotation as? Item else {
        return
      }
       // let item_frommap = view.annotation

        let itemVC : ItemViewController = UIStoryboard(name: "ViewItem", bundle: nil).instantiateViewController(withIdentifier: "ViewItem") as! ItemViewController
        
        itemVC.itemcomments = ["two left but they're only tofu or veggie", "one left", "all gone"];
        //itemVC.itemcomments = await item_fromtable.db_get_comments();
        //TODO: here we need to implement getting comments of an item using that function...
        itemVC.passed_item = item;
        self.present(itemVC, animated: true, completion: nil)
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


