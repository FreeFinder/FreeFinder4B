import XCTest
import Realm
import MapKit
import CoreLocation
import RealmSwift

@testable import FreeFinder4B

final class MongoDBTests: XCTestCase {
	
	func test_db_decrement_quantity() async throws {
		/*
		 CASES:
		 1. decrement is called on valid item
		 */
		
		let validItem = Item(
			name: "dbDecrementQuantityTestItem",
			type: "Food",
			detail: "This fud is good",
			coordinate: CLLocationCoordinate2DMake(0.00, 0.00),
			creator_email: "creatorTest",
			counter: 3
		)
		let id: ObjectId = await validItem.db_add_item();
		
		// [CASE] decrement is called on valid item
		let beforeDec = await db_fetch_item(id: id)
		XCTAssertEqual(beforeDec?.counter, 3);
		var _ = await validItem.decrement_quantity(
			deviceLocation: CLLocationCoordinate2DMake(0.00, 0.00)
		)
		let afterDec = await db_fetch_item(id: id)
		XCTAssertEqual(afterDec?.counter, 2);
		
		// CLEAN UP
		let _ = await validItem.db_delete_item()
	}
	
	func test_db_add_comment() async throws {
		/*
		 CASES:
		 1. comment is called on valid item
		 */
		
		let validItem = Item(
			name: "dbAddCommentTestItem",
			type: "Food",
			detail: "This fud is good",
			coordinate: CLLocationCoordinate2DMake(0.00, 0.00),
			creator_email: "creatorTest",
			counter: 3
		)
		let id: ObjectId = await validItem.db_add_item();
		
		// [CASE] comment is called on valid item
		var _ = await validItem.db_add_comment(comment: "what's up");
		var fetched = await db_fetch_item(id: id)
		XCTAssertEqual(validItem.comments.count, 1)
		XCTAssertEqual(fetched?.comments[0], "what's up");
		
		// CLEAN UP
		let _ = await validItem.db_delete_item()
	}
	
	func test_db_fetch_item() async throws {
		/*
		 CASES:
		 1. item is in db
		 2. item is not in db
		 */
		
		let item = Item(
			name: "dbFetchItemTestItem",
			type: "Food",
			detail: "This fud is good",
			coordinate: CLLocationCoordinate2DMake(0.00, 0.00),
			creator_email: "creatorTest",
			counter: 3
		)
		let id = await item.db_add_item();
		
		// [CASE] item is in db
		var fetched = await db_fetch_item(id: id);
		XCTAssertEqual(fetched?.counter, item.counter);
		
		// REMOVE ITEM FROM DB
		 let _ = await item.db_delete_item()
		
		// [CASE] item is not in db
		fetched = await db_fetch_item(id: id);
		XCTAssertNil(fetched);
	}
	
	
}
