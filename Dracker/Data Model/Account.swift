import Foundation

struct Account: Decodable {
    let name: String
    let institution: String
    let url: String
    var is_default: Bool
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case institution = "institution"
        case is_default = "is_default"
        case url = "url"
    }
}
