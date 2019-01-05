import Foundation

enum DateFormats: String {
    case compact = "MMM dd yyyy h:mm a"
    case full = "MM/dd/yy h:mm:ss.SSSS a Z"
    case dayTime = "E h:mm a"
    case monthDay = "MMM dd"
    case monthDayYear = "MM dd yyyy"
    case time = "HH:MM a"
    case monthNameDayYear = "MMM dd, yyyy"
    case birthdate = "yyyy-MM-dd"
}
