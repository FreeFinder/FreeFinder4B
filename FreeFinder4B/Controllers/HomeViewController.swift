import UIKit
import MapKit
import RealmSwift
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var items: [Item] = [];
    var categoryFilter = "";
    
    private lazy var food = UIAction(title: "Food", attributes: [], state: categoryFilter == "Food" ? .on : .off) { action in
            self.toggleFilter(actionTitle: "Food");
            self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Food", menu: self.menu);
    }
        
    private lazy var clothing = UIAction(title: "Clothing", attributes: [], state: categoryFilter == "Clothing" ? .on : .off) { action in
            self.toggleFilter(actionTitle: "Clothing");
            self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Clothing", menu: self.menu);
    }
        
    private lazy var furniture = UIAction(title: "Furniture", attributes: [], state: categoryFilter == "Furniture" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Furniture");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Furniture", menu: self.menu);
    }
        
    private lazy var other = UIAction(title: "Other", attributes: [], state: categoryFilter == "Other" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Other");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Other", menu: self.menu);
    }
        
    private lazy var distance = UIAction(title: "Closest to Me"){ _ in
        APP_DATA!.sortMapItemsByDist();
    }
    
    private lazy var elements: [UIAction] = [food, clothing, furniture, other]
    private lazy var menu = UIMenu(title: "Category", children: elements)
    
    private lazy var deferredMenu = UIDeferredMenuElement { (menuElements) in
        let menu = UIMenu(title: "Distance", options: .displayInline,  children: [self.distance])
            menuElements([menu])
        }
    
    private func toggleFilter(actionTitle: String? = nil) {
        if(categoryFilter == actionTitle){
            categoryFilter = "";
        }
        else{
            categoryFilter = actionTitle!;
        }
        APP_DATA!.filterMapItems(tag: categoryFilter);
        self.filterItems(filterType: categoryFilter);
    }
    
    private func updateActionState(actionTitle: String? = nil, menu: UIMenu) -> UIMenu {
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    if(action.state == .on){
                        action.state = .off
                    }
                    else{
                        action.state = .on
                    }
                }
                else{
                    action.state = .off
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        return menu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        loadMap();
        
        menu = menu.replacingChildren([food, clothing, furniture, other, deferredMenu])
        navigationItem.leftBarButtonItem?.menu = menu
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.delegate = self
        loadMap();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Task{
            super.viewDidAppear(animated)
            await refresh()
            
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        Task{
            await refresh()
        }
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

    func refresh() async{
        mapView!.removeAnnotations(mapView!.annotations)
        let items = await APP_DATA!.refresh()
        //let items = APP_DATA!.mapItems
        list_items = items
        for item in items{
            mapView.addAnnotation(item)
        }
        return
    }
    
    private func filterItems(filterType: String) -> [Item]{
        mapView!.removeAnnotations(mapView!.annotations)
        var filteredItems = list_items;
        if(filterType != ""){
            filteredItems = list_items.filter{$0.type == filterType}
            for item in filteredItems{
                mapView.addAnnotation(item)
            }
        }
        else{
            for item in list_items{
                mapView.addAnnotation(item)
            }
        }
        print(filteredItems)
        return filteredItems
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


