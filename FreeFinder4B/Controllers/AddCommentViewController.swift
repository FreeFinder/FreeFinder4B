//
//  AddCommentViewController.swift
//  FreeFinder4B
//
//  Created by Ruxandra Nicolae on 11/22/22.
//

import UIKit
import SwiftUI
import Foundation
import MapKit

class AddCommentViewController: UIViewController {
    @IBOutlet weak var exit: UIButton!
    @IBOutlet weak var addComment: UIButton!
    @IBOutlet weak var newComment: UITextField!
    
    var comment_passed_item = Item(name: "", type: "", detail: "", coordinate: CLLocationCoordinate2D(latitude: 20.0, longitude: 150.0), creator_email: "", counter: 0);

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func postCommentButtonPressed(_ sender: UIButton) {
        Task{
            let valid_comment = await USER?.comment(
                item: comment_passed_item,
                comment: newComment?.text ?? ""
            );
            if(valid_comment == false){
                let alert = CustomAlertController(title: "Invalid Comment", message: "Please try again.")
                DispatchQueue.main.async {
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
            }else{
                //comment_passed_item.comments.append();
                if let presenter = self.presentingViewController as? ItemViewController {
                    presenter.new_comment = newComment?.text ?? "";
                    presenter.itemDescription?.text = "Got you"
                    presenter.viewWillAppear(true);
                    presenter.viewDidLoad();
                    print("is item")
                    }
               
                self.dismiss(animated: true);
                
                //self.dismiss(animated: true);
            }
        }
    }
    @IBAction func exitPressed(_ sender: UIButton) {
        self.dismiss(animated: true);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
