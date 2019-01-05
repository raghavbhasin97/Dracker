import UIKit

protocol PhoneDelegate {
    func phoneUser(phone: String?)
}

class OverviewCell: BaseTableViewCell {
    
    fileprivate let profileSize: CGFloat = 60
    fileprivate let fontSize: CGFloat = 15.25
    
    var item: OverviewItem? {
        didSet {
            if let item = item {
                setupData(item: item)
            }
        }
    }
    
    var delegate: PhoneDelegate?
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "blankProfile"))
        imageView.layer.cornerRadius = profileSize/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 15)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 18)
        return label
    }()
    
    lazy var phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.tintColor = .themeLight
        button.addTarget(self, action: #selector(phoneUser), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    fileprivate func setupProfile() {
        addSubview(profileImage)
        addConstraintsWithFormat(format: "H:|-20-[v0(\(profileSize))]", views: profileImage)
    }
    
    fileprivate func setupTitle() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
    }
    
    fileprivate func setupAmountLabel() {
        addSubview(amountLabel)
        amountLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7.5).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        setupProfile()
        setupTitle()
        setupAmountLabel()
        //Vertical possitions
        addConstraintsWithFormat(format: "V:|-20-[v0(\(profileSize))]-7.5-|", views: profileImage)
        accessoryView = phoneButton
    }
    
    fileprivate func setupData(item: OverviewItem) {
        profileImage.loadProfile(key: item.uid)
        titleLabel.text = item.name
        if item.amount < 0 {
            amountLabel.text = abs(item.amount).asAmount() + "↓"
            amountLabel.textColor = .pay
        } else if item.amount > 0 {
            amountLabel.text = item.amount.asAmount() + "↑"
            amountLabel.textColor = .charge
        } else {
            amountLabel.textColor = .themeLight
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }
    
    @objc fileprivate func phoneUser() {
        delegate?.phoneUser(phone: item?.phone)
    }
}
