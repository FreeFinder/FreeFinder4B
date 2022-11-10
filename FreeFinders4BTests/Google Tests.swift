//
//  GoogleTests.swift
//  GoogleTests
//
//  Created by William Zeng on 10/31/22.
//

import XCTest
import MapKit
import RealmSwift
//import Realm.Private
@testable import FreeFinders3B

final class GoogleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func TestSignIn() async {
        //will create two users, one with valid email one without.
        let goodUser = await sign_in(email: "cbgravitt@uchicago.edu")
        XCTAssertEqual(goodUser!.email, "cbgravitt@uchicago.edu")
        
        //invalid users can't sign in, return null
        let badUser = await sign_in(email: "cbgravitt@google.com")
        XCTAssertNil(badUser)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
