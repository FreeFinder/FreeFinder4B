import XCTest

@testable import FreeFinder4B

final class LocalDeviceTests: XCTestCase {
	
	func test_userSignedIn() throws {
		/*
		 CASES:
		 1. user credentials are not on local device
		 2. user credentials are on local device
		 */
		
		// clear the device
		let deviceClearer = Device();
		deviceClearer.removeLocalUser();
		
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
		XCTAssertTrue(signedInDevice.userSignedIn());
	}
	
	
	func test_saveLocalUser() throws  {
		/*
		 CASES:
		 1. local credential state goes from empty to something
		 2. local credential state goes from something to something else
		 */
		
		// clear the device
		let deviceClearer = Device();
		deviceClearer.removeLocalUser();
		
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
		
		// clear the device
		let deviceClearer = Device();
		deviceClearer.removeLocalUser();
		
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
}
