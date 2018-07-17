import UIKit

class FriendsDetailCell: BaseTableViewCell {
    
    let detail_text: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: "Arial", size: 16.0)
        label.numberOfLines = 1
        return label
    }()
    
    let title_text: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: "ArialRoundedMTBold", size: 18.0)
        label.numberOfLines = 1
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    override func setup() {
        super.setup()
        addSubview(detail_text)
        addSubview(amount)
        addSubview(title_text)
        center_Y(item: amount)
        addConstraintsWithFormat(format: "H:[v0]-20-|", views: amount)
        addConstraintsWithFormat(format: "H:|-20-[v0]", views: title_text)
        addConstraintsWithFormat(format: "H:|-25-[v0]", views: detail_text)
        addConstraintsWithFormat(format: "V:|-10-[v0]-5-[v1]", views: title_text, detail_text)
    }
    
    func create_view(data: Friends_Data) {
        detail_text.text = data.description
        let amount_value = Double(data.amount)!
        if data.settelement_time == nil {
            amount.textColor = .theme
            amount.text = amount_value.as_amount()
            if data.is_debt {
                title_text.text = "You owe \(data.name)"
            } else {
                title_text.text = "\(data.name) owes you"
            }
        } else {
            if data.is_debt {
                amount.text = "-" + amount_value.as_amount()
                amount.textColor = .delete_action
                title_text.text = "You paid \(data.name)"
            } else {
                amount.text = "+" + amount_value.as_amount()
                amount.textColor = .settle_action
                title_text.text = "\(data.name) paid you"
            }
        }
    }
    
}
