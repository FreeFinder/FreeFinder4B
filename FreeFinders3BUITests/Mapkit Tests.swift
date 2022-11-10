//
//  Mapkit Tests.swift
//  FreeFinders3BUITests
//
//  Created by William Zeng on 11/9/22.
//

import XCTest
import MapKit
import RealmSwift

@testable import FreeFinders3B
final class Mapkit_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMapLoaded() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
//        app.launch()
        let map = app.maps.element(boundBy: 0)
        XCTAssertNotNil(map, "There is no Map View in unit test")

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRefreshMap() async {
        let app = XCUIApplication()
        app.launch()

        await refresh()
        let map = app.maps.element(boundBy: 0)
        XCTAssertNotNil(map, "There is no Map View in unit test")

    }
    
//    func isMapProper() {
//        XCTAssertNotNil(self.viewControllerUnderTest.mapView.delegate, "MapView violates mapview delegate")
//    }
    
    
//    func testIsMapViewProper() {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        let map = app.maps.element(boundBy: 0)
//        // Checks if the view controller is aligned with apple mapkit protocol
//        XCTAssert(map.conforms(to: MKMapViewDelegate.self), "ViewController violates MKMapViewDelegate protocol")
//    }
    
//    func hasTargetAnnotation(sampleAnnotation: MKAnnotation.Type) -> Bool {
//       let mapAnnotations = self.viewControllerUnderTest.mapView.annotations
//       var hasTargetAnnotation = false
//       for anno in mapAnnotations {
//           if (anno.isKind(of: Item.self)) {
//               hasTargetAnnotation = true
//           }
//       }
//       return hasTargetAnnotation
//    }


    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
