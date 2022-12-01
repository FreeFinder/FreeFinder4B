import Foundation
import UIKit

class CustomAlertController: NSObject {
    
    let message:String?
    let title:String?
    
    init(title:String, message:String) {
        self.message = message
        self.title = title
    }
    

    func showAlert()->UIAlertController {
        let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        return alertController
    }
    
}
