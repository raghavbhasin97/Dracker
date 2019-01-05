import UIKit
import UserNotifications

class Main: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    let homeItem = Home()
    fileprivate func setup() {
        view.backgroundColor = .white
        UNUserNotificationCenter.current().delegate = self
        delegate = self
        
        let home = getController(root: homeItem, selectedImage: #imageLiteral(resourceName: "homeSelected"), image: #imageLiteral(resourceName: "home"), title: "Home")
        let wallet = getController(root: Wallet(), selectedImage: #imageLiteral(resourceName: "walletSelected"), image: #imageLiteral(resourceName: "wallet"), title: "Wallet")
        let add = getController(root: UIViewController(), selectedImage: #imageLiteral(resourceName: "add"), image: #imageLiteral(resourceName: "add"), title: nil)
        add.tabBarItem.imageInsets = UIEdgeInsets(top: 7.5, left: 0, bottom: -7.5, right: 0)
        let summary = getController(root: Overview(), selectedImage: #imageLiteral(resourceName: "summarySelected"), image: #imageLiteral(resourceName: "summary"), title: "Overview")
        let settings = getController(root: Settings(), selectedImage: #imageLiteral(resourceName: "settingsSelected"), image: #imageLiteral(resourceName: "settings"), title: "Options")
        viewControllers = [home, wallet, add, summary, settings]
    }
    
    func getController(root: UIViewController, selectedImage: UIImage, image: UIImage, title: String?) -> UIViewController {
        let controller = UINavigationController(rootViewController: root)
        controller.tabBarItem.title = title
        controller.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysTemplate)
        controller.tabBarItem.image = image.withRenderingMode(.alwaysTemplate)
        return controller
    }
}


extension Main: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.lastIndex(of: viewController)
        if index == 2 {
            let add = Add()
            add.delegate = homeItem
            let controller = UINavigationController(rootViewController:  add)
            present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension Main: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
}
