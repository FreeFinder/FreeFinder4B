import UIKit

class MainNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let TabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
        let SignInController = storyBoard.instantiateViewController(withIdentifier: "SignIn") as UIViewController
        
        if (1 == 2) {
            self.pushViewController(SignInController, animated: true);
        } else {
            self.pushViewController(TabBarController, animated: true);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
}
