import Foundation
import UIKit
import RealmSwift


func clearConfig() { // RESET ALL CONTEXTS THEN MOVE TO START SCREEN
	DEVICE_DATA.removeLocalUser();
	USER = nil;
	APP_DATA = nil;
}

func validEmail(email: String) -> Bool {
	return email.hasSuffix("@uchicago.edu") && email.count > 13;
}

func db_fetch_user(email: String) async -> User? {
    var res: User? = nil;
    do {
        let app = App(id: APP_ID);
        let _ = try await app.login(credentials: Credentials.anonymous);
        // fetch the DB
        let client = app.currentUser!.mongoClient("mongodb-atlas")
        let database = client.database(named: "freeFinder")
        let users = database.collection(withName: "users")
        
        let potentialUser: Document = ["email" : AnyBSON(stringLiteral: email)];
        let user = try await users.findOneDocument(filter: potentialUser);
        if (user == nil) {
            print("User email is not currently registered in database.")
            return res;
        }
        print("Account in the database: \(String(describing: user))")
        let id = ((user?["_id"]!!)?.objectIdValue!)!;
        let temp_user = User(email: email, id: id);
        res = temp_user;
    } catch {
        print("Failed to fetch the user: \(error.localizedDescription)")
    }
    
    return res;
}
