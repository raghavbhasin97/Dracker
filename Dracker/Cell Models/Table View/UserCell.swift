import UIKit

class UserCell: BaseTableViewCell {
    
    let profile: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "default_profile"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 17.5
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .text_color
        label.font = .systemFont(ofSize: 15.0)
        return label
    }()

    override func setup() {
        super.setup()
        addSubview(profile)
        addSubview(name)
        center_Y(item: profile)
        center_Y(item: name)
        addConstraintsWithFormat(format: "H:|-20-[v0(35)]-20-[v1]", views: profile, name)
        profile.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func load_cell(data: User) {
        profile.init_from_S3(key: data.uid, bucket_name: .profiles)
        name.text = data.name
    }
}
