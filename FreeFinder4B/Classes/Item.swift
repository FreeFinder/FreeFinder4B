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
	let creator_email: String
	var counter: Int
	var id: ObjectId
	
	var title: String? { return name }
	var subtitle: String? { return type }
	
	/// Ititializes an Item object
	/// - Parameters:
	///   - name: the name of the item
	///   - type: the type of the item
	///   - detail: details about the item
	///   - coordinate: the coordinates of where the item is located
	///   - creator_email: the email address of the user who uploaded the item
	///   - comments: an array of comments on this item
	///   - counter: the quantity of the item
	///   - id: the unique database id of the item
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
	
	
	/// Fetches the collection of items from the database
	/// - Returns: a MongoDB Collection object if found, else, a nil value
	private func db_get_items_collection() async -> RLMMongoCollection? {
		var items: RLMMongoCollection? = nil;
		
		do {
			let app = App(id: APP_ID);
			let _ = try await app.login(credentials: Credentials.anonymous);
			// fetch the DB
			let client = app.currentUser!.mongoClient("mongodb-atlas")
			let database = client.database(named: "freeFinder")
			items = database.collection(withName: "items")
		} catch {
			print("Could not fetch the items collection");
		}
		return items;
	}
	
	/// Adds this item obejct's information to the database
	/// - Returns: the unique database objectId of the item
	func db_add_item() async -> ObjectId {
		if (self.id != ObjectId()) { return self.id }; // check if already in db
		var res: ObjectId = ObjectId();
		do {
			let items: RLMMongoCollection = await db_get_items_collection()!
			
			let item: Document = [
				"name": AnyBSON(stringLiteral: self.name),
				"type": AnyBSON(stringLiteral: self.type),
				"latitude": AnyBSON(stringLiteral: String(self.coordinate.latitude)),
				"longitude": AnyBSON(stringLiteral: String(self.coordinate.longitude)),
				"details": AnyBSON(stringLiteral: self.detail),
				"creator_email": AnyBSON(stringLiteral: self.creator_email),
				"comments": [],
				"counter":  AnyBSON(integerLiteral: self.counter)
			]
			
			let objectId: AnyBSON = try await items.insertOne(item)
			self.id = objectId.objectIdValue!;
			if (self.id.stringValue != "") { res = self.id; }
		} catch {
			print("Login and item insertion failed: \(error.localizedDescription)")
		}
		
		return res;
	}
	
	/// Checks if this item currently exists in the database
	/// - Returns: A boolean of whether its found in the database
	func db_item_exists() async -> Bool {
		var res = false;
		if (self.id == ObjectId()) { return res; }
		print("running")
		do {
			let items: RLMMongoCollection = await db_get_items_collection()!
			
			let potentialItem: Document = ["_id": AnyBSON(self.id)]
			
			let document = try await items.findOneDocument(filter: potentialItem);
			
			if (document == nil) {
				print("Could not find this document in the database!");
			} else {
				res = true;
			}
		} catch {
			print("Checking whether an item existed failed, inconclusive: \(error.localizedDescription)")
		}
		
		return res;
	}
	
	/// Deletes this item from the database
	/// - Returns: a boolean on whether or not the object was successfully deleted from the database
	func db_delete_item() async -> Bool {
		var res = false;
		if (self.id == ObjectId()) { return res; } // the item is already not in db
		
		do {
			let items: RLMMongoCollection = await db_get_items_collection()!
			
			let itemQuery: Document = ["_id": AnyBSON(self.id)]
			
			let _ = try await items.deleteOneDocument(filter: itemQuery)
			res = true;
		} catch {
			print("Login and item deletion failed: \(error.localizedDescription)")
		}
		
		return res;
	}
	
	/// Deletes this item from the app & database
	/// - Parameter deviceLocation: the current location of the device
	/// - Returns: a boolean on whether or not the object was successfully deleted from the app & db
	func delete_Item(deviceLocation: CLLocationCoordinate2D) async -> Bool{
		if (itemTooFar(location: deviceLocation)) {
			return false // deletes if item in database
		}
		else if (await self.db_item_exists()) {
			let _ = await db_delete_item();
			_ = await refresh();
			return true
		}
		return true
	}
	
	/// Returns whether this item is too far to decrement
	/// - Parameter location: coordinates of the current device
	/// - Returns: a boolean on whether this item is too far to decrement
	private func itemTooFar(location: CLLocationCoordinate2D) -> Bool {
		let dist = sqrt((
			pow((self.coordinate.latitude - location.latitude), 2) +
			pow((self.coordinate.longitude) - location.longitude, 2)
		))
		return (dist > DECREMENT_DISTANCE);
	}
	
	/// Decrements the quantity of this item in the database
	/// - Returns: a boolean on whether this item's quantity was successfully decremented
	func db_decrement_quantity(	) async -> Bool {
		var res: Bool = false; // whether or not the item is deleted
		if (self.id == ObjectId()) { return res; }
		
		do {
			let items: RLMMongoCollection = await db_get_items_collection()!;
			
			let itemQuery: Document = ["_id": AnyBSON(self.id)];
			let itemUpdate: Document = [
				"$set": [
					"counter": AnyBSON(integerLiteral: self.counter - 1)
				]
			];
			
			let updateResult = try await items.updateOneDocument(
				filter: itemQuery,
				update: itemUpdate
			)
			if (updateResult.matchedCount != 1
				&& updateResult.modifiedCount != 1) {
				return res;
				
			}
			res = true;
		} catch {
			print("Login and counter decrement failed: \(error.localizedDescription)")
		}
		
		return res;
	}
	
	
	/// Adds a comment to this item in the database
	/// - Parameter comment: the comment to add to this item
	/// - Returns: a boolean on whether the comment was successfully added to this db item
	func db_add_comment(comment: String) async -> Bool {
		var res: Bool = false;
		
		if (self.id == ObjectId()) { return res; }
		let prevLength = self.comments.count;
		
		do {
			let items: RLMMongoCollection = await db_get_items_collection()!;
			
			let itemQuery: Document = ["_id": AnyBSON(self.id)];
			
			let itemUpdate: Document = ["$push": [
				"comments": AnyBSON(stringLiteral: comment)
			]];
			
			let updateResult = try await items.updateOneDocument(
				filter: itemQuery,
				update: itemUpdate
			)
			if (updateResult.matchedCount != 1
				&& updateResult.modifiedCount != 1) {
				return res;
			}
			self.comments.append(comment); // add the comment locally to reflect db changes
			res = true;
		} catch {
			if (prevLength < self.comments.count) { self.comments.removeLast() }
			print("Login and add comment failed: \(error.localizedDescription)")
		}
		return res;
	}
	
	/// Decrements the quantity of this item on the app and in the db
	/// - Parameter deviceLocation: the current location of this device
	/// - Returns: a boolean of whether or not the item's quantity was successfully decremented
	func decrement_quantity(deviceLocation: CLLocationCoordinate2D) async -> Bool {
		if (itemTooFar(location: deviceLocation)) { return false }; // too far away to interact
		if (!(await self.db_item_exists())){ return false }
		if (self.counter == 1){
			let _ = await self.delete_Item(deviceLocation: deviceLocation)
			return true
		}
		else{
			if (await self.db_decrement_quantity()) {
				self.counter = self.counter - 1
				return true
			}
			else{
				return false
			}
		}
	}
}
