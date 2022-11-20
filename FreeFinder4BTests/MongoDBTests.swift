import XCTest
import Realm
import MapKit
import CoreLocation

@testable import FreeFinder4B

final class MongoDBTests: XCTestCase {
	
	func test_db_decrement_quantity() async throws {
		/*
		 CASES:
		 1. decrement is called on valid item
		 */
		
		let validItem = Item(
			name: "validItemTest1",
			type: "Food",
			detail: "This fud is good",
			coordinate: CLLocationCoordinate2DMake(0.00, 0.00),
			creator_email: "creatorTest",
			counter: 3
		)
		let _ = await validItem.db_add_item();
		
		// [CASE] decrement is called on valid item
		let beforeDec = await db_fetch_item(
			name: validItem.name,
			coordinates: validItem.coordinate
		)
		XCTAssertEqual(beforeDec?.counter, 3);
		var _ = await validItem.decrement_quantity(
			deviceLocation: CLLocationCoordinate2DMake(0.00, 0.00)
		)
		let afterDec = await db_fetch_item(
			name: validItem.name,
			coordinates: validItem.coordinate
		)
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
			name: "validItemTest1",
			type: "Food",
			detail: "This fud is good",
			coordinate: CLLocationCoordinate2DMake(0.00, 0.00),
			creator_email: "creatorTest",
			counter: 3
		)
		let _ = await validItem.db_add_item();
		
		// [CASE] comment is called on valid item
		var _ = await validItem.db_add_comment(comment: "what's up");
		var fetched = await db_fetch_item(
			name: validItem.name,
			coordinates: validItem.coordinate
		)
		XCTAssertEqual(validItem.comments.count, 1)
		XCTAssertEqual(fetched?.comments[0], "what's up");
		
		// CLEAN UP
		let _ = await validItem.db_delete_item()
	}
	
	
}
