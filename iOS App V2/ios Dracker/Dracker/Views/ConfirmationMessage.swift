import UIKit

class ConfirmationMessage: UIView {
    
    fileprivate let widthMultiplier: CGFloat = 0.70
    fileprivate let blurPadding: CGFloat = 20
    private var blurHeight: CGFloat = 0
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width * widthMultiplier - blurPadding, height: .greatestFiniteMagnitude))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 15.0)
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(image: UIImage, message: String) {
        super.init(frame: UIScreen.main.bounds)
        imageView.image = image
        textLabel.text = message
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBlur() {
        addSubview(blurView)
        centerY(item: blurView)
        centerX(item: blurView)
        blurView.widthAnchor.constraint(equalToConstant: frame.width * widthMultiplier).isActive = true
        blurHeight += blurPadding
    }
    
    fileprivate func setupImageView() {
        blurView.contentView.addSubview(imageView)
        blurView.contentView.centerX(item: imageView)
        imageView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: blurPadding/2).isActive = true
        imageView.sizeToFit()
        blurHeight += imageView.frame.height
    }
    
    fileprivate func setupTextLabel() {
        blurView.contentView.addSubview(textLabel)
        blurView.contentView.centerX(item: textLabel)
        textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        textLabel.sizeToFit()
        blurHeight += textLabel.frame.height + 5
    }
    
    fileprivate func setup() {
        backgroundColor = .clear
        setupBlur()
        setupImageView()
        setupTextLabel()
        //Set Height to View
        blurView.heightAnchor.constraint(equalToConstant: blurHeight).isActive = true
    }
}
