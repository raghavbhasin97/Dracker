import UIKit

class FriendsCell: BaseTableViewCell {
    
    let profile_size: CGFloat = 50.0
    lazy var profile_image: ActivityImageView = {
        let image_view = ActivityImageView()
        image_view.contentMode = .scaleAspectFill
        image_view.clipsToBounds = true
        image_view.translatesAutoresizingMaskIntoConstraints = false
        image_view.layer.cornerRadius = profile_size/2
        image_view.image = UIImage(named: "default_profile")
        return image_view
    }()
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 18)!
        label.textColor = .text_color
        return label
    }()
    
    let handle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .text_color
        return label
    }()
    
    let ammount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    
    override func setup() {
        addSubview(profile_image)
        addSubview(name)
        addSubview(handle)
        addSubview(ammount)
        addConstraintsWithFormat(format: "H:|-15-[v0(\(profile_size))]-10-[v1]", views: profile_image, name)
        center_Y(item: profile_image)
        profile_image.heightAnchor.constraint(equalToConstant: profile_size).isActive = true
        addConstraintsWithFormat(format: "V:|-15-[v0][v1]", views: name, handle)
        handle.leftAnchor.constraint(equalTo: profile_image.rightAnchor, constant: 10).isActive = true
        center_Y(item: ammount)
        addConstraintsWithFormat(format: "H:[v0]-20-|", views: ammount)
    }
    
    func create_view(data: Friends) {
        name.text = data.name
        handle.text = "@" + data.phone
        profile_image.init_from_S3(key: data.uid!, bucket_name: .profiles)
        ammount.text = data.amount.as_amount()
        if data.amount < 0{
            ammount.textColor = .delete_action
        } else if data.amount == 0 {
            ammount.textColor = .theme
        } else {
            ammount.textColor = .settle_action
        }
    }
}
