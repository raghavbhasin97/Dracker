import UIKit

class SettingHeader: UIView {

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 15.0)
        label.textColor = .lightBlack
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        setup()
        textLabel.text = title.uppercased()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTextLabel() {
        addSubview(textLabel)
        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12.5).isActive = true
    }
    
    fileprivate func setup() {
        backgroundColor = .lighterGray
        setupTextLabel()
    }

}
