import UIKit
import MapKit
import RealmSwift
import CoreLocation

class HomeViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var items: [Item] = [];
    var currFilter = "";
    
    private lazy var food = UIAction(title: "Food", attributes: [], state: currFilter == "Food" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Food");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Food", menu: self.menu);
    }
    
    private lazy var clothing = UIAction(title: "Clothing", attributes: [], state: currFilter == "Clothing" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Clothing");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Clothing", menu: self.menu);
    }
    
    private lazy var furniture = UIAction(title: "Furniture", attributes: [], state: currFilter == "Furniture" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Furniture");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Furniture", menu: self.menu);
    }
    
    private lazy var other = UIAction(title: "Other", attributes: [], state: currFilter == "Other" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Other");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Other", menu: self.menu);
    }
    
    private lazy var nearMe = UIAction(title: "Near Me", attributes: [], state: currFilter == "Near Me" ? .on : .off){ action in
        self.toggleFilter(actionTitle: "Near Me");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Near Me", menu: self.menu);
    }

    private lazy var distanceRadius = UIAction(title: "Within Radius", attributes: [], state: currFilter == "Within Radius" ? .on : .off){action in
        var alert = UIAlertController(title: "Radius", message: "Filter within a radius (in miles)", preferredStyle: .alert)
        
        // 2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        var radius = 0
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0])! as UITextField
            radius = Int(textField.text!) ?? 0
            self.toggleFilter(actionTitle: "Within Radius", radius: radius)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Within Radius", menu: self.menu);
    }
    

    private lazy var elements: [UIAction] = [food, clothing, furniture, other, nearMe, distanceRadius]
    private lazy var menu = UIMenu(title: "Filter by", children: elements)
    
    private func toggleFilter(actionTitle: String? = nil, radius: Int? = nil) {
        if(currFilter == actionTitle && actionTitle != "Within Radius"){
            currFilter = "";
        }
        else{
            currFilter = actionTitle!;
        }
        
        switch currFilter {
            case "Within Radius":
                self.filterItems(distance: radius!);
            case "Near Me":
            self.filterItems(distance: 1);
            default:
                self.filterItems(filterType: currFilter);
        }
    }
    
    private func updateActionState(actionTitle: String? = nil, menu: UIMenu) -> UIMenu {
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    if(actionTitle == "Within Radius"){
                        action.state = .on
                    }
                    else if(action.state == .on){
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
        
        menu = menu.replacingChildren([food, clothing, furniture, other, nearMe, distanceRadius])
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
    
    private func filterItems(filterType: String){
        mapView!.removeAnnotations(mapView!.annotations)
        APP_DATA!.filterMapItems(tag: filterType)
        APP_DATA!.sortMapItemsByDist()
        items = APP_DATA!.getMapItems()
        for item in items{
            mapView.addAnnotation(item)
        }
    }
    
    private func filterItems(distance: Int){
        mapView!.removeAnnotations(mapView!.annotations)
        APP_DATA!.filterMapItems(distance: distance)
        APP_DATA!.sortMapItemsByDist()
        items = APP_DATA!.getMapItems()
        for item in items{
            mapView.addAnnotation(item)
        }
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
        
        Task{
            let exists = await item.db_item_exists();
            if(exists == false){
                let alert = CustomAlertController(title: "Cannot View Listing", message: "This item was recently  deleted, cannot access anymore")
                DispatchQueue.main.async {
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
                list_items = await APP_DATA!.refresh();
                await refresh();
                return;
            }else{
                let itemVC : ItemViewController = UIStoryboard(name: "ViewItem", bundle: nil).instantiateViewController(withIdentifier: "ViewItem") as! ItemViewController
                
                itemVC.passed_item = item;
                self.present(itemVC, animated: true, completion: nil)
            }
        }
        
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


