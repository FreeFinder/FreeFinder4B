import Foundation
import RealmSwift
import UIKit

class SignInViewController: UIViewController {
	let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
	
	@IBOutlet weak var emailInput: UITextField!
	
	@IBAction func signIn(_ sender: Any) {
		let email: String = emailInput.text ?? "";
		
		let emailIsValid = validEmail(email: email);
		if (!emailIsValid) {
			let alert = CustomAlertController(title: "Invalid Email", message: "Inputed email is not valid. Try again")
			DispatchQueue.main.async {
				self.present(alert.showAlert(), animated: true, completion: nil)
			}
			return;
		};
		Task {
			
			let userInfo = await db_fetch_user(email: email);
			if (userInfo == nil) { // this user was not in the database
				let alert = CustomAlertController(title: "Invalid Email", message: "This email is not associated with a pre-existing account. Try signing up first.")
				DispatchQueue.main.async {
					self.present(alert.showAlert(), animated: true, completion: nil)
				}
				return;
			}
			
			USER = userInfo!;
			let id: ObjectId = USER!.id;
			if (id == ObjectId() || id.stringValue == "") { return };
			DEVICE_DATA.saveLocalUser(email: email, id: id.stringValue);
			
			APP_DATA = await AppData(user: USER!);
			
			
			let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController;
			self.navigationController?.pushViewController(TabBarController, animated: true);
		}
	}
	
	@IBAction func navigateToSignUp(_ sender: Any) {
		let SignUpController = storyBoard.instantiateViewController(withIdentifier: "SignUp") as UIViewController;
		
		self.navigationController?.pushViewController(SignUpController, animated: true);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}
