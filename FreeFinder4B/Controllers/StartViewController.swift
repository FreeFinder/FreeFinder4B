import Foundation
import UIKit

class StartViewController: UIViewController {
    @IBAction func startApp(_ sender: Any) { // this is how to do programmatic navigation
        Task {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            self.navigationController?.pushViewController(TabBarController, animated: true);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
