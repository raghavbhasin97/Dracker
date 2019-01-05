import UIKit

class Card: UIView {

    var amountFontSize: CGFloat = 24
    
    init(amount: Double, title: String, color: UIColor, width: CGFloat, symbol: String? = nil) {
        super.init(frame: .zero)
        backgroundColor = color
        determineFontSize(amount: amount, width: width)
        setup()
        titleLabel.text = title
        amountLabel.text = amount.asAmount()
        if(symbol != nil) {
            setupSymbol()
            symbolLabel.text = symbol!
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.addLine(position: .Top)
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12 , weight: .bold)
        label.textAlignment = .center
        label.addLine(position: .Top)
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: amountFontSize, weight: .bold)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupTitleLabel() {
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: titleLabel)
    }
    
    fileprivate func setupAmountLabel() {
        addSubview(amountLabel)
        centerX(item: amountLabel)
        centerY(item: amountLabel, constant: -20)
    }
    
    fileprivate func setup() {
        setupTitleLabel()
        setupAmountLabel()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.drBlack.withAlphaComponent(0.5).cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
    
    fileprivate func determineFontSize(amount: Double, width: CGFloat) {
        let testLabel = UILabel()
        testLabel.text = amount.asAmount()
        testLabel.sizeToFit()
        if testLabel.frame.width > width / 2 {
            let ratio = testLabel.frame.width/width
            amountFontSize *= ratio
        }
    }
    
    fileprivate func setupSymbol() {
        addSubview(symbolLabel)
        centerX(item: symbolLabel)
        symbolLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor).isActive = true
    }

    public func update(amount: Double, symbol: String? = nil) {
        amountLabel.text = amount.asAmount()
        if(symbol != nil) {
            setupSymbol()
            symbolLabel.text = symbol!
        }
    }
}


