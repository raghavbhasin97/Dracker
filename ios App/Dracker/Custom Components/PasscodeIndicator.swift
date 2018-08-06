import UIKit

@IBDesignable class PasscodeIndicator: UIStackView {
    
    //MARK: Properties
    private var circles = [UIView]()
    @IBInspectable var highlighted: Int = 0 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var length: Int = 4 {
        didSet {
            setup()
        }
    }
    @IBInspectable var size: CGFloat = 15.0 {
        didSet {
            setup()
        }
    }
    
    //MARK: View functions
    fileprivate func setup() {
        //Clear view
        for circle in circles {
            removeArrangedSubview(circle)
            circle.removeFromSuperview()
        }
        circles.removeAll()
        //Add views
        alignment = .center
        distribution = .fillProportionally
        for _ in 0..<length {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
            view.widthAnchor.constraint(equalToConstant: size).isActive = true
            view.clipsToBounds = true
            view.layer.cornerRadius = size/2
            view.layer.borderWidth = 2.0
            view.layer.borderColor = UIColor.theme.cgColor
            addArrangedSubview(view)
            circles.append(view)
            setCustomSpacing(10, after: view)
        }
    }
    
    fileprivate func update() {
        for i in 0..<length {
            circles[i].backgroundColor = .white
        }
        for i in 0..<highlighted {
            circles[i].backgroundColor = .theme
        }
    }
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
