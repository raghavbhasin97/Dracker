import Foundation

struct User: Decodable {
    let phone: String
    let name: String
    let uid: String
    
    private enum CodingKeys: String, CodingKey {
        case phone = "phone"
        case uid = "uid"
        case name = "name"
    }
}
