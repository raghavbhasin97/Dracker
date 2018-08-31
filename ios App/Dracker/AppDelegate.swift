import UIKit
import CoreData
import AWSCore
import Firebase
import UserNotifications
import LinkKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Setup services
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) {(_,_) in }
        UINavigationBar.appearance().barTintColor = .theme
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
        application.statusBarStyle = .lightContent
        if !reachable() {
            redirect_to_no_connection()
            return true
        }
        UserDefaults.standard.set(false, forKey: "auth")
        create_quick_actions()
        setup_notifications()
        setup_AWS()
        setup_Firebase()
        setup_plaid()
        secure_entry()
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            if shortcutItem.type == "com.drackerapp.dracker.add_transaction" {
                let controller = AddTransaction()
                if let root = window?.rootViewController as? UINavigationController? {
                    root?.pushViewController(controller, animated: false)
                }
            } else if shortcutItem.type == "com.drackerapp.dracker.qr_code" {
                let controller = QRCode()
                if let root = window?.rootViewController as? UINavigationController? {
                    root?.pushViewController(controller, animated: false)
                }
            } else if shortcutItem.type == "com.drackerapp.dracker.friends" {
                let controller = Contacts()
                if let root = window?.rootViewController as? UINavigationController? {
                    root?.pushViewController(controller, animated: false)
                }
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        do {
            try  Auth.auth().signOut()
        } catch {
            NSLog("User wasn't signed in.")
            //Should only happen if user terminates on signin screen.
        }
    }
    
    //MARK: View Controller set ups
    
    fileprivate func redirect_to_Home() {
        window = UIWindow(frame: UIScreen.main.bounds)
        if let _ = UserDefaults.standard.object(forKey: "phone")  {
            if !UserDefaults.standard.bool(forKey: "bank") {
                window?.rootViewController = OnboardingBankAccount()
            } else {
                window?.rootViewController = root_navigation()
            }
        } else {
            window?.rootViewController = Onboarding()
        }
        window?.makeKeyAndVisible()
    }
    
    fileprivate func redirect_to_login()
    {
        let controller = Login()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    fileprivate func secure_entry() {
        if UserDefaults.standard.bool(forKey: "auto_login") {
            authenticate()
            redirect_to_Home()
        } else {
            redirect_to_login()
        }
    }
    
    //MARK: Services
    
    fileprivate func setup_AWS() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: AWS_accessKey, secretKey: AWS_secretKey)
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    fileprivate func setup_plaid() {
        PLKPlaidLink.setup { (success, error) in
            if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func setup_Firebase() {
        FirebaseApp.configure();
    }
    
    fileprivate func redirect_to_no_connection() {
        let controller = NetworkConnection()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
    
    //MARK: Quick Actions
    fileprivate func create_quick_actions() {
        let add_shortcut = UIApplicationShortcutItem(type: "com.drackerapp.dracker.add_transaction", localizedTitle: "Add Transaction", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "create"), userInfo: nil)
        let qr_shortcut = UIApplicationShortcutItem(type: "com.drackerapp.dracker.qr_code", localizedTitle: "QR Code", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "scanner"), userInfo: nil)
        let friends_shortcut = UIApplicationShortcutItem(type: "com.drackerapp.dracker.friends", localizedTitle: "Friends", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "contact"), userInfo: nil)
        
        UIApplication.shared.shortcutItems = [add_shortcut, qr_shortcut,friends_shortcut]
    }

    fileprivate func setup_notifications() {
        let view_notification = UNNotificationAction(identifier: "com.drakerapp.dracker.notification.view", title: "Show", options: [.foreground])
        let note_notification = UNNotificationAction(identifier: "com.drakerapp.dracker.notification.note", title: "Add Note", options: [.foreground])
        let delete_notification = UNNotificationAction(identifier: "com.drakerapp.dracker.notification.settle", title: "Settle", options: [.foreground])
        let categories = UNNotificationCategory(identifier: "dracker.drackerapps.notifications", actions: [view_notification, note_notification, delete_notification], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([categories])
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        authorize {
            let json = notification.userInfo
            var parameters: [String: String] = [:]
            parameters["transaction_id"] = json?["transaction_id"] as? String
            parameters["uid"] = json?["uid"] as? String
            get_transaction(parameter: parameters) {[unowned self] (data) in
                let result = data.value as! [String: Any]
                let is_debt = result["is_debt"] as! Bool
                let amount = result["amount"] as! String
                let description = result["description"] as! String
                let name = result["name"] as! String
                let tagged_image = result["tagged_image"] as! String
                let time = result["time"] as! String
                let uid = result["uid"] as! String
                let phone = result["phone"] as! String
                let transaction_id = result["transaction_id"] as! String
                let amount_value = Double(amount)!
                
                var transaction = Unsettled(is_debt: is_debt, amount: amount, description: description, name: name, tagged_image: tagged_image, time: time, uid: uid, phone: phone, notification_identifier: nil, transaction_id: transaction_id)
                if let notification_identifier = result["notification_identifier"] {
                    transaction.notification_identifier = notification_identifier as? String
                }
                if identifier == "com.drakerapp.dracker.notification.view" {
                    let controller = Detail()
                    controller.data = transaction
                    controller.prepare_view()
                    if let root = self.window?.rootViewController as? UINavigationController? {
                        root?.pushViewController(controller, animated: false)
                    }
                } else if identifier == "com.drakerapp.dracker.notification.note" {
                    let controller = Note()
                    controller.data = transaction
                    if let root = self.window?.rootViewController as? UINavigationController? {
                        root?.pushViewController(controller, animated: false)
                    }
                } else if identifier == "com.drakerapp.dracker.notification.settle" {
                    let time = Date().as_string(format: .full)
                    var parameters: [String: String] = [:]
                    parameters["transaction_id"] = json?["transaction_id"] as? String
                    parameters["payee_uid"] = json?["uid"] as? String
                    parameters["payer_uid"] = json?["payer_uid"] as? String
                    parameters["time"] = time
                    remove_notification(identifier: json?["notification_identifier"] as? String)
                    debit -= amount_value
                    let settled = Settled(is_debt: is_debt, amount: amount, description: description, name: name)
                    settled_transactions.insert(settled, at: 0)
                    let root = self.window?.rootViewController as? UINavigationController?
                    let home = root??.viewControllers[0] as! Home
                    home.walletcomponent.create_view()
                    post_settle_transaction(parameters: parameters, completion: { (data) in
                        if data.isFailure { return }
                        home.loading()
                        home.Homecomponent.refetch_data()
                    })
                    
                }
            }
        }
    }
}
