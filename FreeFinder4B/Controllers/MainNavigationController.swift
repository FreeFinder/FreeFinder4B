import UIKit

class MainNavigationController: UINavigationController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        
        setupApp();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        setupApp();

    }
    
    private func setupApp() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let StartController = storyBoard.instantiateViewController(withIdentifier: "Start") as UIViewController;
        let SignInController = storyBoard.instantiateViewController(withIdentifier: "SignIn") as UIViewController;
        
        let initialView = (DEVICE_DATA.userSignedIn()) ? StartController : SignInController;
        self.pushViewController(initialView, animated: true);
    }
}
