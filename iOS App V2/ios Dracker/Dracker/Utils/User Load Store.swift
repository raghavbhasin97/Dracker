import Foundation
import Firebase

func storeUserdata(user: Firebase.User, password: String) {
    let uid = user.uid
    let name = user.displayName!
    let phone = String(user.phoneNumber?.dropFirst(2) ?? "")
    let email = user.email ?? ""
    UserDefaults.standard.set(true, forKey: "isAuthenticated")
    UserDefaults.standard.set(uid, forKey: "uid")
    UserDefaults.standard.set(name, forKey: "name")
    UserDefaults.standard.set(phone, forKey: "phone")
    UserDefaults.standard.set(email, forKey: "email")
    UserDefaults.standard.set(password, forKey: "password")
    UserDefaults.standard.set("1", forKey: "reminderFrequency")
    currentUser = AuthUser(name: name, phone: phone, uid: uid, email: email, setReminder: false, password: password, reminderFrequency: 1)
}


func clearUserdata() {
    UserDefaults.standard.set(false, forKey: "isAuthenticated")
    UserDefaults.standard.set(nil, forKey: "uid")
    UserDefaults.standard.set(nil, forKey: "name")
    UserDefaults.standard.set(nil, forKey: "phone")
    UserDefaults.standard.set(nil, forKey: "email")
    UserDefaults.standard.set(nil, forKey: "password")
    UserDefaults.standard.set(false, forKey: "setReminder")
    UserDefaults.standard.set(nil, forKey: "reminderFrequency")
    currentUser = nil
}

func loadUser() {
    let uid = UserDefaults.standard.object(forKey: "uid") as! String
    let name = UserDefaults.standard.object(forKey: "name") as! String
    let phone = UserDefaults.standard.object(forKey: "phone") as! String
    let email = UserDefaults.standard.object(forKey: "email") as! String
    let password = UserDefaults.standard.object(forKey: "password") as! String
    let setReminder = UserDefaults.standard.bool(forKey: "setReminder")
    let reminderFrequency = Int(UserDefaults.standard.object(forKey: "reminderFrequency") as! String)
    currentUser = AuthUser(name: name, phone: phone, uid: uid, email: email, setReminder: setReminder, password: password, reminderFrequency: reminderFrequency ?? 1)
}
