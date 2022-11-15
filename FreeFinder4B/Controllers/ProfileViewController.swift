import Foundation
import UIKit

class ProfileViewController: UIViewController{
    
//    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var email: UILabel!
//    @IBOutlet weak var name: UILabel!
//    @IBOutlet weak var editProfile: UIButton!
    @IBOutlet weak var signOut: UIButton!
    
    override func viewDidLoad() {
        print("hi");
        super.viewDidLoad()
        
//        profileImage.layer.masksToBounds = true
//        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        
        // TODO: connect to data
//        name.text = USER!.id.stringValue
        email.text = "\(DEVICE_DATA.email ?? "")";
    }
    
    @IBAction func signOut(_ sender: Any) {
        let _ = USER!.sign_out();
    }
}
