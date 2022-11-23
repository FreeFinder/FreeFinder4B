import Foundation
import CoreLocation
import SwiftUI
import RealmSwift

class AppData {
    var items: [Item] = []; // everything in DB
    var mapItems: [Item] = []; // what is communicated to UI
    var currentFilter: String = ""; // "" || "distance" || "tag"
    var user: User;
    
    init(user: User) async {
        self.user = user;
        self.items = await db_get_all_items();
        self.mapItems = self.items;
    }
    
    func refresh() async -> [Item] {
        self.items = await db_get_all_items();
        return self.items;
    }
    
    func filterMapItems(tag: String) {
        self.currentFilter = "tag"; // set in the case that we can filter after refresh()
        self.mapItems = items.filter{( $0.type == tag)}
    };
    
    func getDistanceFromUser(loc: CLLocation) -> CLLocationDistance{
        var dist = CLLocationDistance()
        LocationManager.shared.getUserLocation { [weak self] location in
            DispatchQueue.main.async {}
            dist = loc.distance(from: location)
        }
        return dist
    }
    
    func filterMapItems(distance: Int) { // polymorphism - this one will be used for distance
        // finish this function
        let d = Double(distance) * 1609.34
        self.mapItems = []
        for i in self.items{
            var temp = CLLocation(latitude: i.coordinate.latitude, longitude: i.coordinate.longitude)
            if getDistanceFromUser(loc: temp) <= d{
                self.mapItems.append(i)
            }
        }
        print (self.mapItems.count)
        
    }
    
    func getMapItems() -> [Item]{
        return self.mapItems;
    }
    
    func filterMapItems(distance: Int, tag: String){ // still needs a test
        self.filterMapItems(distance: distance)
        self.mapItems = self.mapItems.filter{( $0.type == tag)}
    }
    
    func sortMapItemsByDist(){
        //TODO: sort mapItems by distance
//        for i in 0 ... self.mapItems.count{
//            for j in (i + 1) ... self.mapItems.count{
//                var temp1 = CLLocation(latitude: self.mapItems[i].coordinate.latitude, longitude: self.mapItems[i].coordinate.longitude)
//                var temp2 = CLLocation(latitude: self.mapItems[j].coordinate.latitude, longitude: self.mapItems[j].coordinate.longitude)
//                if getDistanceFromUser(loc: temp1) > getDistanceFromUser(loc: temp2) {
//                    var temp = self.mapItems[i]
//                    self.mapItems[i] = self.mapItems[j]
//                    self.mapItems[j] = temp
//                }
//            }
//        }
        self.mapItems = mergeSortMapItems(items: mapItems)
    }
    
    func mergeSortMapItems(items: [Item]) -> [Item] {
        var tempItems = items
        if items.count > 1{
            var mid = floor(Double(items.count / 2))
            var left = Array(items[0...Int(mid)])
            var right = Array(items[Int(mid)...items.count])
            
            left = mergeSortMapItems(items: left)
            right = mergeSortMapItems(items: right)
            
            var i = 0
            var j = 0
            
            var k = 0
            
            while i < left.count && j < right.count{
                var leftLoc = CLLocation(latitude: left[i].coordinate.latitude, longitude: left[i].coordinate.longitude)
                var rightLoc = CLLocation(latitude: right[j].coordinate.latitude, longitude: right[j].coordinate.longitude)
                if getDistanceFromUser(loc: leftLoc) <= getDistanceFromUser(loc: rightLoc) {
                    tempItems[k] = left[i]
                    i += 1
                } else {
                    tempItems[k] = right[j]
                    j += 1
                }
                k += 1
            }
            while i < left.count {
                tempItems[k] = left[i]
                i += 1
                k += 1
            }
            while j < right.count {
                tempItems[k] = right[j]
                j += 1
                k += 1
            }
        }
        return tempItems
    }
    
    func filterMap() {
        self.currentFilter = "";
        self.mapItems = self.items;
    }
    
    func db_get_all_items() async -> [Item] {
        var res: [Item] = [];
        do {
            let app = App(id: APP_ID);
            let _ = try await app.login(credentials: Credentials.anonymous);
            
            // fetch the DB
            let client = app.currentUser!.mongoClient("mongodb-atlas")
            let database = client.database(named: "freeFinder")
            let items = database.collection(withName: "items")
            
            let db_items = try await items.find(filter: [:]);
            var temp_item_array: [Item] = [];
            for db_item in db_items {
                let fetchedItem = parseDbItem(dbItem: db_item);
                temp_item_array.append(fetchedItem);
            }
            res = temp_item_array;
        } catch {
            print("Failed to fetch all the items: \(error.localizedDescription)")
        }
        
        return res;
    }
}
