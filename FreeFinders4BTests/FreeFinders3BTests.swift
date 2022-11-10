//
//  FreeFinders3BTests.swift
//  FreeFinders3BTests
//
//  Created by William Zeng on 11/7/22.
//

import XCTest
import MapKit
import RealmSwift
//import Realm.Private
@testable import FreeFinders3B

final class FreeFinders3BTests: XCTestCase {
    func testCreateItem() async throws {
        // get initial state of the database
        let test_user = await User(email: "mongodb@gmail.com");
        let observer = await AppData(user: test_user);
        
        
        let v_title = "title"
        let v_desc = "valid description"
            
        // valid item
        let v_item = await test_user.create_item(name: "test_item", type: "test_type", detail: "test_detail",  coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)
        let res = (await v_item!.db_item_exists())
        XCTAssertTrue(res)
            
        
        
        //invalid title
        let i_title1 = " HJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk"
        let res2 = await test_user.create_item(name: i_title1, type: "test_type", detail: v_desc, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)
        XCTAssertNil(res2)
        let i_title2 = ""
        
        let res3 = await test_user.create_item(name: i_title2, type: "test_type", detail: v_desc, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)
        XCTAssertNil(res3)
        
        //invalid quantity
        //let i_quantity1 = 999
        //XCTAssertNil(test_user.create_item(name: v_title, type: "test_type", detail: v_desc, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: i_quantity1))
        
        //let i_quantity2 = 0
        //XCTAssertNil(test_user.create_item(name: v_title, type: "test_type", detail: v_desc, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: i_quantity2))

        
        //invalid description -- empty
        let i_description1 = ""
        let res4 = await test_user.create_item(name: v_title, type: "test_type", detail: i_description1, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)
        XCTAssertNil(res4)

        //invalid description -- too long
        let i_description2 = "HJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlkHJIiimknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk'/;.jkkkkkkkkkkkkkkkkkkkkkkasdfkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlkHJIiikkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkmknllijlk"
        let res5 = await test_user.create_item(name: v_title, type: "test_type", detail: i_description2, coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)
        XCTAssertNil(res5)
        
        }
        
    func testComment() async throws{
        //test cases are the same but the syntax and coding has changed due to changing our database from firebase to MongoDB and separating the use cases functions and database calls
          
        //set up users and items for testing
        let test_user2 = await User(email: "mongodb@gmail.com");
        let observer = await AppData(user: test_user2);

        let v_item = await test_user2.create_item(name: "test_item", type: "test_type", detail: "test_detail",  coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 1)

        let items = await observer.db_get_all_items()



        let test_item = items[0]
        let bad_item = await Item(name: "not_in_the_database", type: "test_type", detail: "test_detail",  coordinate: CLLocationCoordinate2DMake(90.000, 135.000), creator_email: "mongodb@gmail.com")

        // get initial state of the comments for test_item
        let initial_comments = test_item.db_get_comments()

        // false: empty comment with no previous comments
        let res = await test_user2.comment(i: test_item, comment: "")
        XCTAssertFalse(res)

        // false: valid comment but not valid item
        let res2 = await test_user2.comment(i: bad_item, comment: "fail")
        XCTAssertFalse(res2)

        //true: valid comment and item
        let res3 = await test_user2.comment(i: test_item, comment: "first comment")
        XCTAssertTrue(res3)
        var new_comments = test_item.db_get_comments()
        let i = initial_comments.count
        XCTAssertEqual("first comment", new_comments[i-1])

        //true: valid comment and item 2, make sure both comments are in database
        let res4 = await test_user2.comment(i: test_item, comment: "second comment")
        XCTAssertTrue(res4)
        new_comments = test_item.db_get_comments()
        XCTAssertEqual("second comment", new_comments[i])

        //false: invalid comment, previous comments
        let res5 = await test_user2.comment(i: test_item, comment: "")
        XCTAssertFalse(res5)
            
    }
    
    func test_delete_item() async throws {
        // creates valid item in the db
        // checks the item is there
        // deletes item from db
        // checks item not in db
        
        //create item and user
        let test_user3 = await User(email: "mongodb@gmail.com");
        let observer = await AppData(user: test_user3);
            
                    
        let v_item = await test_user3.create_item(name: "test_item", type: "test_type", detail: "test_detail",  coordinate: CLLocationCoordinate2DMake(90.000, 135.000), quantity: 9)
        
        //checks in db
        let res = await (v_item!.db_item_exists())
        XCTAssertTrue(res)
        
        //deletes item
        await v_item?.delete_Item()
        
        //checks not in db
        let res2 = await (v_item!.db_item_exists())
        XCTAssertTrue(res2)
        
    }
    
    func testSignIn() async throws{
        //will create two users, one with valid email one without.
        let goodUser = await sign_in(email: "cbgravitt@uchicago.edu")
        XCTAssertEqual(goodUser!.email, "cbgravitt@uchicago.edu")
        
        //invalid users can't sign in, return null
        let badUser = await sign_in(email: "cbgravitt@google.com")
        XCTAssertNil(badUser)

    }
}
