
import UIKit
import UserNotifications

func create_notification(title: String, body: String, identifier: String, info: [AnyHashable: Any]) {
    let notification = UNMutableNotificationContent()
    notification.title = title
    notification.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
    notification.body = body
    notification.sound = .default
    notification.userInfo = info
    notification.categoryIdentifier = "dracker.drackerapps.notifications"
    let freq = Double(UserDefaults.standard.object(forKey: "frequency") as! String)
    let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: UNTimeIntervalNotificationTrigger(timeInterval: seconds_in_day * freq!, repeats: true))
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func remove_notification(identifier: String?) {
    if identifier == nil { return }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers:  [identifier!])
}
