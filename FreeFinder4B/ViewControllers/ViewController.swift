//
//  ViewController.swift
//  FreeFinders3B
//
//  Created by William Zeng on 11/7/22.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (mapView != nil) {
            view.insetsLayoutMarginsFromSafeArea = false
            let initialLocation = CLLocation(latitude: 41.7886, longitude: -87.5987)
            mapView.centerToLocation(initialLocation)
            Task{
                await refresh()
            }
        }
    }
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var tagInput: UISegmentedControl!
    @IBOutlet weak var descriptionInput: UITextField!
    
    @IBAction func createItem(_ sender: Any) {
        let name = titleInput.text ?? "";
        let type = ITEM_TAGS[tagInput.selectedSegmentIndex];
        let detail = descriptionInput.text ?? "";
        let location = CLLocationCoordinate2D(latitude: 23, longitude: 54); // implement actual location grabbing
        let creator_email = "mongodb@gmail.com"; // implement once singing in is implmeneted
        
        Task {
            let item = await Item(
                name: name,
                type: type,
                detail: detail,
                coordinate: location,
                creator_email: creator_email
            )
            
            print("item id \(item.id)");
        }
    }
    
    func refresh() async -> [Item] {
        let user = await User(email: "mongodb@gmail.com");
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


