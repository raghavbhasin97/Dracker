import UIKit

class PasscodeButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .theme : .white
        }
    }
    
    init(value: Int) {
        super.init(frame: .zero)
        setTitle(String(value), for: .normal)
        setTitleColor(.text_color, for: .normal)
        setTitleColor(.white, for: .highlighted)
        clipsToBounds = true
        titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-UltraLight", size: 45)!
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.text_color.cgColor
    }
}

