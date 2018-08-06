import UIKit

class WalletCell: BaseCollectionViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    override func setup_cell() {
        super.setup_cell()
        //Setup Cell graphics
        backgroundColor = .white
        layer.cornerRadius = 10
        let shadow = UIBezierPath(roundedRect: CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width + 1, height: bounds.height + 1), cornerRadius: 10.0)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: CGFloat(-0.75), height: CGFloat(-0.75))
        layer.shadowOpacity = 0.80
        layer.shadowPath = shadow.cgPath
        contentView.layer.cornerRadius = 10.0
        contentView.clipsToBounds = true
        addSubview(title)
        addSubview(amount)
        addConstraintsWithFormat(format: "H:|-10-[v0(200)]", views: title)
        center_Y(item: title)
        addConstraintsWithFormat(format: "H:[v0]-10-|", views: amount)
        center_Y(item: amount)
        layer.shouldRasterize = true
    }

    func create_view(data: Settled) {
        amount.text = Double(data.amount)?.as_amount()
        if data.is_debt {
            self.amount.textColor = .credit
            self.title.text = "You paid \(data.name) for \"\(data.description)\""
        } else {
            self.amount.textColor = .debt
            self.title.text = "\(data.name) paid you for \"\(data.description)\""
        }
    }
}
