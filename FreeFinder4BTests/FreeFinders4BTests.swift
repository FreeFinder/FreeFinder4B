import XCTest
import MapKit
import RealmSwift

@testable import FreeFinder4B

final class FreeFinders4BTests: XCTestCase {
    /*
     [TODO] auth.swift test functions
     1. validEmail
     2. db_fetch_user
     
     
     [TODO] Device.swift test functions
     1. userSignedIn
     2. saveLocalUser
     
     */
    
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
}
