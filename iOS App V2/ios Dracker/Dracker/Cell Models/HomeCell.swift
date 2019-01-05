import UIKit

class HomeCell: BaseTableViewCell {
    
    fileprivate let profileSize: CGFloat = 60
    fileprivate let fontSize: CGFloat = 15.25
    
    var item: Unsettled? {
        didSet {
            if let item = item {
                setupData(item: item)
            }
        }
    }
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "blankProfile"))
        imageView.layer.cornerRadius = profileSize/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let handleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.font = .systemFont(ofSize: 10, weight: .bold)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupProfile() {
        addSubview(profileImage)
        addConstraintsWithFormat(format: "H:|-20-[v0(\(profileSize))]", views: profileImage)
    }
    
    fileprivate func setupHandle() {
        addSubview(handleLabel)
        handleLabel.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
    }
    
    fileprivate func setupTime() {
        addSubview(timeLabel)
        addConstraintsWithFormat(format: "H:[v0]-20-|", views: timeLabel)
        timeLabel.bottomAnchor.constraint(equalTo: handleLabel.bottomAnchor).isActive = true
    }
    
    fileprivate func setupTitle() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        setupProfile()
        setupHandle()
        setupTime()
        setupTitle()
        //Vertical possitions
        addConstraintsWithFormat(format: "V:|-20-[v0(\(profileSize))]-3-[v1]-7.5-|", views: profileImage, handleLabel)
        accessoryType = .disclosureIndicator
    }
    
    fileprivate func setupData(item: Unsettled) {
        profileImage.loadProfile(key: item.userId)
        handleLabel.text = item.name.nameHandle()
        timeLabel.text = item.transactionTime.formatDate(option: DateFormats.dayTime)
        titleLabel.attributedText = item.getDescription(fontSize: fontSize)
    }
}
