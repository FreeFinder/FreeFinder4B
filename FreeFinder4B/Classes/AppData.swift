import Foundation
import CoreLocation
import SwiftUI
import RealmSwift

class AppData {
    var items: [Item] = [];
    var mapItems: [Item] = [];
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
    
    func filterMapItems(distance: Int) { // polymorphism - this one will be used for distance
        self.currentFilter = "tag";
        // finish this function
    }
    
    func sortMapItemsByDist(){
        //TODO: sort mapItems by distance
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
    
    private func parseDbItem(dbItem: Document) -> Item {
        let id: ObjectId = (dbItem["_id"]!!).objectIdValue!;
        let name = (dbItem["name"]!!).stringValue!;
        let type = (dbItem["type"]!!).stringValue!;
        let details = (dbItem["details"]!!).stringValue!;
        
        let longitude = (dbItem["longitude"]!!).stringValue!;
        let latitude = (dbItem["latitude"]!!).stringValue!;
        let coordinates = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(floatLiteral: Double(latitude)!),
            longitude: CLLocationDegrees(floatLiteral: Double(longitude)!)
        )
        
        let creator_email = (dbItem["creator_email"]!!).stringValue!;
        
        return Item(
            name: name,
            type: type,
            detail: details,
            coordinate: coordinates,
            creator_email: creator_email,
            id: id
        )
    }
}
