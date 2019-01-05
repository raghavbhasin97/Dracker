import Foundation
import UserNotifications

fileprivate let SECONDS_IN_A_DAY:TimeInterval = 86400

func createNotification(title: String, body: String, identifier: String) {
    if !UserDefaults.standard.bool(forKey: "setReminder") { return }
    let reminderFrequency = currentUser.reminderFrequency
    let notification = UNMutableNotificationContent()
    notification.title = title
    notification.body = body
    notification.sound = .default
    notification.categoryIdentifier = "com.dracker.local.notifications"
    let request = UNNotificationRequest(identifier: identifier, content: notification, trigger: UNTimeIntervalNotificationTrigger(timeInterval: SECONDS_IN_A_DAY * Double(reminderFrequency), repeats: false))
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
