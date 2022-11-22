import Foundation
import UIKit

class ProfileViewController: UIViewController{
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var signOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        email.text = "\(DEVICE_DATA.email ?? "")";
    }
    
    @IBAction func signOut(_ sender: Any) {
		clearConfig();
		
		let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
		let signInPage = storyBoard.instantiateViewController(withIdentifier: "SignIn") ;
		self.navigationController?.pushViewController(signInPage, animated: true);
    }
}
