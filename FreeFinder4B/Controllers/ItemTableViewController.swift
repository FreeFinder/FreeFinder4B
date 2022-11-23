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
        
    private lazy var distance = UIAction(title: "Closest to Me", attributes: [], state: currFilter == "Closest to Me" ? .on : .off){ action in
        self.toggleFilter(actionTitle: "Closest to Me");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Closest to Me", menu: self.menu);
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
    
    private lazy var elements: [UIAction] = [food, clothing, furniture, other]
    private lazy var menu = UIMenu(title: "Category", children: elements)
    
    private lazy var deferredMenu = UIDeferredMenuElement { (menuElements) in
        let menu = UIMenu(title: "Distance", options: .displayInline,  children: [self.distance, self.distanceRadius])
            menuElements([menu])
        }
    
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
        if(currFilter == actionTitle){
            currFilter = "";
        }
        else{
            currFilter = actionTitle!;
        }
        
        switch currFilter {
        case "Within Radius":
            self.filterItems(distance: radius!);
        case "Closest to Me":
            APP_DATA!.sortMapItemsByDist()
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
                    if(action.state == .on){
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
        
        menu = menu.replacingChildren([food, clothing, furniture, other, deferredMenu])
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
        let item_fromtable = items[indexPath.row];

        let itemVC : ItemViewController = UIStoryboard(name: "ViewItem", bundle: nil).instantiateViewController(withIdentifier: "ViewItem") as! ItemViewController

        //TODO: here we need to implement getting comments of an item using that function...
        itemVC.passed_item = item_fromtable;
        self.present(itemVC, animated: true, completion: nil);
    }
    
    private func filterItems(filterType: String){
        if (filterType == ""){
            items = list_items
        }
        else{
            APP_DATA!.filterMapItems(tag: filterType)
            items = APP_DATA!.getMapItems();
        }
        tableView.reloadData();
    }
    
    private func filterItems(distance: Int){
        APP_DATA!.filterMapItems(distance: distance)
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
