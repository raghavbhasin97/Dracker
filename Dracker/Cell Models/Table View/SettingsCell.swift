import UIKit

class SettingsCell: BaseTableViewCell {
    
    let item_image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: "ArialHebrew-Light", size: 19)!
        return label
    }()
    
    override func setup() {
        super.setup()
        addSubview(item_image)
        addSubview(label)
        addConstraintsWithFormat(format: "H:|-30-[v0(35)]-20-[v1]", views: item_image, label)
        center_Y(item: item_image)
        center_Y(item: label)
        item_image.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func create_view(data: SettingData) {
        item_image.image = UIImage(named: data.image)
        label.text = data.title
    }
}
