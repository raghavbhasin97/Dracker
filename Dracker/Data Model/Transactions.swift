import UIKit

struct Settled: Decodable {
    let is_debt: Bool
    let amount: String
    let description: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case is_debt = "is_debt"
        case amount = "amount"
        case description = "description"
        case name = "name"
    }
}

struct Unsettled: Decodable {
    let is_debt: Bool
    let amount: String
    let description: String
    let name: String
    let tagged_image: String
    let time: String
    let uid: String
    let phone: String
    var notification_identifier: String?
    var transaction_id: String
    
    private enum CodingKeys: String, CodingKey {
        case is_debt = "is_debt"
        case amount = "amount"
        case description = "description"
        case name = "name"
        case tagged_image = "tagged_image"
        case time = "time"
        case uid = "uid"
        case phone = "phone"
        case notification_identifier = "notification_identifier"
        case transaction_id = "transaction_id"
    }
}
