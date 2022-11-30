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

class AddCommentViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var exit: UIButton!
    @IBOutlet weak var addComment: UIButton!
    @IBOutlet weak var newComment: UITextView!
    
    var comment_passed_item = Item(name: "", type: "", detail: "", coordinate: CLLocationCoordinate2D(latitude: 20.0, longitude: 150.0), creator_email: "", counter: 0);

    override func viewDidLoad() {
        super.viewDidLoad()
        newComment.layer.borderWidth = 1
        newComment.layer.borderColor = UIColor.label.cgColor
        newComment.textColor = UIColor.lightGray
        newComment.delegate = self
        self.textViewDidBeginEditing(newComment)
        self.textViewDidEndEditing(newComment)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
                new_comment = newComment.text
                presentingViewController?.viewWillAppear(true);
                self.dismiss(animated: true);
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
