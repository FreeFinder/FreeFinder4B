import Foundation
import RealmSwift
import UIKit

class SignUpViewController: UIViewController {
	let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
	@IBOutlet weak var emailInput: UITextField!
	
	@IBAction func signUp(_ sender: Any) {
		let email: String = emailInput.text ?? "";
		
		let emailIsValid = validEmail(email: email);
		if (!emailIsValid) {
			let alert = CustomAlertController(title: "Cannot Sign Up", message: "Not a valid email address. Either account already exists or not a @uchicago.edu email.")
			DispatchQueue.main.async {
				self.present(alert.showAlert(), animated: true, completion: nil)
			}
			return;
		};
		Task {
			USER = User(email: email);
			await USER?.db_add_user();
			
			let id: ObjectId = USER!.id;
			if (id == ObjectId() || id.stringValue == "") { return };
			DEVICE_DATA.saveLocalUser(email: email, id: id.stringValue);
			
			APP_DATA = await AppData(user: USER!);
			
			let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController;
			self.navigationController?.pushViewController(TabBarController, animated: true);
		}
	}
	
	@IBAction func navigateToSignIn(_ sender: Any) {
		let SignInController = storyBoard.instantiateViewController(withIdentifier: "SignIn") as UIViewController;
		
		self.navigationController?.pushViewController(SignInController, animated: true);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}
