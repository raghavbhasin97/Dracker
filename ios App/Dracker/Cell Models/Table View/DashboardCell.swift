import UIKit

class DashboardCell: BaseTableViewCell {
    
    let profile_image: ActivityImageView = {
        let image_view = ActivityImageView()
        image_view.contentMode = .scaleAspectFill
        image_view.clipsToBounds = true
        image_view.translatesAutoresizingMaskIntoConstraints = false
        image_view.layer.cornerRadius = 31
        image_view.image = UIImage(named: "default_profile")
        return image_view
    }()
    
    let phone_handel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.init(name: "Arial", size: 10.0)
        label.textColor = .text_color
        return label
    }()
    
    let title_text: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: "Arial", size: 17.0)
        label.textColor = .text_color
        return label
    }()
    
    let description_text: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.init(name: "Arial", size: 16.0)
        label.numberOfLines = 1
        return label
    }()
    
    let time_indicator: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.init(name: "Arial", size: 10.0)
        return label
    }()
    

    
    //Constraints top, bottom, left, right
    override func setup() {
        super.setup()
        //Add items
        addSubview(profile_image)
        addSubview(phone_handel)
        addSubview(title_text)
        addSubview(description_text)
        addSubview(time_indicator)
        
        //Constraints
        //Horizontal
        addConstraintsWithFormat(format: "H:|-15-[v0(62)]-10-[v1]|", views: profile_image, title_text)
        addConstraintsWithFormat(format: "H:|-10-[v0(70)]-18-[v1(200)]", views: phone_handel, description_text)
        addConstraintsWithFormat(format: "H:[v0(120)]-16-|", views: time_indicator)
        //Vertical
        addConstraintsWithFormat(format: "V:|-16-[v0(62)]-5-[v1(20)]|", views: profile_image, phone_handel)
        profile_image.heightAnchor.constraint(equalToConstant: 62.0).isActive = true
        addConstraintsWithFormat(format: "V:|-16-[v0(22)]-10-[v1(20)]", views: title_text,description_text)
        addConstraintsWithFormat(format: "V:[v0(20)]|", views: time_indicator)
    }
    
    func load_cell(data: Unsettled) {
        phone_handel.text = "@" + data.phone
        description_text.text = data.description
        profile_image.stop_downloading()
        profile_image.init_from_S3(key: data.uid, bucket_name: .profiles) {[unowned self] in
            self.profile_image.stop_downloading()
        }
        time_indicator.text = data.time.as_date(format: .full).as_string_timetrack()
        if data.is_debt {
            self.title_text.text = "You owe \(data.name) " + (Double(data.amount)?.as_amount())!
        } else {
            self.title_text.text = "\(data.name) owes you " + (Double(data.amount)?.as_amount())!
        }
    }
}
