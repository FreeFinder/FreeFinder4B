//
//  ItemsTableViewController.swift
//  FreeFinderMilestone3B
//
//  Created by Jordan Labuda on 11/6/22.
//

import UIKit
import Foundation

class ItemsTableViewController: UITableViewController {

    var items: [Item] = [] // refresh()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        items = [] // refresh()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description
        //cell.imageView?.image = UIImage(named: item.photo)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //println(tasks[indexPath.row])
        // !!!!! need to figure out how to pass id on click, and connect to the item view
        let vc = ItemViewController(nibName: "ItemViewController", bundle: nil);
        let item_fromtable = items[indexPath.row];
       // vc.passed_item = item_fromtable;
        
        vc.itemcoor = item_fromtable.coordinate;
        vc.itemname = item_fromtable.name;
        vc.itemdetail = item_fromtable.detail;
        vc.itemcomments = item_fromtable.comments;
        //vc.passed_item = item_fromtable;
        
        navigationController?.pushViewController(vc, animated: true);

    }

    // !!!!! need to figure out how to pass id on click, and connect to the item view
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
