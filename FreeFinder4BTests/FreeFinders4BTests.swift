import XCTest
import MapKit
import RealmSwift

@testable import FreeFinder4B

final class FreeFinders4BTests: XCTestCase {
	func test_validEmail() throws {
		/*
		 CASES:
		 1. email is valid
		 2. email is invalid because does not end with "@uchicago.edu"
		 3. email in invalid because it does not contain a prefix to "@uchicago.edu"
		 */
		
		// [CASE] valid email
		let goodEmail = "steven@uchicago.edu";
		XCTAssertTrue(validEmail(email: goodEmail))
		
		// [CASE] doesn't end with "@uchicago.edu
		let invalidEmail1 = "";
		XCTAssertFalse(validEmail(email: invalidEmail1))
		
		// [CASE] no valid prefix
		let invalidEmail2 = "@uchicago.edu";
		XCTAssertFalse(validEmail(email: invalidEmail2))
	}
	
	func test_db_fetch_user() async throws {
		/*
		 CASES:
		 1. email in db
		 2. email not in db
		 */
		
		let goodEmail = "testUser@uchicago.edu"
		let testUser = User(email: goodEmail);
		await testUser.db_add_user();
		
		// [CASE] email in db
		let user = await db_fetch_user(email: goodEmail);
		XCTAssertEqual(user?.email, goodEmail);
		
		// [CASE] email not in db
		let nilUser = await db_fetch_user(email: "not in db");
		XCTAssertNil(nilUser);
	}
	
	func test_create_item() async throws {
		// get initial state of the database
		let test_user = User(email: "mongodb@gmail.com");
		
		let v_title = "title"
		let v_desc = "valid description"
		
		// valid item
		let v_item = await test_user.create_item(
			name: "test_item",
			type: "Food",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		let res = (await v_item!.db_item_exists())
		XCTAssertNotNil(res)
		
		//invalid title
		//too long
		let i_title1 = " HJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
		let res2 = await test_user.create_item(
			name: i_title1,
			type: "Food",
			detail: v_desc,
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1)
		XCTAssertNil(res2)
		
		//too short
		let i_title2 = ""
		let res3 = await test_user.create_item(
			name: i_title2,
			type: "Food",
			detail: v_desc,
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		XCTAssertNil(res3)
		
		//invalid quantity -- 0
		let res6 = await test_user.create_item(
			name: v_title,
			type: "Food",
			detail: v_desc,
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 0
		)
		XCTAssertNil(res6)
		
		
		//invalid description -- empty
		let i_description1 = ""
		let res4 = await test_user.create_item(
			name: v_title,
			type: "Food",
			detail: i_description1,
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		XCTAssertNil(res4)
		
		//invalid description -- too long
		let i_description2 = "HJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlkHJIiimknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkasdfkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlkHJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk"
		let res5 = await test_user.create_item(
			name: v_title,
			type: "Food",
			detail: i_description2,
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 1
		)
		XCTAssertNil(res5)
		
	}
	
	func test_comment() async throws {
		// set up users and items for testing
		let testUser = User(email: "mongodb@gmail.com");
		let testItem = Item(
			name: "going_in_db",
			type: "Other",
			detail: "this item will be deleted",
			coordinate: CLLocationCoordinate2DMake(0.00, 0.00),
			creator_email: "mongodb@gmail.com"
		)
		let _ = await testItem.db_add_item();
		
		// false: empty comment with no previous comments
		var res = await testUser.comment(item: testItem, comment: "");
		XCTAssertFalse(res)

		//true: valid comment and item
		res = await testUser.comment(item: testItem, comment: "first comment")
		XCTAssertTrue(res)
		
		let fetchedItem = await db_fetch_item(
			name: testItem.name,
			coordinates: testItem.coordinate
		);
		XCTAssertEqual(fetchedItem?.comments[0], "first comment");
		
		let invalidItem = Item(
			name: "not_in_the_database",
			type: "Other",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			creator_email: "mongodb@gmail.com"
		)
		
		// false: valid comment but not valid item
		res = await testUser.comment(item: invalidItem, comment: "valid comment, but bad item");
		XCTAssertFalse(res)
		
		// CLEAN ITEM FROM DB
		let _ = await testItem.db_delete_item();
	}
	
	func test_delete_item() async throws {
		// creates valid item in the db
		// checks the item is there
		// deletes item from db
		// checks item not in db
		
		//create item and user
		let test_user3 =  User(email: "mongodb@gmail.com");
		
		
		let v_item = await test_user3.create_item(
			name: "t_item",
			type: "Food",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			quantity: 9
		)
		
		//checks in db
		let res = await (v_item!.db_item_exists())
		XCTAssertTrue(res)
		
		//deletes item
		await v_item!.delete_Item()
		
		//checks not in db
		let res2 = await (v_item!.db_item_exists())
		XCTAssertFalse(res2)
		
	}
	
	func test_decrement_quantity() async throws { // EXPECT TO FAIL, AS NOT FULLY IMPL
		/*
		 CASES:
		 1. item does not exist
		 2. item quantity == 1
		 3. item quantity > 1
		 4. device not in range to delete
		 */
		
		
		// CREATE NONEXISTENT ITEM TO TEST ON
		let nonexistentItem = Item(
			name: "not_in_the_database",
			type: "test_type",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			creator_email: "mongodb@gmail.com"
		)
		let validCoordinates = CLLocationCoordinate2DMake(90.000, 135.000);
		// [CASE] item does not exist
		var didDecrement = await nonexistentItem.decrement_quantity(deviceLocation: validCoordinates);
		XCTAssertFalse(didDecrement)
		
		
		// ADD VALID ITEM TO DB
		let validItem: Item = Item(
			name: "t_item",
			type: "test_type",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			creator_email: "mongodb@gmail.com",
			counter: 2
		);
		let _ = await validItem.db_add_item();
		
		// [CASE] item quantity > 1
		didDecrement = await validItem.decrement_quantity(deviceLocation: validCoordinates);
		XCTAssertTrue(didDecrement)
		
		// [CASE] item quantity == 1
		didDecrement = await validItem.decrement_quantity(deviceLocation: validCoordinates);
		XCTAssertTrue(didDecrement) // will delete item from db
		let itemInDB = await validItem.db_item_exists()
		XCTAssertFalse(itemInDB)
		
		
		// ADD ITEM WITH QUANTITY 1 TO DB
		let validItemQ1: Item = Item(
			name: "test_item",
			type: "test_type",
			detail: "test_detail",
			coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
			creator_email: "mongodb@gmail.com",
			counter: 1
		);
		let _ = await validItemQ1.db_add_item();
		let invalidCoordinates = CLLocationCoordinate2DMake(0.000, 0.000);
		
		// [CASE] device not in range to delete
		didDecrement = await validItemQ1.decrement_quantity(deviceLocation: invalidCoordinates);
		XCTAssertFalse(didDecrement);
	}
	
	func test_distance_filter() async throws { // EXPECT TO FAIL, AS NOT FULLY IMPL
											   //CASES: 4 Items in a list, each with different coordinates.
											   //They will be filtered against the UChicago campus, which is where
											   //anyone testing this will likely be (for now)
											   //2 items will be on campus, one will be on the west coast (~2000 mi), the other will be
											   //on the other side of the world in Australia, ~9000 mi away.
		
		let uchicago_center = CLLocationCoordinate2D(latitude: 41.7886, longitude: -87.5987)
		let ratner = CLLocationCoordinate2D(latitude: 41.7942, longitude: -87.6017)
		let USC = CLLocationCoordinate2D(latitude: 34.0224, longitude: -118.2851)
		let SydneyOperaHouse = CLLocationCoordinate2D(latitude: -33.8568, longitude: 151.2153)
		
		let test_user = User(email: "mongodb@gmail.com")
		let app = await AppData(user: test_user)
		
		let item1 = Item(name: "test1", type: "food", detail: "test1", coordinate: uchicago_center, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		let item2 = Item(name: "test2", type: "food", detail: "test2", coordinate: ratner, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		let item3 = Item(name: "test3", type: "food", detail: "test3", coordinate: USC, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		let item4 = Item(name: "test4", type: "food", detail: "test4", coordinate: SydneyOperaHouse, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		
		app.items = [item1, item2, item3, item4]
		app.mapItems = app.items
		
		app.filterMapItems(distance: -100)//impossible, but should return empty list
		XCTAssertEqual(app.mapItems.count, 0)
		
		app.filterMapItems(distance: 50) //assuming miles, may change
		XCTAssertEqual(app.mapItems.count, 2)
		XCTAssertEqual(app.mapItems[0].name, "test1")
		XCTAssertEqual(app.mapItems[1].name, "test2")
		
		app.filterMapItems(distance: 3000) //big enough for the US, does not reach AU
		XCTAssertEqual(app.mapItems.count, 3)
		XCTAssertEqual(app.mapItems[0].name, "test1")
		XCTAssertEqual(app.mapItems[1].name, "test2")
		XCTAssertEqual(app.mapItems[2].name, "test3")
	}
	
	func test_distance_sort() async throws { // EXPECT TO FAIL, AS NOT FULLY IMPL
											 //sorts the list of map items by distance, ascending. The order from the User's location
											 //assuming they are on/near campus should be item1 item2 item3
		
		let uchicago_center = CLLocationCoordinate2D(latitude: 41.7886, longitude: -87.5987)
		let USC = CLLocationCoordinate2D(latitude: 34.0224, longitude: -118.2851)
		let SydneyOperaHouse = CLLocationCoordinate2D(latitude: -33.8568, longitude: 151.2153)
		
		let test_user = User(email: "mongodb@gmail.com")
		let app = await AppData(user: test_user)
		
		let item1 = Item(name: "test1", type: "food", detail: "test1", coordinate: uchicago_center, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		let item2 = Item(name: "test2", type: "food", detail: "test2", coordinate: USC, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		let item3 = Item(name: "test3", type: "food", detail: "test3", coordinate: SydneyOperaHouse, creator_email: "mongodb@gmail.com", comments: [], counter: 10, id: ObjectId())
		
		//sort random order test
		app.items = [item2, item3, item1]
		app.mapItems = app.items
		
		app.sortMapItemsByDist()
		XCTAssertEqual(app.mapItems[0].name, "test1")
		XCTAssertEqual(app.mapItems[1].name, "test2")
		XCTAssertEqual(app.mapItems[2].name, "test3")
		
		//sort reverse order test
		app.items = [item3, item2, item1]
		app.mapItems = app.items
		
		app.sortMapItemsByDist()
		XCTAssertEqual(app.mapItems[0].name, "test1")
		XCTAssertEqual(app.mapItems[1].name, "test2")
		XCTAssertEqual(app.mapItems[2].name, "test3")
		
		//sort correct order test
		app.items = [item1, item2, item3]
		app.mapItems = app.items
		
		app.sortMapItemsByDist()
		XCTAssertEqual(app.mapItems[0].name, "test1")
		XCTAssertEqual(app.mapItems[1].name, "test2")
		XCTAssertEqual(app.mapItems[2].name, "test3")
		
		//sort 1 item list test
		app.items = [item1]
		app.mapItems = app.items
		
		app.sortMapItemsByDist()
		XCTAssertEqual(app.mapItems[0].name, "test1")
		
		//sort empty list test
		app.items = []
		app.mapItems = app.items
		
		app.sortMapItemsByDist()
		XCTAssertEqual(app.mapItems.count, 0)
	}
}
