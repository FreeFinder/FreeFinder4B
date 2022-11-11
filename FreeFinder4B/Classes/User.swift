//
//  User.swift
//  FreeFinders3B
//
//  Created by steven arellano on 11/8/22.
//

import Foundation
import SwiftUI
import MapKit
import RealmSwift
import Realm

class User {
    var id : ObjectId
    var email : String

    init(
        email: String,
        id: ObjectId = ObjectId()
    ) {
        self.email = email;
        self.id = id;
    }
    
    private func db_get_users_collection() async -> RLMMongoCollection? {
        var users: RLMMongoCollection? = nil;
        
        do {
            let app = App(id: APP_ID);
            let user = try await app.login(credentials: Credentials.anonymous);
            // fetch the DB
            let client = app.currentUser!.mongoClient("mongodb-atlas")
            let database = client.database(named: "freeFinder")
            users = database.collection(withName: "users")
        } catch {
            print("Could not fetch the items collection");
        }
        return users;
    }
    
    func db_add_user(email: String) async {
        if (self.id != ObjectId()) { return } // if has an ObjectId, it is already in the DB
        
        do {
            let users = await db_get_users_collection()!
            
            let potentialUser: Document = ["email" : AnyBSON(stringLiteral: email)];
            let user = try await users.findOneDocument(filter: potentialUser);
            // if the user is in the DB already
            if (user != nil) {
                print("Account with this email found in the database: \(String(describing: user))");
                self.id = ((user?["_id"]!!)?.objectIdValue!)!;
                return;
            }
            // if the user is not currently in the db
            print("Email is not currently registered in the database, creating an account now.");
            let newUserId = try await users.insertOne(potentialUser);
            print("New Account created under user id: \(newUserId)");
            self.id = newUserId.objectIdValue!;
            
        } catch {
            print("Failed to add/retrieve this user from the database")
        }
    }
    
    func create_item(
        name: String,
        type: String,
        detail: String,
        coordinate: CLLocationCoordinate2D,
        quantity: Int
    ) async -> Item? {
        // check field validity
        if !((detail.count > 0) && (detail.count < 280) && (name.count < 100) && (name.count > 0)) { return nil }; // DOUBLE CHECK THAT THIS IS RIGHT CONDITION
        if (quantity <= 0) { return nil };
        
        
        let item = Item(
                name: name,
                type: type,
                detail: detail,
                coordinate: coordinate,
                creator_email: self.email
        )
        let _ = await item.db_add_item();
        return item;
    }
    
    func comment(i: Item, comment: String) async {
//        return await i.add_Comment(comment: comment)
    }
    func sign_out() -> Bool{
//        GIDSignIn.sharedInstance?.signOut()
//        return (GIDSignIn.sharedInstance() == nil)
        return false
    }
    
}




