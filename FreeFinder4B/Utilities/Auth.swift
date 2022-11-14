import Foundation
import RealmSwift


func validEmail(email: String) -> Bool {
    return email.hasSuffix("@uchicago.edu");
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


// BELOW: will be placed in the view that handles starting the app (most likely sign in or open page)
func configureAppData() {
    setLocalUser();
    print("should b empty");
    if (USER == nil) { return }
}

func userSignedIn() {

}

func setLocalUser() {
    let defaults = UserDefaults.standard;
    let local_email: String? = defaults.string(forKey: "email");
    let local_id: String? = defaults.string(forKey: "id");

    do {
        if (local_email == nil) { return }
        USER = User(
            email: local_email!,
            id: try ObjectId.init(string: local_id!)
        )
    } catch {
        print("Failed to setup app data")
    }
}

func setItemData() async {
    APP_DATA = await AppData(user: USER!);
}

