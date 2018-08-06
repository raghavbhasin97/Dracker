import UIKit
import DZNEmptyDataSet

class Wallet: UIView {
    
    let ID = "WalletCell"
    let multiplier: CGFloat = 0.62068965517
    let dim_multipler: CGFloat = 7.27
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 35)!
        label.textColor = .white
        return label
    }()
    
    let symbol: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "symbol"))
        return image
    }()
    
    let card: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "back"))
        image.layer.cornerRadius = 10.0
        image.clipsToBounds = true
        return image
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialHebrew-Light", size: 15)!
        label.textColor = UIColor.white.withAlphaComponent(0.78)
        label.text = "ACCOUNT BALANCE"
        return label
    }()
    
    let amount_tag: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialHebrew", size: 12)!
        label.textColor = UIColor.white.withAlphaComponent(0.78)
        return label
    }()
    
    let debit_amount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 18)!
        label.textColor = UIColor.white.withAlphaComponent(0.72)
        return label
    }()
    
    let debitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialHebrew", size: 10)!
        label.textColor = UIColor.white.withAlphaComponent(0.72)
        label.text = "DEBT↓"
        return label
    }()
    
    let credit_amount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 18)!
        label.textColor = UIColor.white.withAlphaComponent(0.72)
        return label
    }()
    
    let creditLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialHebrew", size: 10)!
        label.textColor = UIColor.white.withAlphaComponent(0.72)
        label.text = "CREDIT↑"
        return label
    }()
    
    lazy var transaction_view: UICollectionView = {
        let collections = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        collections.register(WalletCell.self, forCellWithReuseIdentifier: ID)
        collections.dataSource = self
        collections.delegate = self
        collections.emptyDataSetSource = self
        collections.emptyDataSetDelegate = self
        collections.backgroundColor = .white
        collections.showsVerticalScrollIndicator = false
        collections.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        return collections
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup_card() {
        //Setup Card view
        addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: card)
        let width = ((UIApplication.shared.keyWindow?.frame.width)! - 60.0)
        let height = width * multiplier
        addConstraintsWithFormat(format: "V:|-30-[v0(\(height))]-10-[v1]-80-|", views: card, transaction_view)
        card.addSubview(symbol)
        card.addSubview(label)
        card.addSubview(title)
        card.addSubview(amount_tag)
        card.addSubview(debit_amount)
        card.addSubview(credit_amount)
        debit_amount.addSubview(debitLabel)
        credit_amount.addSubview(creditLabel)
        let profile_dim = width/dim_multipler
        card.addConstraintsWithFormat(format: "H:[v0(\(profile_dim))]-12-|", views: symbol)
        card.addConstraintsWithFormat(format: "V:|-6-[v0(\(profile_dim))]", views: symbol)
        card.addConstraintsWithFormat(format: "H:|-20-[v0]-5-[v1]", views: label,amount_tag)
        card.addConstraintsWithFormat(format: "H:|-20-[v0]", views: title)
        card.addConstraintsWithFormat(format: "V:|-50-[v0]-2-[v1]", views: title, label)
        amount_tag.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: -4).isActive = true
        card.addConstraintsWithFormat(format: "H:|-20-[v0]", views: debit_amount)
        debit_amount.center_X(item: debitLabel)
        credit_amount.center_X(item: creditLabel)
        debit_amount.addConstraintsWithFormat(format: "V:|-20-[v0(20)]", views: debitLabel)
        credit_amount.addConstraintsWithFormat(format: "V:|-20-[v0(20)]", views: creditLabel)
        card.addConstraintsWithFormat(format: "H:[v0]-20-|", views: credit_amount)
        card.addConstraintsWithFormat(format: "V:[v0]-33.75-|", views: debit_amount)
        card.addConstraintsWithFormat(format: "V:[v0]-33.75-|", views: credit_amount)
    }
    
    fileprivate func setup() {
        
        addSubview(card)
        addSubview(transaction_view)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: transaction_view)
        setup_card()
    }
    func setup_data() {
        let balance = credit - debit
        label.text = balance.as_amount()
        if balance < 0 {
            amount_tag.text = "DEBT"
        } else {
            amount_tag.text = "CREDIT"
        }
        debit_amount.text = debit.as_amount()
        credit_amount.text = credit.as_amount()
    }
    
    func create_view() {
        setup()
        setup_data()
        transaction_view.reloadData()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        setup_data()
        transaction_view.reloadData()
    }
}

//MARK: Collection View
extension Wallet: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(settled_transactions.count, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = transaction_view.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! WalletCell
        if indexPath.row < settled_transactions.count {
            cell.create_view(data: settled_transactions[indexPath.row])
        }
        return cell
    }
}

//MARK: Collection View Flow Layout
extension Wallet: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 40, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension Wallet: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return settled_transactions.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: "No history!", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "Your have not settled any transactions yet.", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty_wallet")
    }
}
