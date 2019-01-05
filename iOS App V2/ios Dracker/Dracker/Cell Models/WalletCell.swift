import UIKit

class WalletCell: BaseCollectionViewCell {
    
    var item: Settled? {
        didSet {
            if let item = item {
                setHeader(isDebt: item.isDebt, name: item.name)
                amountLabel.text = item.amount.asAmount()
                descriptionLabel.text = item.description
                if item.isDebt {
                    amountLabel.textColor = .pay
                } else {
                    amountLabel.textColor = .charge
                }
            }
        }
    }
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.5, weight: .semibold)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    fileprivate func setupHeader() {
        addSubview(headingLabel)
        headingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12.5).isActive = true
        headingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAmountLabel() {
        addSubview(amountLabel)
        centerY(item: amountLabel)
        amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
    }

    fileprivate func setupDescriptionLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12.5).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 3).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        setupHeader()
        addLine(position: .Bottom, padding: 10)
        setupAmountLabel()
        setupDescriptionLabel()
    }
    
    fileprivate func setHeader(isDebt: Bool, name: String) {
        var firstHalf = ""
        var secondHalf = ""
        if isDebt {
            firstHalf = "You"
            secondHalf = name
        } else {
            firstHalf = name
            secondHalf = "you"
        }
        
        let attributed = NSMutableAttributedString(attributedString: NSAttributedString(string: firstHalf, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.25, weight: .semibold)]))
        attributed.append(NSAttributedString(string: " settled a charge with ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .regular)]))
        attributed.append(NSAttributedString(string: secondHalf, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.25, weight: .semibold)]))
        headingLabel.attributedText = attributed
    }
}
