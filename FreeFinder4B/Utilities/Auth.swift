import Foundation

func sign_in(email: String) async -> User?{
    if email.hasSuffix("@uchicago.edu"){
        let user = User(email: email);
        await user.db_add_user();
        return user;
    }
    return nil;
}
