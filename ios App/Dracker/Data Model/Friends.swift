import Foundation


struct Friends: Decodable {
    let transactions: String
    let amount: Double
    let phone: String
    let name: String
    var uid: String?
    
    private enum CodingKeys: String, CodingKey {
        case transactions = "transactions"
        case amount = "amount"
        case phone = "phone"
        case name = "name"
    }
}

struct Friends_Data: Decodable {
    let is_debt: Bool
    let amount: String
    let description: String
    let name: String
    let time: String?
    let settelement_time: String?
    
    private enum CodingKeys: String, CodingKey {
        case is_debt = "is_debt"
        case amount = "amount"
        case description = "description"
        case name = "name"
        case time = "time"
        case settelement_time = "settelement_time"
    }
}
