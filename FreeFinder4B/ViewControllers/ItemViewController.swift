//
//  ItemViewController.swift
//  FreeFinderMilestone3B
//
//  Created by Ruxandra Nicolae on 11/6/22.
//

import UIKit
import MapKit

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func exitButtonPushed(_ sender: UIButton) {
        self.dismiss(animated: true);
    }
    
   // var passed_item = Item(name: "", type: "", detail: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), creator_email: "");
    
    var itemname = "";
    var itemdetail = "";
    var itemcoor = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0);
    var itemcomments = [""];
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var exit: UIButton!
    @IBOutlet weak var addComment: UIButton!
    @IBOutlet weak var newComment: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        itemImage.layer.masksToBounds = true
        itemImage.layer.cornerRadius = itemImage.bounds.width / 2
        
        // TODO: connect to data
        itemDescription.text = itemdetail;
        itemName.text = itemname;
                
                
        let lat = String(itemcoor.latitude);
        let long = String(itemcoor.longitude);
        let latloc = "Latitude: " + lat;
        let longloc = ", Longitude: " + long;
        let location = latloc + longloc;
            
        itemLocation.text = location;
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemcomments.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        
        let writing_comment = itemcomments[indexPath.row];
        cell?.textLabel!.text = writing_comment;

        return cell!
    }
    
    
    @IBAction func postCommentButtonPressed(_ sender: UIButton) {
        //TODO: in iteration 2 need to be able to add comments
        //let current_user = User//passed_item.creator;
        //let comment_out = current_user.comment(i: passed_item, comment: newComment.text ?? " ");
        
        //currently commenting directly not through user need to figure out how to get user
        //let comment_out = passed_item.add_Comment(comment: newComment.text ?? "");
        //if(comment_out == false){
            //here we can throw an error for a wrong comment
       // }
    }

}
