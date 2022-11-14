import UIKit
import SwiftUI
import Foundation
import MapKit

class ItemsTableViewController: UITableViewController {

    var items: [Item] = [] ;// refresh()
    
    let item_test = Item(
        name: "Burrito",
        type: "Food",
        detail: "Free Burritos as Reg",
        coordinate: CLLocationCoordinate2D(latitude: 23, longitude: 54),
        creator_email: "mongodb@gmail.com"
    );
    
    let item_test1 = Item(
        name: "Chips and Guac",
        type: "Food",
        detail: "Reg",
        coordinate: CLLocationCoordinate2D(latitude: 23, longitude: 54),
        creator_email: "mongodb@gmail.com"
    );
    
    let item_test2 = Item(
        name: "Clothes and Pizza",
        type: "Clothes",
        detail: "54th and woodlawn",
        coordinate: CLLocationCoordinate2D(latitude: 23, longitude: 54),
        creator_email: "mongodb@gmail.com"
    );
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        items.append(item_test);
        items.append(item_test1);
        items.append(item_test2);
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        
      
        //Task{
       // items.append(item_test)//[item_test]//[item]//await refresh()
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

        let item = items[indexPath.row]
       // cell.textLabel?.numberOfLines = 0;
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = ""
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item_fromtable = items[indexPath.row];

        let itemVC : ItemViewController = UIStoryboard(name: "ViewItem", bundle: nil).instantiateViewController(withIdentifier: "ViewItem") as! ItemViewController
        
        itemVC.itemcomments = ["two left", "one left", "all gone"]; //item_fromtable.comments;
        itemVC.passed_item = item_fromtable;
        self.present(itemVC, animated: true, completion: nil)
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
