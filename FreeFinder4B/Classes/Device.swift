
import Foundation
import RealmSwift

class Device {
    var email: String? = nil;
    var id: ObjectId = ObjectId();
    var defaults = UserDefaults.standard;
    
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
    
    func userSignedIn() -> Bool {
        return (self.email != nil);
    }
    
    func saveLocalUser(email: String, id: String) {
        do {
            self.id = try ObjectId(string: id);
            self.email = email;
        }
        catch { print("Could not propertly create the user id"); }
        
        defaults.set(email, forKey: "email")
        defaults.set(id, forKey: "id");
    }
	
	func removeLocalUser() {
		email = nil;
		id = ObjectId();
		
		defaults.set(nil, forKey: "email");
		defaults.set(nil, forKey: "id");
	}
}
