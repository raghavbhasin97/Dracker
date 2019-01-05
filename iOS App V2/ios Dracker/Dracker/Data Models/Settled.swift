import Foundation

struct Settled {
    var amount: Double
    var description: String
    var isDebt: Bool
    var name: String
    var phone: String
    var settlementTime: Date
    var userId: String
    
    init(data: [String: Any]) {
        self.amount = Double(data["amount"] as! String)!
        self.description = data["description"] as! String
        self.isDebt = data["is_debt"] as! Bool
        self.name = data["name"] as! String
        self.phone = data["phone"] as! String
        self.settlementTime = (data["settelement_time"] as! String).toDate()
        self.userId = data["uid"] as! String
    }
    
    init(data: Unsettled) {
        self.amount = data.amount
        self.description = data.description
        self.isDebt = data.isDebt
        self.name = data.name
        self.phone = data.phone
        self.settlementTime = Date()
        self.userId = data.userId
    }
}
