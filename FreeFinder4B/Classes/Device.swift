
import Foundation
import RealmSwift

class Device {
    var email: String? = nil;
    var id: ObjectId = ObjectId();
    var defaults = UserDefaults.standard;
    
    init() {
        let local_email: String? = defaults.string(forKey: "email");
        let local_id: String? = defaults.string(forKey: "id");
        
        if (local_email == nil) { return }
        do {
            self.id = try ObjectId(string: local_id!);
            self.email = local_email;
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
}
