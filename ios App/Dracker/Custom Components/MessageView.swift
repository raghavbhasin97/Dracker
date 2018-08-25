import UIKit

class MessageView: UIView {
    //MARK: Required init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Fields - Constants
    let image_size_multiplier: CGFloat = 0.12
    let height_multiplier: CGFloat = 0.16
    let width_adjustment: CGFloat = 125.0
    let padding_multiplier: CGFloat = 0.0133333333
    
    //MARK: Fields - Subviews
    let blur_view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let text_label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 15.0)
        return label
    }()
    let image_view: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //MARK: Initializer
    init(superView_frame: CGRect, center: CGPoint, text: String, image: UIImage) {
        //Setup Self
        super.init(frame: CGRect(x: 0, y: 0, width: superView_frame.width - width_adjustment, height: superView_frame.height * height_multiplier))
        backgroundColor = .clear
        layer.cornerRadius = 15.0
        clipsToBounds = true
        self.center = center
        //Setup blur view
        addSubview(blur_view)
        addConstraintsWithFormat(format: "H:|[v0]|", views: blur_view)
        addConstraintsWithFormat(format: "V:|[v0]|", views: blur_view)
        //Setup Image
        let image_size: CGFloat = image_size_multiplier * superView_frame.width
        addSubview(image_view)
        image_view.frame = CGRect(x: (frame.width - image_size)/2, y: padding_multiplier * superView_frame.width, width: image_size, height: image_size)
        //Setup Label
        addSubview(text_label)
        addConstraintsWithFormat(format: "H:|[v0]|", views: text_label)
        text_label.topAnchor.constraint(equalTo: image_view.bottomAnchor, constant: 2 * padding_multiplier * superView_frame.width).isActive = true
        //Setup fields
        text_label.text = text
        image_view.image = image
    }

}
