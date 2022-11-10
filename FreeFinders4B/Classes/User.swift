//
//  User.swift
//  FreeFinders3B
//
//  Created by steven arellano on 11/8/22.
//

import Foundation
import SwiftUI
//import GoogleSignIn
import MapKit
import RealmSwift

class User {
    var id : ObjectId
    var email : String

    init(email: String, id: ObjectId = ObjectId()) async {
        self.email = email;
        self.id = id;
        
        if (id == ObjectId()) {
            await db_add_user(email: email);
        }
        
    }
    
    func db_add_user(email: String) async {
        do {
            let app = App(id: APP_ID);
            let mongo_user = try await app.login(credentials: Credentials.anonymous);
            // fetch the DB
            let client = app.currentUser!.mongoClient("mongodb-atlas")
            let database = client.database(named: "freeFinder")
            let users = database.collection(withName: "users")
            
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
    
    func create_item(name: String, type: String, detail: String, coordinate: CLLocationCoordinate2D,quantity: Int) async -> Item?{
        // check field validity
        if ((detail.count > 0) && (detail.count < 280) && (name.count < 100) && (name.count > 0)) {
            let i = await Item(name: name,type: type,detail: detail,coordinate: coordinate,creator_email: self.email)
            await i.db_add_item(name: name,type: type,coordinates: coordinate, details: detail,creator_email: self.email)
            return i
        }
        return nil
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




