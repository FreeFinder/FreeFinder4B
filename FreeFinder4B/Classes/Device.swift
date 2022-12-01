
import Foundation
import RealmSwift

class Device {
	var email: String? = nil;
	var id: ObjectId = ObjectId();
	var defaults = UserDefaults.standard;
	
	
	/// Initializes the single Device object
	init() {
		let localEmail: String? = defaults.string(forKey: "email");
		let localId: String? = defaults.string(forKey: "id");
		
		if (localEmail == nil) { return }
		do {
			self.id = try ObjectId(string: localId!);
			self.email = localEmail;
		}
		catch { print("Could not handle the local user Id"); }
	}
	
	/// Checks whether there is a user currently signed in on the device
	/// - Returns: A true or false value of whether a user is signed in
	func userSignedIn() -> Bool {
		return (self.email != nil);
	}
	
	/// Saves a user's config to the current device
	/// - Parameters:
	///   - email: a valid email address
	///   - id: the string value of a MongoDB ObjectId
	func saveLocalUser(email: String, id: String) {
		do {
			self.id = try ObjectId(string: id);
			self.email = email;
		}
		catch { print("Could not propertly create the user id"); }
		
		defaults.set(email, forKey: "email")
		defaults.set(id, forKey: "id");
	}
	
	/// Removes a user's config from the current device
	func removeLocalUser() {
		email = nil;
		id = ObjectId();
		
		defaults.set(nil, forKey: "email");
		defaults.set(nil, forKey: "id");
	}
}
