import Foundation
import SwiftUI
import MapKit
import RealmSwift
import Realm

class Item: NSObject, MKAnnotation{
    let name: String
    let type: String
    let coordinate: CLLocationCoordinate2D
    var comments: [String]
    let detail: String
    private let creator_email: String
    let counter: Int
    var id: ObjectId
    
    init(
        name: String,
        type: String,
        detail: String,
        coordinate: CLLocationCoordinate2D,
        creator_email: String,
        comments: [String] = [],
        counter: Int = 1,
        id: ObjectId = ObjectId()
    )
    {
        self.name = name;
        self.type = type;
        self.coordinate = coordinate;
        self.creator_email = creator_email;
        self.comments = comments;
        self.counter = counter;
        self.detail = detail;
        self.id = id;
        
        super.init()
    }
    
    var title: String? { return name }
    var subtitle: String? { return type }
    
    private func db_get_items_collection() async -> RLMMongoCollection? {
        var items: RLMMongoCollection? = nil;
        
        do {
            let app = App(id: APP_ID);
            let user = try await app.login(credentials: Credentials.anonymous);
            // fetch the DB
            let client = app.currentUser!.mongoClient("mongodb-atlas")
            let database = client.database(named: "freeFinder")
            items = database.collection(withName: "items")
        } catch {
            print("Could not fetch the items collection");
        }
        return items;
    }
    
    func db_add_item() async -> ObjectId {
        if (self.id == ObjectId()) { return self.id }; // if the object has an id, its already in the DB
        
        var res: ObjectId = ObjectId();
        do {
            let items: RLMMongoCollection = await db_get_items_collection()!
            
            // create an item and insert it
            let item: Document = [
                "name": AnyBSON(stringLiteral: self.name),
                "type": AnyBSON(stringLiteral: self.type),
                "latitude": AnyBSON(stringLiteral: String(self.coordinate.latitude)),
                "longitude": AnyBSON(stringLiteral: String(self.coordinate.longitude)),
                "details": AnyBSON(stringLiteral: self.detail),
                "creator_email": AnyBSON(stringLiteral: self.creator_email),
                "comments": [],
                "counter": 1
            ]
            
            let objectId: AnyBSON = try await items.insertOne(item)
            self.id = objectId.objectIdValue!;
            if (self.id.stringValue != "") {
                print("Successfully inserted item. The returned id is \(self.id)")
                res = self.id;
            }
        } catch {
            print("Login and item insertion failed: \(error.localizedDescription)")
        }
        
        return res;
    }
    
    func db_item_exists() async -> Bool {
        var res = false;
        
        do {
            let items: RLMMongoCollection = await db_get_items_collection()!
                
            let item: Document = [
                "name": AnyBSON(stringLiteral: self.name),
                "longitude": AnyBSON(stringLiteral: String(self.coordinate.longitude)),
                "latitude": AnyBSON(stringLiteral: String(self.coordinate.latitude)),
            ]
            
            let document = try await items.findOneDocument(filter: item);
            if (document == nil) {
                print("Could not find this document in the database!");
            } else {
                print("This item exists in the database: \(String(describing: document))")
                res = true;
            }
        } catch {
            print("Checking whether an item existed failed, inconclusive: \(error.localizedDescription)")
        }
        
        return res;
    }
    
    func db_delete_item() async -> Bool {
        var res = false;
        
        do {
            let items: RLMMongoCollection = await db_get_items_collection()!
            
            let itemQuery: Document = [
                "name": AnyBSON(stringLiteral: self.name),
                "longitude": AnyBSON(stringLiteral: String(self.coordinate.longitude)),
                "latitude": AnyBSON(stringLiteral: String(self.coordinate.latitude)),
            ]
            
            let _ = try await items.deleteOneDocument(filter: itemQuery)
            print("Successfully deleted this item \(self.id) from the database");
            res = true;
            
        } catch {
            print("Login and item deletion failed: \(error.localizedDescription)")
        }
        
        return res;
    }
    
    func delete_Item() async {
        //deletes if item in database 
        if (await self.db_item_exists()){
            await db_delete_item();
            await refresh()
        }
    }
    
    func decrement_quantity(i: Item) async -> Bool {
        return false
    }
    
    
    func db_get_comments() async -> [String] {
        var rv: [String] = []
//        do {
//            let app = App(id: APP_ID);
//            let user = try await app.login(credentials: Credentials.anonymous);
//            // fetch the DB
//            let client = app.currentUser!.mongoClient("mongodb-atlas")
//            let database = client.database(named: "freeFinder")
//            let items = database.collection(withName: "items")
//
//            let item: Document = [
//                "name": AnyBSON(stringLiteral: self.name),
//                "longitude": AnyBSON(stringLiteral: String(self.coordinate.longitude)),
//                "latitude": AnyBSON(stringLiteral: String(self.coordinate.latitude)),
//            ]
//
//            let selected_item = try await items.findOneDocument(filter: item)
//            if(selected_item == nil){
//                print("Could not find the item you were searching for.")
//                return rv;
//            }
//            rv : [String] = (!selected_item["comments"]!!?).arrayValue!;
//
//        } catch {
//            print("Comment retrieval failed: \(error.localizedDescription)")
//        }
       return rv
    }

    func db_add_comment(comment: String) async {
//        do {
//            let app = App(id: APP_ID);
//            let user = try await app.login(credentials: Credentials.anonymous);
//            // fetch the DB
//            let client = app.currentUser!.mongoClient("mongodb-atlas")
//            let database = client.database(named: "freeFinder")
//            let items = database.collection(withName: "items")
//
//            let item: Document = [
//                "name": AnyBSON(stringLiteral: self.name),
//                "longitude": AnyBSON(stringLiteral: String(self.coordinate.longitude)),
//                "latitude": AnyBSON(stringLiteral: String(self.coordinate.latitude)),
//            ]
//
//            var curr_comments = (item["comments"]!!).arrayValue;
//
//            let commentId = try await items.updateOneDocument(
//                filter: item,
//                update: ["comments": curr_comments!.append(AnyBSON(comment))]
//            )
//
//        } catch {
//            print("Comment add failed: \(error.localizedDescription)")
//        }
    }

    func db_decrement_quantity(deviceLocation: CLLocationCoordinate2D) async -> Bool {
        return false
    }
    
    func db_get_quantity() -> Bool {
        return false
    }
                  
}
