import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    @IBAction func signIn(_ sender: Any) {
        DEVICE_DATA.saveLocalUser(email: "sample_email@gmail.com", id: "636b39e6f805b7b76c5a2099");
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController;
        
        self.navigationController?.pushViewController(TabBarController, animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
