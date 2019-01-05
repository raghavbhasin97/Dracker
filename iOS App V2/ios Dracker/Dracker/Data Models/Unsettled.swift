import Foundation
import UIKit

struct Unsettled {
    var amount: Double
    var description: String
    var isDebt: Bool
    var name: String
    var phone: String
    var imageURL: String
    var transactionTime: Date
    var id: String
    var userId: String
    var notification: String?
    
    init(data: [String: Any]) {
        self.amount = Double(data["amount"] as! String)!
        self.description = data["description"] as! String
        self.isDebt = data["is_debt"] as! Bool
        self.name = data["name"] as! String
        self.phone = data["phone"] as! String
        self.imageURL = data["tagged_image"] as! String
        self.transactionTime = (data["time"] as! String).toDate()
        self.id = data["transaction_id"] as! String
        self.userId = data["uid"] as! String
        self.notification = data["notification_identifier"] as? String
    }
    
    func getDescription(fontSize: CGFloat)  -> NSMutableAttributedString {
        
        var firstHalf = ""
        var secondHalf = ""
        var operativeWord = ""
        var color = UIColor.black
        if isDebt {
            firstHalf = "You"
            operativeWord = "owe"
            secondHalf = name
            color = UIColor.pay
        } else {
            firstHalf = name
            operativeWord = "owes"
            secondHalf = "you"
            color = UIColor.charge
        }
        
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: firstHalf, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .bold
            )]))
        attributedText.append(NSAttributedString(string: " \(operativeWord) ", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .regular)
            ]))
        attributedText.append(NSAttributedString(string: secondHalf, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .bold)
            ]))
        attributedText.append(NSAttributedString(string: " ", attributes: nil))
        attributedText.append(NSAttributedString(string: amount.asAmount(), attributes: [
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .bold)
            ]))
        return attributedText
    }
    
    func settle() -> Settled {
        return Settled(data: self)
    }
    
}
