import Foundation

struct Configuration {
    var title: String
    var image: String
    var button: String
    var placeholder: String
    var isSecure: Bool
    var action: (String) -> Bool
}
