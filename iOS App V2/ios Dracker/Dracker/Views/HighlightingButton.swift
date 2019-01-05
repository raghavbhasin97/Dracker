import UIKit

class HighlightingButton: UIButton {
    private var color: UIColor!
    private var background: UIColor!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = color
                imageView?.tintColor = background
                setTitleColor(.white, for: .normal)
            } else {
                backgroundColor = background
                imageView?.tintColor = color
                setTitleColor(color, for: .normal)
            }
        }
    }
    
    convenience init(color: UIColor, background: UIColor = .white) {
        self.init()
        self.color = color
        self.background = background
        adjustsImageWhenHighlighted = false
        setTitleColor(color, for: .normal)
        imageView?.tintColor = color
        contentHorizontalAlignment = .left
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    }
}
