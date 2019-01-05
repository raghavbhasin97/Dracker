import UIKit

/**
    An implementation of UITextField that allows adding an icon on the left.
 */
class IconField: UITextField {
    
    let padding: UIEdgeInsets = UIEdgeInsets(top: 5, left: 32.5, bottom: 5, right: 2.5)
    
    let icon: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /**
      Icon Text Field initializer
     - image: icon
     - width: Width of frame
     */
    init(image: UIImage, width: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 50))
        setup(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup(_ image: UIImage) {
        addSubview(icon)
        centerY(item: icon)
        icon.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        icon.image = image
        
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
