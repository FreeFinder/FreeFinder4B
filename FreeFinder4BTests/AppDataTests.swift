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
        var test_results: [[Item]]
		test_results = []
		// now have blank slate to test filtering on empty list
		test_app.filterMapItems(tag: "Food")
		XCTAssertTrue(test_app.mapItems.isEmpty)
        
        let test_details = "Test_Details"
        let test_coords = CLLocationCoordinate2DMake(41.797, -87.593)
        let test_quantity = 2
                
        for item_type in ITEM_TAGS{
            let i_1 = await test_user.create_item(name: item_type+"1", type: item_type, detail: test_details, coordinate: test_coords, quantity: test_quantity)
            let i_2 = await test_user.create_item(name: item_type+"2", type: item_type, detail: test_details, coordinate: test_coords, quantity: test_quantity)
            test_app.items.append(contentsOf: [i_1!, i_2!])
            test_results.append([i_1!,i_2!])
            if (item_type == "Food"){   // no items of chosen input
                test_app.filterMapItems(tag: "Clothing")
                XCTAssertTrue(test_app.mapItems.isEmpty)
            }

        }
		print(test_results)
		
		// test correct filtering of each category
		
		// food
		test_app.filterMapItems(tag: "Food")
		XCTAssertTrue(test_app.mapItems == test_results[0])
		
		// clothing
		test_app.filterMapItems(tag: "Clothing")
		XCTAssertTrue(test_app.mapItems == test_results[1])
		
		// furniture
		test_app.filterMapItems(tag: "Furniture")
		XCTAssertTrue(test_app.mapItems == test_results[2])
		
		// other
		test_app.filterMapItems(tag: "Other")
		XCTAssertTrue(test_app.mapItems == test_results[3])
        
        
        for row in test_results{
            for item in row{
                let _ = await item.delete_Item(deviceLocation: test_coords)
            }
        }
		
	}

}
