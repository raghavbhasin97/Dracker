import UIKit

protocol emptyCellAction {
    func performAction()
}

class EmptyHomeCell: BaseTableViewCell {

    let icon = UIImageView(image: #imageLiteral(resourceName: "whoPayed"))
    var delegate: emptyCellAction?
    
    lazy var transactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.drBlack, for: .normal)
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        button.setTitle("Create new transaction", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .drBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate func setupImageView() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)
        centerX(item: icon)
        centerY(item: icon, constant: -80)
    }
    
    fileprivate func setupTextLabel() {
        addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descriptionLabel)
        let atttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "You have no pending transactions\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
        atttributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4, weight: .regular)]))
        atttributedText.append(NSAttributedString(string: "It looks like you have already settled all your pending transactions. To create a new transaction tap the button below.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        descriptionLabel.attributedText = atttributedText
    }
    
    fileprivate func setupTransactionButton() {
        addSubview(transactionButton)
        centerX(item: transactionButton)
        transactionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func setup() {
        backgroundColor = .white
        setupImageView()
        setupTextLabel()
        setupTransactionButton()
    }

    @objc func addTransaction() {
        delegate?.performAction()
    }
}
