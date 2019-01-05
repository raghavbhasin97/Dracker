import UIKit
class SettingCell: BaseTableViewCell {
    fileprivate let iconSize: CGFloat = 25
    
    var item: OptionItem? {
        didSet {
            if let item = item {
                icon.image = item.icon.withRenderingMode(.alwaysTemplate)
                title.text = item.title
                if item.accessoryType != nil {
                    accessoryType = item.accessoryType!
                } else {
                    accessoryView = item.accessoryView
                }
            }
        }
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir Next", size: 15)
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate func setupIcon() {
        addSubview(icon)
        centerY(item: icon)
        icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        icon.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        icon.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
    }
    
    fileprivate func setupTitle() {
        addSubview(title)
        title.bottomAnchor.constraint(equalTo: icon.bottomAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 10).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        setupIcon()
        setupTitle()
    }
    
    public func setState(state: Bool) {
        title.textColor = state ? .black : .overlay
        icon.tintColor = state ? .black : .overlay
    }
}
