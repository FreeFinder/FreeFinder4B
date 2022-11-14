import UIKit
import MapKit
import Foundation

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBAction func exitButtonPushed(_ sender: UIButton) {
        self.dismiss(animated: true);
    }
    
    @IBAction func exitAddCommentPushed(_ sender: UIButton) {
        self.dismiss(animated: true);
    }
    
    //var itemname = "";
    //var itemdetail = "";
    //var itemcoor = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0);
    var itemcomments = [""];
    
    var passed_item = Item(name: "", type: "", detail: "", coordinate: CLLocationCoordinate2D(latitude: 20.0, longitude: 150.0), creator_email: "");
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemLocation: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var exit: UIButton!
    @IBOutlet weak var addComment: UIButton!
    @IBOutlet weak var newComment: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: connect to data
        itemDescription?.text = passed_item.detail;
        itemName?.text = passed_item.name;
                
                
        let lat = String(passed_item.coordinate.latitude);
        let long = String(passed_item.coordinate.longitude);
        let latloc = "Latitude: " + lat;
        let longloc = ", Longitude: " + long;
        let location = latloc + longloc;
        itemLocation?.text = location;
        
        
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
        Task{
            let valid_comment = await USER?.comment(i: passed_item, comment: newComment?.text ?? "");
            if(valid_comment == false){
                let alert = CustomAlertController(title: "Invalid Comment", message: "Please try commenting again. Remember comments must be alphanumeric and under 250 characters.")
                DispatchQueue.main.async {
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
            }else{
                self.dismiss(animated: true);
            }
        }
    }

}
