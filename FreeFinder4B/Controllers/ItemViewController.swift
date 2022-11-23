import UIKit
import MapKit
import Foundation

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBAction func exitButtonPushed(_ sender: UIButton) {
		//self.viewWillDisappear(true);
		presentingViewController?.viewWillAppear(true);
		//esentially i want to make sure that when we exit the item view controllers we always update the controller we came from (especially if we've made changes to it).
		
		self.dismiss(animated: true);
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true);
	}
	
	@IBAction func exitAddCommentPushed(_ sender: UIButton) {
		self.dismiss(animated: true);
	}
	
	@IBAction func decrementCounterPushed(_ sender: UIButton) {
		if(passed_item_counter == 0){
			let alert = CustomAlertController(title: "Cannot Decrement", message: "The quantity of this item is alredy 0, cannot decrement more")
			DispatchQueue.main.async {
				self.present(alert.showAlert(), animated: true, completion: nil)
			}
		}else{
			let locManager = CLLocationManager()
			locManager.requestWhenInUseAuthorization()
			var currentLocation: CLLocation!
			currentLocation = locManager.location
			let item_location = currentLocation.coordinate
			
			Task{
                let og_amount = passed_item.counter
				let did_decr = await passed_item.decrement_quantity(deviceLocation: item_location)
				
				
				if(did_decr){
                    if (og_amount == 1){
                        let user = User(email: "mongodb@gmail.com");
                        await user.db_add_user()
                        let observer = await AppData(user: user);
                        list_items = await observer.db_get_all_items();
                        
                        presentingViewController?.viewWillAppear(true);
                        self.dismiss(animated: true);
                    }
                    else{
                        itemQuantity?.text = String(passed_item_counter);
                        self.viewDidLoad();
                        self.viewWillAppear(true);
                    }

				}else{
					let alert = CustomAlertController(title: "Cannot Decrement", message: "You are not currently near this item.")
					DispatchQueue.main.async {
						self.present(alert.showAlert(), animated: true, completion: nil)
					}
				}
				
			}
		}
	}
    
	func delete_item(alertAction: UIAlertAction) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        let item_location = currentLocation.coordinate
        
		Task{
			let did_del = await passed_item.delete_Item(deviceLocation: item_location);
            if did_del{
                let user = User(email: "mongodb@gmail.com");
                await user.db_add_user()
                let observer = await AppData(user: user);
                list_items = await observer.db_get_all_items();
                
                
                presentingViewController?.viewWillAppear(true);
                self.dismiss(animated: true);
            }
            else {
                let alert = CustomAlertController(title: "Cannot Delete", message: "You are not currently near this item.")
                DispatchQueue.main.async {
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
            }
		}
	}
	
	@IBAction func deletePostPressed(_ sender: Any) {
		Task{
			let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this post?", preferredStyle: .alert);
			
			let ok = UIAlertAction(title: "Confirm", style: .default, handler: delete_item)
			
			let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			
			dialogMessage.addAction(ok)
			dialogMessage.addAction(cancel)
			
			self.present(dialogMessage, animated: true, completion: nil)
		}
	}
	
	var itemcomments = [""];
	var passed_item = Item(name: "", type: "", detail: "", coordinate: CLLocationCoordinate2D(latitude: 20.0, longitude: 150.0), creator_email: "", counter: 0);
	var passed_item_counter = 0;
    var new_comment = "";
	
	@IBOutlet weak var itemName: UILabel!
	@IBOutlet weak var itemLocation: UILabel!
	@IBOutlet weak var itemDescription: UILabel!
	@IBOutlet weak var exit: UIButton!
	//@IBOutlet weak var addComment: UIButton!
	//@IBOutlet weak var newComment: UITextField!
	@IBOutlet weak var itemQuantity: UILabel!
	@IBOutlet weak var decrement: UIButton!
	@IBOutlet weak var deleteItem: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// TODO: connect to data
		itemDescription?.text = passed_item.detail;
		itemName?.text = passed_item.name;
		itemQuantity?.text = String(passed_item.counter);
		passed_item_counter = passed_item.counter;
        itemcomments = passed_item.comments;
        
		// itemLocation?.text = location;
		
		
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
	
	
    @IBAction func addCommentPressed(_ sender: UIButton) {
        let addCVC : AddCommentViewController = UIStoryboard(name: "AddComment", bundle: nil).instantiateViewController(withIdentifier: "AddComment") as! AddCommentViewController

        //TODO: here we need to implement getting comments of an item using that function...
        addCVC.comment_passed_item = passed_item;
        self.present(addCVC, animated: true, completion: nil);
    }
    
}
