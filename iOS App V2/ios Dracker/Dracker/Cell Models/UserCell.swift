import UIKit

class UserCell: BaseCollectionViewCell {
    
    var user: User? {
        didSet {
            if let user = user {
                profileImage.loadProfile(key: user.uid)
                nameLabel.text = user.name
            }
        }
    }
    
    fileprivate let profileSize: CGFloat = 40

    lazy var profileImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "blankProfile"))
        imageView.layer.cornerRadius = profileSize/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupProfile() {
        addSubview(profileImage)
        addConstraintsWithFormat(format: "H:|-20-[v0(\(profileSize))]", views: profileImage)
        addConstraintsWithFormat(format: "V:|-10-[v0(\(profileSize))]-10-|", views: profileImage)
    }
    
    fileprivate func setupNameLabel() {
        addSubview(nameLabel)
        centerY(item: nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        setupProfile()
        setupNameLabel()
        addLine(position: .Bottom, padding: 10)
    }
}
