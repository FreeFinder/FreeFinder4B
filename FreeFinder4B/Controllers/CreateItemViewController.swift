import UIKit
import MapKit

class CreateItemViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var tagInput: UISegmentedControl!
    @IBOutlet weak var descriptionInput: UITextField!
    
    @IBAction func createItem(_ sender: Any) {
        let name = titleInput.text ?? "";
        let type = ITEM_TAGS[tagInput.selectedSegmentIndex];
        let detail = descriptionInput.text ?? "";
        let location = CLLocationCoordinate2D(latitude: 23, longitude: 54); // implement actual location grabbing
        let creator_email = USER!.email; //"mongodb@gmail.com"; // implement once singing in is implmeneted
        Task {
            
            let created = await USER!.create_item(
                name: name,
                type: type,
                detail: detail,
                coordinate: location,
                quantity: 10
            );
            
            
            if(created == nil){
                //throw error
                let alert = CustomAlertController(title: "Invalid Submission", message: "Please try again. Make sure all necessary fields are filled.")
                DispatchQueue.main.async {
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
            }else{
                self.dismiss(animated: true);
                let n = await created!.db_item_exists();
                print(n);
            }
        }
    }
}
