import UIKit

class WalletHeader: UICollectionReusableView {
    
    fileprivate let padding: CGFloat = 30
    fileprivate let spacing: CGFloat = 10
    var cardWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var debitCard: Card = {
        let card = Card(amount: debit, title: "Debt", color: .pay, width: cardWidth)
        return card
    }()
    
    lazy var creditCard: Card = {
        let card = Card(amount: credit, title: "Credit", color: .charge , width: cardWidth)
        return card
    }()
    
    lazy var totalCard: Card = {
        let net = credit - debit
        var symbol = net > 0 ? "↑" : "↓"
        if net == 0 {
            symbol = "—"
        }
        let card = Card(amount: abs(net), title: "Total", color: .theme , width: cardWidth, symbol: symbol)
        return card
    }()
    
    lazy var cardView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [debitCard, totalCard, creditCard])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = spacing
        return stack
    }()
    
    fileprivate func setupCardView() {
        addSubview(cardView)
        cardView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        addConstraintsWithFormat(format: "H:|-\(padding/2)-[v0]-\(padding/2)-|", views: cardView)
        centerY(item: cardView)
    }
    
    func setup() {
        backgroundColor = .white
        cardWidth = (frame.width - ( 2 * padding) - (2 * spacing))/2
        addLine(position: .Bottom)
        setupCardView()
    }
    
    public func reloadData() {
        debitCard.update(amount: abs(debit))
        creditCard.update(amount: abs(credit))
        let net = credit - debit
        var symbol = net > 0 ? "↑" : "↓"
        if net == 0 {
            symbol = "—"
        }
        totalCard.update(amount: abs(net), symbol: symbol)
    }
}
