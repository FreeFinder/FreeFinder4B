import XCTest
import MapKit
import RealmSwift

@testable import FreeFinder4B

final class FreeFinders4BTests: XCTestCase {
	// [TODO] do we still need this?
	//    func testSignIn() async throws{
	//        //will create two users, one with valid email one without.
	//        let goodUser = await sign_in(email: "cbgravitt@uchicago.edu")
	//        XCTAssertEqual(goodUser!.email, "cbgravitt@uchicago.edu")
	//
	//        //invalid users can't sign in, return null
	//        let badUser = await sign_in(email: "cbgravitt@google.com")
	//        XCTAssertNil(badUser)
	//    }
    
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

	func test_userSignedIn() throws {
		/*
		 CASES:
		 1. user credentials are not on local device
		 2. user credentials are on local device
		 */
		
		// fetch the current state of the device (should be empty)
		let emptyDevice = Device();
		// [CASE] user credentials are not on local device
		XCTAssertFalse(emptyDevice.userSignedIn());
		
		// sign in a user to the device
		emptyDevice.saveLocalUser(
			email: "steven@uchicago.edu",
			id: "636e61f1c4581ef3a7186f5f"
		);
		
		let signedInDevice = Device();
		// [CASE] user credentials are on local device
		XCTAssertTrue(emptyDevice.userSignedIn());
	}
	
	
	func test_saveLocalUser() throws  {
		/*
		 CASES:
		 1. local credential state goes from empty to something
		 2. local credential state goes from something to something else
		 */
		
		// fetch the current state of the device (should be empty)
		let device = Device();
		XCTAssertEqual(nil, device.email)
		
		// sign in a user to the device
		device.saveLocalUser(
			email: "steven@uchicago.edu",
			id: "636e61f1c4581ef3a7186f5f"
		);
		// [CASE] local credential state goes from empty to something
		XCTAssertEqual("steven@uchicago.edu", device.email)
		
		// save different user credentials to the device
		device.saveLocalUser(
			email: "mongo@uchicago.edu",
			id: "636e61f1c4581ef3a7186f5f"
		);
		// [CASE] local credential state goes from something to something else
		XCTAssertEqual("mongo@uchicago.edu", device.email)
	}
    
	func test_removeLocalUser() throws {
		/*
		 CASES:
		 1. local credentials get removed from the device
		 */
		
		// sign in a user to the device
		let device = Device();
		device.saveLocalUser(
			email: "steven@uchicago.edu",
			id: "636e61f1c4581ef3a7186f5f"
		);
		XCTAssertEqual("steven@uchicago.edu", device.email)
		
		device.removeLocalUser();
		// [CASE] local credential state goes from something to something else
		XCTAssertEqual(nil, device.email);
	}
	
    func test_filterMapItems() async throws{
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
        
        
        
        
        
        // filter by distance
        
        
    }
    
    func test_create_item() async throws {
        // get initial state of the database
        let test_user = User(email: "mongodb@gmail.com");
        
        let v_title = "title"
        let v_desc = "valid description"
        
        // valid item
        let v_item = await test_user.create_item(
            name: "test_item",
            type: "test_type",
            detail: "test_detail",
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            quantity: 1
        )
        let res = (await v_item!.db_item_exists())
        XCTAssertTrue(res)
        
        
        
        //invalid title
        let i_title1 = " HJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
        let res2 = await test_user.create_item(
            name: i_title1,
            type: "test_type",
            detail: v_desc,
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            quantity: 1)
        XCTAssertNil(res2)
        let i_title2 = ""
        
        let res3 = await test_user.create_item(
            name: i_title2,
            type: "test_type",
            detail: v_desc,
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            quantity: 1
        )
        XCTAssertNil(res3)
        
        //invalid quantity
        //let i_quantity1 = 999
        //XCTAssertNil(test_user.create_item(name: v_title, type: "test_type", detail: v_desc, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: i_quantity1))
        
        //let i_quantity2 = 0
        //XCTAssertNil(test_user.create_item(name: v_title, type: "test_type", detail: v_desc, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: i_quantity2))
        
        
        //invalid description -- empty
        let i_description1 = ""
        let res4 = await test_user.create_item(
            name: v_title,
            type: "test_type",
            detail: i_description1,
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            quantity: 1
        )
        XCTAssertNil(res4)
        
        //invalid description -- too long
        let i_description2 = "HJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlkHJIiimknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkasdfkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlkHJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk"
        let res5 = await test_user.create_item(
            name: v_title,
            type: "test_type",
            detail: i_description2,
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            quantity: 1
        )
        XCTAssertNil(res5)
        
    }
    
    func test_comment() async throws{
        //        //test cases are the same but the syntax and coding has changed due to changing our database from firebase to MongoDB and separating the use cases functions and database calls
        //
        //        //set up users and items for testing
        //        let test_user2 = await User(email: "mongodb@gmail.com");
        //        let observer = await AppData(user: test_user2);
        //
        //        let v_item = await test_user2.create_item(name: "test_item", type: "test_type", detail: "test_detail",  coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)
        //
        //        let items = await observer.db_get_all_items()
        //
        //
        //
        //        let test_item = items[0]
        //        let bad_item = await Item(name: "not_in_the_database", type: "test_type", detail: "test_detail",  coordinate: CLLocationCoordinate2DMake(90.000, 135.000), creator_email: "mongodb@gmail.com")
        //
        //        // get initial state of the comments for test_item
        //        let initial_comments = test_item.db_get_comments()
        //
        //        // false: empty comment with no previous comments
        //        let res = await test_user2.comment(i: test_item, comment: "")
        //        XCTAssertFalse(res)
        //
        //        // false: valid comment but not valid item
        //        let res2 = await test_user2.comment(i: bad_item, comment: "fail")
        //        XCTAssertFalse(res2)
        //
        //        //true: valid comment and item
        //        let res3 = await test_user2.comment(i: test_item, comment: "first comment")
        //        XCTAssertTrue(res3)
        //        var new_comments = test_item.db_get_comments()
        //        let i = initial_comments.count
        //        XCTAssertEqual("first comment", new_comments[i-1])
        //
        //        //true: valid comment and item 2, make sure both comments are in database
        //        let res4 = await test_user2.comment(i: test_item, comment: "second comment")
        //        XCTAssertTrue(res4)
        //        new_comments = test_item.db_get_comments()
        //        XCTAssertEqual("second comment", new_comments[i])
        //
        //        //false: invalid comment, previous comments
        //        let res5 = await test_user2.comment(i: test_item, comment: "")
        //        XCTAssertFalse(res5)
        
    }
    
    func test_delete_item() async throws {
        // creates valid item in the db
        // checks the item is there
        // deletes item from db
        // checks item not in db
        
        //create item and user
        let test_user3 =  User(email: "mongodb@gmail.com");
        
        
        let v_item = await test_user3.create_item(
            name: "test_item",
            type: "test_type",
            detail: "test_detail",
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            quantity: 9
        )
        
        //checks in db
        let res = await (v_item!.db_item_exists())
        XCTAssertTrue(res)
        
        //deletes item
        await v_item?.delete_Item()
        
        //checks not in db
        let res2 = await (v_item!.db_item_exists())
        XCTAssertTrue(res2)
        
    }
    

    
    
    func test_decrement_quantity() async throws {
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
        var didDecrement = await nonexistentItem.db_decrement_quantity(deviceLocation: validCoordinates);
        XCTAssertFalse(didDecrement)
        
        
        // ADD VALID ITEM TO DB
        let validItem: Item = Item(
            name: "test_item",
            type: "test_type",
            detail: "test_detail",
            coordinate: CLLocationCoordinate2DMake(90.000, 135.000),
            creator_email: "mongodb@gmail.com",
            counter: 2
        );
        let _ = await validItem.db_add_item();
        
        // [CASE] item quantity > 1
        didDecrement = await validItem.db_decrement_quantity(deviceLocation: validCoordinates);
        XCTAssertTrue(didDecrement)
        
        // [CASE] item quantity == 1
        didDecrement = await validItem.db_decrement_quantity(deviceLocation: validCoordinates);
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
        didDecrement = await validItemQ1.db_decrement_quantity(deviceLocation: invalidCoordinates);
        XCTAssertFalse(didDecrement);
    }
    
    func test_distance_filter() async throws{
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
    
    func test_distance_sort() async throws{
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
