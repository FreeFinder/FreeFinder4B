import Foundation
import UIKit

class StartViewController: UIViewController {
    @IBAction func startApp(_ sender: Any) { // this is how to do programmatic navigation
        USER = User(
            email: DEVICE_DATA.email!,
            id: DEVICE_DATA.id
        )
        
        Task {
            APP_DATA = await AppData(user: USER!);
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            self.navigationController?.pushViewController(TabBarController, animated: true);
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
