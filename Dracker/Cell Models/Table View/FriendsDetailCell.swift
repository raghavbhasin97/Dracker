import UIKit

class FriendsDetailCell: BaseTableViewCell {
    
    let detail_text: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: "Arial", size: 16.0)
        label.numberOfLines = 1
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    override func setup() {
        super.setup()
        addSubview(detail_text)
        addSubview(amount)
        center_Y(item: amount)
        addConstraintsWithFormat(format: "H:[v0]-30-[v1]-20-|", views: detail_text, amount)

        center_Y(item: detail_text)
    }
    
    func create_view(data: Friends_Data) {
        detail_text.text = data.description
        let amount_value = Double(data.amount)!
        if data.settelement_time == nil {
            amount.textColor = .theme
            amount.text = amount_value.as_amount()
        } else {
            if data.is_debt {
                amount.text = amount_value.as_amount()
                amount.textColor = .delete_action
            } else {
                amount.text = amount_value.as_amount()
                amount.textColor = .settle_action
            }
        }
    }
    
}
