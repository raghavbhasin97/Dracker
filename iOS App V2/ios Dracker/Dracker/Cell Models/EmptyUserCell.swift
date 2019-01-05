import UIKit

class EmptyUserCell: BaseCollectionViewCell {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "search"))
    var delegate: emptyCellAction?
    
    lazy var inviteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.drBlack, for: .normal)
        button.addTarget(self, action: #selector(inviteUsers), for: .touchUpInside)
        button.setTitle("Invite friends", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .drBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        centerX(item: imageView)
        centerY(item: imageView, constant: -80)
    }
    
    fileprivate func setupTextLabel() {
        addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: textLabel)
    }
    
    fileprivate func setupInviteButton() {
        addSubview(inviteButton)
        centerX(item: inviteButton)
        inviteButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        setupImageView()
        setupTextLabel()
        setupInviteButton()
    }
    
    func noUsers() {
        let atttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "No other users found\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
        atttributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4, weight: .regular)]))
        atttributedText.append(NSAttributedString(string: "It looks like no users were found in our database.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        textLabel.attributedText = atttributedText
    }
    
    func noResults(_ phrase: String) {
        let atttributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "No match found for your query\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
        atttributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4, weight: .regular)]))
        atttributedText.append(NSAttributedString(string: "We found no users matching \"\(phrase)\" in our database.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        textLabel.attributedText = atttributedText

    }
    
    @objc func inviteUsers() {
        delegate?.performAction()
    }
}
