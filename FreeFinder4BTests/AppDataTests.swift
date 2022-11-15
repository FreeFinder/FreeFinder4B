import XCTest
import MapKit
import RealmSwift

@testable import FreeFinder4B

final class AppDataTests: XCTestCase {
	func test_filterMapItems() async throws {
		// filter by type
		
		// filtering changes AppData.mapitems
		// Note the ["Food", "Clothing", "Furniture", "Other"] are the only options for item types when creating an item in the ui, so invalid type is not a concern
		
		// no items at all
		let test_user = User(email: "jlabuda@uchicago.edu")
		let test_app = await AppData(user: test_user)
		test_app.items = []
		test_app.mapItems = []
		
		// now have blank slate to test filtering on empty list
		test_app.filterMapItems(tag: "Food")
		XCTAssertTrue(test_app.mapItems.isEmpty)
		
		// no items of chosen input
		let food_item1 = await test_user.create_item(
			name: "test_item",
			type: "Food",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		let food_item2 = await test_user.create_item(
			name: "test_item1",
			type: "Food",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		test_app.items = [food_item1!,food_item2!]
		test_app.filterMapItems(tag: "Clothing")
		XCTAssertTrue(test_app.mapItems.isEmpty)

		// test correct filtering of each category
		let cloth_item1 = await test_user.create_item(
			name: "clothing1",
			type: "Clothing",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		let cloth_item2 = await test_user.create_item(
			name: "clothing2",
			type: "Clothing",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		
		let furn_item1 = await test_user.create_item(
			name: "furn1",
			type: "Furniture",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		let furn_item2 = await test_user.create_item(
			name: "furn2",
			type: "Furniture",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		
		let other_item1 = await test_user.create_item(
			name: "other1",
			type: "Other",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		let other_item2 = await test_user.create_item(
			name: "other2",
			type: "Other",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		test_app.items = [food_item1!,food_item2!, cloth_item1!, cloth_item2!, furn_item1!, furn_item2!, other_item1!, other_item2!]
		
		// food
		test_app.filterMapItems(tag: "Food")
		XCTAssertTrue(test_app.mapItems == [food_item1!, food_item2!])
		
		// clothing
		test_app.filterMapItems(tag: "Clothing")
		XCTAssertTrue(test_app.mapItems == [cloth_item1!, cloth_item2!])
		
		// furniture
		test_app.filterMapItems(tag: "Furniture")
		XCTAssertTrue(test_app.mapItems == [furn_item1!, furn_item2!])
		
		// other
		test_app.filterMapItems(tag: "Other")
		XCTAssertTrue(test_app.mapItems == [other_item1!, other_item2!])
		
	}

}
