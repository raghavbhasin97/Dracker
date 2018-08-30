import UIKit

class ShareButton: UIButton {
    let image_size: CGFloat = 20
    var selected_color: UIColor = .black
    var unselected_color: UIColor = .black
    var background_selected: UIColor = .black
    let text: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    init(image: UIImage, text: String, selected_color: UIColor, unselected_color: UIColor, bacground_selected: UIColor) {
        super.init(frame: .zero)
        self.image.image = image.withRenderingMode(.alwaysTemplate)
        self.image.tintColor = .text_color
        self.text.text = text
        self.unselected_color = unselected_color
        self.selected_color = selected_color
        self.text.textColor = unselected_color
        self.image.tintColor = unselected_color
        self.background_selected = bacground_selected
        setup()
    }
    
    fileprivate func setup() {
        backgroundColor = .clear
        //Setup Title
        addSubview(text)
        addConstraintsWithFormat(format: "V:|[v0]|", views: text)
        center_X(item: text, constant: 12.5)
        
        //Setup Image
        addSubview(image)
        image.heightAnchor.constraint(equalToConstant: image_size).isActive = true
        image.widthAnchor.constraint(equalToConstant: image_size).isActive = true
        image.rightAnchor.constraint(equalTo: text.leftAnchor, constant: -7.5).isActive = true
        addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? background_selected : .clear
            text.textColor = isHighlighted ? selected_color : unselected_color
            image.tintColor = isHighlighted ? selected_color : unselected_color
        }
    }
}
