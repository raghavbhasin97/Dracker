import UIKit
import Firebase
import AWSCore
import UserNotifications
import LinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadApp()
        setupServices()
        setupAppearance()
        return true
    }
    
    fileprivate func setupAppearance() {
        UITabBar.appearance().barTintColor = .theme
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .themeUnselected
        UINavigationBar.appearance().barTintColor = .theme
        UINavigationBar.appearance().tintColor = .white
    }
    
    fileprivate func setupServices() {
        //Notification Framework
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) {(_,_) in }
        //Load Firebase
        FirebaseApp.configure();
        //Load AWS
        let awsConfigs = Configrations["AWS"]!
        let access = awsConfigs["access"]!
        let secret = awsConfigs["secret"]!
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: access, secretKey: secret)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        //Setup Link
        PLKPlaidLink.setup { (success, error) in
            if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
        }
    }

    fileprivate func loadHome() {
        loadUser()
        let main = Main()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = main
        window?.makeKeyAndVisible()
    }
    
    fileprivate func loadLogin() {
        let login = UINavigationController(rootViewController: Login())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = login
        window?.makeKeyAndVisible()
    }
    
    fileprivate func loadApp() {
        if UserDefaults.standard.bool(forKey: "isAuthenticated") {
            loadHome()
        } else {
            loadLogin()
        }
    }
}

