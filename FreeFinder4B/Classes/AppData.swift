import Foundation
import CoreLocation
import SwiftUI
import RealmSwift

class AppData {
    var items: [Item] = []; // everything in DB
    var mapItems: [Item] = []; // what is communicated to UI
    var currentFilter: String = "";
    var user: User;
    
    /// Initializes the single AppData object
    /// - Parameter user: the user logged in
    init(user: User) async {
        self.user = user;
        self.items = await db_get_all_items();
        self.mapItems = self.items;
    }
    
    /// Fetches the updated list of items from the database
    /// - Returns: array of items fetched from the database
    func refresh() async -> [Item] {
        self.items = await db_get_all_items();
        return self.items;
    }
    
    /// Filters the database-fetched items to fit the current tags
    /// - Parameter tag: the tag to filter the items by
    func filterMapItems(tag: String) {
        self.currentFilter = "tag";
        self.mapItems = items.filter{( $0.type == tag)}
    };
    
    /// Calculates the distance passed coordinates are from the user's device
    /// - Parameter loc: location coordinates
    /// - Returns: the distance calculated
    func getDistanceFromUser(loc: CLLocation) -> CLLocationDistance{
        let coordinate =  CLLocation(latitude: UserDefaults.standard.value(forKey: "LAT") as! CLLocationDegrees, longitude: UserDefaults.standard.value(forKey: "LON") as! CLLocationDegrees)
        var dist = loc.distance(from: coordinate)
        return dist
    }
    
    /// Gets the map items from itself
    /// - Returns: an array of items stored in the mapItems variable
    func getMapItems() -> [Item]{
        return self.mapItems;
    }
    
    /// Filters the apps current map items by a specified distance
    /// - Parameter distance: number of miles setting the boundary around the item
    func filterMapItems(distance: Int) {
        let d = Double(distance) * 1609.34
        self.mapItems = []
        for i in self.items{
            var temp = CLLocation(latitude: i.coordinate.latitude, longitude: i.coordinate.longitude)
            if getDistanceFromUser(loc: temp) <= d {
                self.mapItems.append(i)
            }
        }
        print (self.mapItems.count)
    }
    
    /// Filters map items by both a tag and a distance
    /// - Parameters:
    ///   - distance:number of miles setting the boundary around the item
    ///   - tag: the tag to filter the items by
    func filterMapItems(distance: Int, tag: String) {
        self.filterMapItems(distance: distance)
        self.mapItems = self.mapItems.filter{( $0.type == tag)}
    }
    
    /// Sorts the map items by distance
    func sortMapItemsByDist() {
        self.mergeSortMapItems(itemlst: &mapItems, startIndex: 0, endIndex: self.mapItems.count)
    }
    
    func mergeSortMapItems(itemlst: inout [Item], startIndex: Int, endIndex: Int){
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
    
    /// Resets the current filter and mapItems
    func filterMap() {
        self.currentFilter = "";
        self.mapItems = self.items;
    }
    
    /// Fetches all items from the database
    /// - Returns: a list of all the items from the database
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
