import UIKit
import MapKit
import Foundation

var item_view_commment_list : [String] = []
var new_comment = "";

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBAction func exitButtonPushed(_ sender: UIButton) {
		presentingViewController?.viewWillAppear(true);
		self.dismiss(animated: true);
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true);
		if(new_comment != ""){
			itemcomments.append(new_comment);
		}
		new_comment = "";
		myTableView.reloadData();
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
                        let v = self.view;
                        self.showSpinner(onView: v!)
						let user = User(email: "mongodb@gmail.com");
						await user.db_add_user()
						let observer = await AppData(user: user);
						list_items = await observer.db_get_all_items();
                        self.removeSpinner();
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
            let v = self.view;
            self.showSpinner(onView: v!)
            let did_del = await passed_item.delete_Item(deviceLocation: item_location);
			if did_del{
				let user = User(email: "mongodb@gmail.com");
				await user.db_add_user()
				let observer = await AppData(user: user);
				list_items = await observer.db_get_all_items();
				
				
				presentingViewController?.viewWillAppear(true);
                self.removeSpinner();
				self.dismiss(animated: true);
			}
			else {
                self.removeSpinner();
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
	
	@IBOutlet weak var itemName: UILabel!
	@IBOutlet weak var itemLocation: UILabel!
	@IBOutlet weak var itemDescription: UILabel!
	@IBOutlet weak var exit: UIButton!
	@IBOutlet weak var itemQuantity: UILabel!
	@IBOutlet weak var decrement: UIButton!
	@IBOutlet weak var deleteItem: UIButton!
	@IBOutlet weak var scroller: UIScrollView!
	@IBOutlet weak var myTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		itemDescription?.text = passed_item.detail;
		itemName?.text = passed_item.name;
		itemQuantity?.text = String(passed_item.counter);
		passed_item_counter = passed_item.counter;
		itemcomments = passed_item.comments;
		if(new_comment != ""){
			itemcomments.append(new_comment);
		}
		
		myTableView.reloadData();
	}
	
	override func viewDidLayoutSubviews() {
		scroller.isScrollEnabled = true
	}
	
	
	func calculateHeight(inString:String) -> CGFloat{
		let messageString = inString
		let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)]
		
		let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
		
		let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
		
		let requredSize:CGRect = rect
		return requredSize.height
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemcomments.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell");
		
		let writing_comment = itemcomments[indexPath.row];
		cell?.textLabel!.text = writing_comment;
		cell?.textLabel!.numberOfLines=0;
		return cell!
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let heightOfRow = self.calculateHeight(inString: itemcomments[indexPath.row].description)
		return (heightOfRow + 20.0)
	}
	
	
	@IBAction func addCommentPressed(_ sender: UIButton) {
		let addCVC : AddCommentViewController = UIStoryboard(name: "AddComment", bundle: nil).instantiateViewController(withIdentifier: "AddComment") as! AddCommentViewController
		
		addCVC.comment_passed_item = passed_item;
		self.present(addCVC, animated: true, completion: nil);
	}
	
}


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
