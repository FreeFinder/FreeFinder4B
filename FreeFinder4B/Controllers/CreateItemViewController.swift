import UIKit
import MapKit

class CreateItemViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
	@IBOutlet weak var titleInput: UITextField!
	@IBOutlet weak var tagInput: UISegmentedControl!
	@IBOutlet weak var descriptionInput: UITextView!
	@IBOutlet weak var quantityInput: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		descriptionInput.layer.borderWidth = 1
		descriptionInput.layer.borderColor = UIColor.label.cgColor
		descriptionInput.textColor = UIColor.lightGray
		descriptionInput.delegate = self
		self.textViewDidBeginEditing(descriptionInput)
		self.textViewDidEndEditing(descriptionInput)
		titleInput.delegate = self
		quantityInput.delegate = self
		let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
		view.addGestureRecognizer(tap)
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = "Description"
			textView.textColor = UIColor.lightGray
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	
	@IBAction func createItem(_ sender: Any) {
		let name = titleInput.text ?? "";
		let type = ITEM_TAGS[tagInput.selectedSegmentIndex];
		let detail = descriptionInput.text ?? "";
		
		
		// Getting user's location
		let locManager = CLLocationManager()
		locManager.requestWhenInUseAuthorization()
		var currentLocation: CLLocation!
		currentLocation = locManager.location
		let item_location = currentLocation.coordinate// implement actual location grabbing
		
		
		
		// Getting quantity
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
        
        if(descriptionInput.text == "Description"){
            let alert = CustomAlertController(title: "Invalid Description", message: "No description and 'Description' are not valid inputs")
            DispatchQueue.main.async {
                self.present(alert.showAlert(), animated: true, completion: nil)
            }
            return;
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
				let user = User(email: "mongodb@gmail.com");
				await user.db_add_user()
				let observer = await AppData(user: user);
				list_items = await observer.db_get_all_items();
				
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
