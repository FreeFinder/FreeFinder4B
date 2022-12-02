import UIKit
import SwiftUI
import Foundation
import MapKit


var list_items : [Item] = []

class ItemsTableViewController: UITableViewController {
    @IBOutlet weak var button: UIBarButtonItem!
    var items: [Item] = [];
    var currFilter = "";
    
    private lazy var food = UIAction(title: "Food", attributes: [], state: currFilter == "Food" ? .on : .off) { action in
            self.toggleFilter(actionTitle: "Food");
            self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Food", menu: self.menu);
    }
        
    private lazy var clothing = UIAction(title: "Clothing", attributes: [], state: currFilter == "Clothing" ? .on : .off) { action in
            self.toggleFilter(actionTitle: "Clothing");
            self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Clothing", menu: self.menu);
    }
        
    private lazy var furniture = UIAction(title: "Furniture", attributes: [], state: currFilter == "Furniture" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Furniture");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Furniture", menu: self.menu);
    }
        
    private lazy var other = UIAction(title: "Other", attributes: [], state: currFilter == "Other" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Other");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Other", menu: self.menu);
    }
        
    private lazy var nearMe = UIAction(title: "Near Me", attributes: [], state: currFilter == "Near Me" ? .on : .off){ action in
        self.toggleFilter(actionTitle: "Near Me");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Near Me", menu: self.menu);
    }
    
    private lazy var distanceRadius = UIAction(title: "Within Radius", attributes: [], state: currFilter == "Within Radius" ? .on : .off){action in
        var alert = UIAlertController(title: "Radius", message: "Filter within a radius (in miles)", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })

        //3. Grab the value from the text field, and print it when the user clicks OK.
        var radius = 0
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0])! as UITextField
            radius = Int(textField.text!) ?? 0
            self.toggleFilter(actionTitle: "Within Radius", radius: radius)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Within Radius", menu: self.menu);
    }
    
    private lazy var elements: [UIAction] = [food, clothing, furniture, other, nearMe, distanceRadius]
    private lazy var menu = UIMenu(title: "Filter by", children: elements)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        items = list_items;
        tableView.reloadData();
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
        //TODO: here we need to implement getting all items using refresh, once adding item works.
        
    }
    
    private func toggleFilter(actionTitle: String? = nil, radius: Int? = nil) {
        if(currFilter == actionTitle && actionTitle != "Within Radius"){
            currFilter = "";
        }
        else{
            currFilter = actionTitle!;
        }
        
        switch currFilter {
            case "Within Radius":
                self.filterItems(distance: radius!);
            case "Near Me":
                self.filterItems(distance: 1)
            default:
                self.filterItems(filterType: currFilter);
        }
    }
    
    private func updateActionState(actionTitle: String? = nil, menu: UIMenu) -> UIMenu {
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    if(actionTitle == "Within Radius"){
                        action.state = .on
                    }
                    else if(action.state == .on){
                        action.state = .off
                    }
                    else{
                        action.state = .on
                    }
                }
                else{
                    action.state = .off
                }
            }
        } else {
            let action = menu.children.first as? UIAction
                action?.state = .on
            }
            return menu
    }
    
    
    override func viewDidLoad() {
        items = list_items
        tableView.reloadData();
        
        menu = menu.replacingChildren([food, clothing, furniture, other, nearMe, distanceRadius])
        navigationItem.leftBarButtonItem?.menu = menu
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
            Task{
                let item_fromtable = items[indexPath.row];
                let exists = await item_fromtable.db_item_exists();
                if(exists == false){
                    let alert = CustomAlertController(title: "Cannot View Listing", message: "This item has just been deleted, cannot access anymore")
                    DispatchQueue.main.async {
                        self.present(alert.showAlert(), animated: true, completion: nil)
                    }
                    items = await APP_DATA!.refresh()
                    tableView.reloadData();
                    return;
                }
                let itemVC : ItemViewController = UIStoryboard(name: "ViewItem", bundle: nil).instantiateViewController(withIdentifier: "ViewItem") as! ItemViewController
                
                itemVC.passed_item = item_fromtable;
                self.present(itemVC, animated: true, completion: nil);
                
            }
        }
    
    private func filterItems(filterType: String){
            items = list_items
            if(filterType != ""){
                APP_DATA!.filterMapItems(tag: filterType)
                APP_DATA!.sortMapItemsByDist()
                items = APP_DATA!.getMapItems();
            }
            tableView.reloadData();
        }
        
        private func filterItems(distance: Int){
            items = list_items;
            APP_DATA!.filterMapItems(distance: distance)
            APP_DATA!.sortMapItemsByDist()
            items = APP_DATA!.getMapItems();
            tableView.reloadData();
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
