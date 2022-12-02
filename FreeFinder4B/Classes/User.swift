import Foundation
import SwiftUI
import MapKit
import RealmSwift
import Realm

class User {
	var id : ObjectId
	var email : String
	
	
	/// Initializes a user object
	/// - Parameters:
	///   - email: a valid uchicago email
	///   - id: a MongoDB objectId
	init(
		email: String,
		id: ObjectId = ObjectId()
	) {
		self.email = email;
		self.id = id;
	}
	
	
	/// Fetches the collection of users from the database
	/// - Returns: a MongoDB Collection object if found, else, a nil value
	private func db_get_users_collection() async -> RLMMongoCollection? {
		var users: RLMMongoCollection? = nil;
		
		do {
			let app = App(id: APP_ID);
			_ = try await app.login(credentials: Credentials.anonymous);
			// fetch the DB
			let client = app.currentUser!.mongoClient("mongodb-atlas")
			let database = client.database(named: "freeFinder")
			users = database.collection(withName: "users")
		} catch {
			print("Could not fetch the items collection");
		}
		return users;
	}
	
	
	/// Adds the credentials of this user object to the database
	func db_add_user() async {
		if (self.id != ObjectId()) { return } // if has an ObjectId, it is already in the DB
		
		do {
			let users = await db_get_users_collection()!
			
			let potentialUser: Document = ["email" : AnyBSON(stringLiteral: self.email)];
			let user = try await users.findOneDocument(filter: potentialUser);
			
			if (user != nil) { // if the user is in the DB alread
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
	
	
	/// Creates an Item object, attaches this user's credentials to it, and adds it to the database
	/// - Parameters:
	///   - name: the name of the item
	///   - type: the type of the item
	///   - detail: details about the item
	///   - coordinate: the coordinates of where the item is located
	///   - quantity: how many of the item there are
	/// - Returns: the items with a database ObjectId if added successfully, else, a nil value
	func create_item(
		name: String,
		type: String,
		detail: String,
		coordinate: CLLocationCoordinate2D,
		quantity: Int
	) async -> Item? {
		if !((detail.count > 0) && (detail.count < 280) && (name.count < 100) && (name.count > 0)) { return nil };
		if (quantity <= 0) { return nil };
		
		let item = Item(
			name: name,
			type: type,
			detail: detail,
			coordinate: coordinate,
			creator_email: self.email,
			counter: quantity
		)
		let _ = await item.db_add_item();
		return item;
	}
	
	/// Adds a comment on a specific item
	/// - Parameters:
	///   - item: the items that the user wishes to comment on
	///   - comment: the comment the user wants to place on an item
	/// - Returns: a boolean of whether the comment was successfully place
	func comment(item: Item, comment: String) async -> Bool {
		if (comment.count <= 0 || comment.count > 200) { return false; }
		return await item.db_add_comment(comment: comment);
	}
}




