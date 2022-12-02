import UIKit
import RealmSwift
import CoreLocation

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        var locationBool = LocationManager.shared.checkLocationPrefs()
//        if locationBool == false {
//            var alertController = UIAlertController(title: "Location Preferences Disabled", message: "Turn on location preferences for FreeFinder in Settings before continuing.", preferredStyle: .actionSheet)
//            var okAction = UIAlertAction(title: "Done!", style: UIAlertAction.Style.default) {
//                                    UIAlertAction in
//                                    NSLog("Please restart the app before continuing.")
//                                }
//            var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//                                    UIAlertAction in
//                                    NSLog("Some app functionality will be unavailable.")
//                                }
//                alertController.addAction(okAction)
//                alertController.addAction(cancelAction)
//                self.window.rootViewController?.presentViewController(alertController, animated: true)
//        }
//        return
//    }

}

