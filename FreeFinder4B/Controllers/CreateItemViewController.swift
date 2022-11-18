import UIKit
import MapKit

class CreateItemViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var tagInput: UISegmentedControl!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var quantityInput: UITextField!
    
    
    
    @IBAction func createItem(_ sender: Any) {
        let name = titleInput.text ?? "";
        let type = ITEM_TAGS[tagInput.selectedSegmentIndex];
        let detail = descriptionInput.text ?? "";
        
        
        //Getting user's location
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        let item_location = currentLocation.coordinate// implement actual location grabbing

   
        
        //Getting quantity
        let quantity_string = quantityInput.text ?? "";
        var quantity = 0
        if(!quantity_string.isNumber){
            let alert = CustomAlertController(title: "Invalid Quantity", message: "Quantity must be a whole number please try again.")
            DispatchQueue.main.async {
                self.present(alert.showAlert(), animated: true, completion: nil)
            }
            return;
        }else{
            quantity = Int(quantity_string) ?? 0
        }
        
        Task {
            
            let created = await USER!.create_item(
                name: name,
                type: type,
                detail: detail,
                coordinate: item_location,
                quantity: quantity
            );
            
            
            if(created == nil){
                //throw error
                let alert = CustomAlertController(title: "Invalid Submission", message: "Please try again. Make sure all necessary fields are filled.")
                DispatchQueue.main.async {
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
            }else{
                presentingViewController?.viewWillAppear(true);
                self.dismiss(animated: true);
            }
        }
    }
}

extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
