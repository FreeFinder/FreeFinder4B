import UIKit
import SwiftUI
import Foundation
import MapKit


var list_items : [Item] = []

class ItemsTableViewController: UITableViewController {
    var items : [Item] = [];
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        items = list_items;
        tableView.reloadData();
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        //TODO: here we need to implement getting all items using refresh, once adding item works.
        
    }
    
    override func viewDidLoad() {
        items = list_items
        tableView.reloadData();
        super.viewDidLoad();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true);
        items = [];
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        let item_fromtable = items[indexPath.row];

        let itemVC : ItemViewController = UIStoryboard(name: "ViewItem", bundle: nil).instantiateViewController(withIdentifier: "ViewItem") as! ItemViewController

        //TODO: here we need to implement getting comments of an item using that function...
        itemVC.passed_item = item_fromtable;
        self.present(itemVC, animated: true, completion: nil);
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
