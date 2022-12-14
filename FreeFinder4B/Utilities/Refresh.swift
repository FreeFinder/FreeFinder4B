import Foundation
import CoreLocation
import SwiftUI
import RealmSwift
import UIKit

/// refreshes the main view controller
/// - Returns: a list of all the items in the mongodb backend
func refresh() async -> [Item] {
	let user = User(email: "mongodb@gmail.com");
	await user.db_add_user();
	let observer = await AppData(user: user);
	if let mainViewController = await UIApplication.shared.keyWindow?.rootViewController as? HomeViewController {
		await mainViewController.refresh()}
	return await observer.db_get_all_items()
}

/// Fetches an item from the database by its objectId
/// - Parameter id: an items unique database objectId
/// - Returns: an item if found, else, a nil value
func db_fetch_item(
	id: ObjectId
) async -> Item? {
	var res: Item? = nil;
	do {
		let app = App(id: APP_ID);
		let _ = try await app.login(credentials: Credentials.anonymous);
		// fetch the DB
		let client = app.currentUser!.mongoClient("mongodb-atlas")
		let database = client.database(named: "freeFinder")
		let items = database.collection(withName: "items");
		
		let potentialItem: Document = [ "_id": AnyBSON(id) ]
		let item = try await items.findOneDocument(filter: potentialItem);
		if (item == nil) {
			print("Item information is not currently registered in database.")
			return res;
		}
		
		let tempItem = parseDbItem(dbItem: item!)
		
		res = tempItem;
	} catch {
		print("Failed to fetch the item: \(error.localizedDescription)")
	}
	
	return res;
}


/// Parses the item data from the database and parses it into an Item object
/// - Parameter dbItem: item data from the database
/// - Returns: an Item object of the database item data
func parseDbItem(dbItem: Document) -> Item {
	let id: ObjectId = (dbItem["_id"]!!).objectIdValue!;
	let name = (dbItem["name"]!!).stringValue!;
	let type = (dbItem["type"]!!).stringValue!;
	let details = (dbItem["details"]!!).stringValue!;
	let counter = (dbItem["counter"]!!).asInt()!;
	
	let longitude = (dbItem["longitude"]!!).stringValue!;
	let latitude = (dbItem["latitude"]!!).stringValue!;
	let coordinates = CLLocationCoordinate2D(
		latitude: CLLocationDegrees(floatLiteral: Double(latitude)!),
		longitude: CLLocationDegrees(floatLiteral: Double(longitude)!)
	)
	
	let commentsRaw: [AnyBSON?] = (dbItem["comments"]!!).arrayValue!;
	let comments: [String] = commentsRaw.map{ ($0?.stringValue)! };
	
	let creator_email = (dbItem["creator_email"]!!).stringValue!;
	
	return Item(
		name: name,
		type: type,
		detail: details,
		coordinate: coordinates,
		creator_email: creator_email,
		comments: comments,
		counter: counter,
		id: id
	)
}
