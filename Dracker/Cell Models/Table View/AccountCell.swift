import UIKit

class AccountCell: BaseTableViewCell {
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 17)
        return label
    }()
    
    override func setup() {
        backgroundColor = .clear
        addSubview(name)
        addConstraintsWithFormat(format: "H:[v0]-100-|", views: name)
        center_Y(item: name)
    }
    
    func setup(account: Account) {
        name.text = account.name
    }
    
}
