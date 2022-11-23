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
            print(location)
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
        self.mergeSortMapItems(itemlst: &mapItems, startIndex: 0, endIndex: self.mapItems.count)
    }
    
    func mergeSortMapItems(itemlst: inout [Item], startIndex: Int, endIndex: Int){
//        var tempItems = itemlst
        if itemlst.count > 1 {
            let middleIndex = endIndex / 2
            var left = Array(itemlst[startIndex..<middleIndex])
            var right = Array(itemlst[middleIndex..<endIndex])
            
            self.mergeSortMapItems(itemlst: &left, startIndex: 0, endIndex: left.count)
            self.mergeSortMapItems(itemlst: &right, startIndex: 0, endIndex: right.count)
            
            var l = 0
            var r = 0
            
            var k = startIndex
            
            while l < left.count && r < right.count{
                let leftLoc = CLLocation(latitude: left[l].coordinate.latitude, longitude: left[l].coordinate.longitude)
                let rightLoc = CLLocation(latitude: right[r].coordinate.latitude, longitude: right[r].coordinate.longitude)
                print(getDistanceFromUser(loc: leftLoc) )
                if getDistanceFromUser(loc: leftLoc) < getDistanceFromUser(loc: rightLoc) {
                    itemlst[k] = left[l]
                    l += 1
                } else {
                    itemlst[k] = right[r]
                    r += 1
                }
                k += 1
            }
            while l < left.count {
                itemlst[k] = left[l]
                l += 1
                k += 1
            }
            while r < right.count {
                itemlst[k] = right[r]
                r += 1
                k += 1
            }
        }
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
