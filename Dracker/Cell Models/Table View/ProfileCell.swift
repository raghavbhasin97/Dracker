import UIKit

class ProfileCell: BaseTableViewCell {
    let option_label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "ArialHebrew-Light", size: 19)!
        return label
    }()
    
    let option_imgage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override func setup() {
        addSubview(option_label)
        addSubview(option_imgage)
        center_Y(item: option_imgage)
        center_Y(item: option_label)
        option_imgage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        addConstraintsWithFormat(format: "H:|-20-[v0(32)]-40-[v1]-40-|", views: option_imgage, option_label)
    }
    
    func set_option(title: String, image: String) {
        option_label.text = title
        option_imgage.image = UIImage(named: image)
    }
}
