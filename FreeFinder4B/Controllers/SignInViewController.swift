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
            // [TODO] Set Error Text
            return;
        };
        Task {
            
            let userInfo = await db_fetch_user(email: email);
            if (userInfo == nil) { // this user was not in the database
                // [TODO] Set Error Text
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
