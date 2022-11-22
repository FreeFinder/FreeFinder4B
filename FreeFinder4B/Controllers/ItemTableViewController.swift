import UIKit
import SwiftUI
import Foundation
import MapKit

var list_items: [Item] = [];

class ItemsTableViewController: UITableViewController {
    @IBOutlet weak var button: UIBarButtonItem!
    var items: [Item] = [];
    var categoryFilter = "";
    
    private lazy var food = UIAction(title: "Food", attributes: [], state: categoryFilter == "Food" ? .on : .off) { action in
            self.toggleFilter(actionTitle: "Food");
            self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Food", menu: self.menu);
    }
        
    private lazy var clothing = UIAction(title: "Clothing", attributes: [], state: categoryFilter == "Clothing" ? .on : .off) { action in
            self.toggleFilter(actionTitle: "Clothing");
            self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Clothing", menu: self.menu);
    }
        
    private lazy var furniture = UIAction(title: "Furniture", attributes: [], state: categoryFilter == "Furniture" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Furniture");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Furniture", menu: self.menu);
    }
        
    private lazy var other = UIAction(title: "Other", attributes: [], state: categoryFilter == "Other" ? .on : .off) { action in
        self.toggleFilter(actionTitle: "Other");
        self.navigationItem.leftBarButtonItem?.menu = self.updateActionState(actionTitle: "Other", menu: self.menu);
    }
        
    private lazy var distance = UIAction(title: "Closest to Me"){ _ in
        APP_DATA!.sortMapItemsByDist();
    }
    
    private lazy var elements: [UIAction] = [food, clothing, furniture, other]
    private lazy var menu = UIMenu(title: "Category", children: elements)
    
    private lazy var deferredMenu = UIDeferredMenuElement { (menuElements) in
        let menu = UIMenu(title: "Distance", options: .displayInline,  children: [self.distance])
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
    
    private func toggleFilter(actionTitle: String? = nil){
        if(categoryFilter == actionTitle){
            categoryFilter = "";
        }
        else{
            categoryFilter = actionTitle!;
        }
        APP_DATA!.filterMapItems(tag: categoryFilter);
        self.filterItems(filterType: categoryFilter);
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
        super.viewDidLoad();
        items = list_items;
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
        
        itemVC.itemcomments = ["two left but they're only tofu or veggie", "one left", "all gone"];
        //itemVC.itemcomments = await item_fromtable.db_get_comments();
        //TODO: here we need to implement getting comments of an item using that function...
        itemVC.passed_item = item_fromtable;
        self.present(itemVC, animated: true, completion: nil);
    }
    
    private func filterItems(filterType: String){
        items = list_items;
        if(filterType != ""){
            items = items.filter{$0.type == filterType}
        }
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
