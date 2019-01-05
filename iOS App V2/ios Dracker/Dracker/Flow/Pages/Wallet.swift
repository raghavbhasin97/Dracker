import UIKit

class Wallet: BaseViewController {

    let cellId = "WalletCell"
    let headerId = "WalletHeader"
    let emptyCellId = "EmptyWalletCell"
    var headerView: WalletHeader?
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        label.text = "Wallet"
        return label
    }()
    
    lazy var walletView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WalletCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyWalletCell.self, forCellWithReuseIdentifier: emptyCellId)
        collectionView.register(WalletHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    fileprivate func setupWalletView() {
        view.addSubview(walletView)
        walletView.fillSuperview()
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        setupWalletView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateWallet), name: NSNotification.Name(rawValue: "updateWallet"), object: nil)
    }
    
    @objc fileprivate func updateWallet() {
        walletView.reloadData()
        headerView?.reloadData()
    }
}

extension Wallet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(1, settledTransactions.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if settledTransactions.count == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WalletCell
        cell.item = settledTransactions[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return unsettledTransactions.count == 0 ? CGSize(width: view.frame.width, height: 400) : CGSize(width: view.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! WalletHeader
        headerView = header
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 175)
    }
    
}
