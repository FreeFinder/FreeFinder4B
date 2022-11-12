import Foundation
import RealmSwift



func sign_in(email: String) async -> User?{
    if email.hasSuffix("@uchicago.edu"){
        let user = User(email: email);
        await user.db_add_user();
        return user;
    }
    return nil;
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

