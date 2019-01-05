import Foundation

struct User {
    var name: String
    var phone: String
    var uid: String
    
    init(data: [String: String]) {
        name = data["name"]!
        phone = data["phone"]!
        uid = data["uid"]!
    }
}

struct AuthUser {
    var name: String
    var phone: String
    var uid: String
    var email: String
    var setReminder: Bool
    var password: String
    var reminderFrequency: Int
}
