//
//  AppData.swift
//  FreeFinders3B
//
//  Created by steven arellano on 11/8/22.
//

import Foundation
import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

class AppData {
    var items: [Item] = [];
    var user: User;
    
    init(user: User) async{
        self.user = user
        
        await db_get_all_items();
    }
    
    func refresh() async -> [Item] {
        return await db_get_all_items();
    }
    
    func db_get_all_items() async -> [Item] {
        var res: [Item] = [];
        do {
            let app = App(id: APP_ID);
            let user = try await app.login(credentials: Credentials.anonymous);
            
            // fetch the DB
            let client = app.currentUser!.mongoClient("mongodb-atlas")
            let database = client.database(named: "freeFinder")
            let items = database.collection(withName: "items")
            
            let db_items = try await items.find(filter: [:]);
            var temp_item_array: [Item] = [];
            for db_item in db_items {
                let id: ObjectId = (db_item["_id"]!!).objectIdValue!;
                let name = (db_item["name"]!!).stringValue!;
                let type = (db_item["type"]!!).stringValue!;
                let details = (db_item["details"]!!).stringValue!;
                
                let longitude = (db_item["longitude"]!!).stringValue!;
                let latitude = (db_item["latitude"]!!).stringValue!;
                let coordinates = CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(floatLiteral: Double(latitude)!),
                    longitude: CLLocationDegrees(floatLiteral: Double(longitude)!)
                )
                
                let creator_email = (db_item["creator_email"]!!).stringValue!;
                
                
                let fetchedItem = await Item(
                    name: name,
                    type: type,
                    detail: details,
                    coordinate: coordinates,
                    creator_email: creator_email,
                    id: id
                )
                temp_item_array.append(fetchedItem);
            }
            self.items = temp_item_array;
            res = temp_item_array;
        } catch {
            print("Failed to fetch all the items: \(error.localizedDescription)")
        }
        
        return res;
    }
    
    func db_fetch_user(email: String) async -> User? {
        var res: User? = nil;
        do {
            let app = App(id: APP_ID);
            let mongo_user = try await app.login(credentials: Credentials.anonymous);
            // fetch the DB
            let client = app.currentUser!.mongoClient("mongodb-atlas")
            let database = client.database(named: "freeFinder")
            let users = database.collection(withName: "users")
            
            let potentialUser: Document = ["email" : AnyBSON(stringLiteral: email)];
            let user = try await users.findOneDocument(filter: potentialUser);
            if (user == nil) {
                print("User email is not currently registered in database.")
                return res;
            }
            print("Account in the database: \(String(describing: user))")
            let id = ((user?["_id"]!!)?.objectIdValue!)!;
            let temp_user = await User(email: email, id: id);
            
            self.user = temp_user;
        } catch {
            print("Failed to fetch the user: \(error.localizedDescription)")
        }
        
        return res;
    }
}
