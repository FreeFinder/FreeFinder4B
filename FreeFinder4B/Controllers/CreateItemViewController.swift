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
        let creator_email = "mongodb@gmail.com"; // implement once singing in is implmeneted
        Task {
            let item = Item(
                name: name,
                type: type,
                detail: detail,
                coordinate: location,
                creator_email: creator_email
            )
            let _ = await item.db_add_item();
            let n = await item.db_item_exists();
            print(n)
        }
    }
}
