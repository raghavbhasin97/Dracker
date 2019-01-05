import UIKit

class Home: BaseViewController {
    
    fileprivate let cellId = "HomeCell"
    fileprivate let emptyCellId = "EmptyHomeCell"
    
    let spinner = Spinner(type: .ballPulse, color: .theme)
    let refreshAction: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.tintColor = UIColor.theme.withAlphaComponent(0.70)
        refreshControll.addTarget(self, action: #selector(refreshPulled), for: .allEvents)
        return refreshControll
    }()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        label.text = "Home"
        return label
    }()
    
    lazy var unsettledTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.register(HomeCell.self, forCellReuseIdentifier: cellId)
        table.register(EmptyHomeCell.self, forCellReuseIdentifier: emptyCellId)
        table.refreshControl = refreshAction
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    fileprivate func setupTable() {
        view.addSubview(unsettledTable)
        unsettledTable.fillSuperview()
    }
    
    fileprivate func addLoader() {
        view.addSubview(spinner)
        spinner.fillSuperview()
        spinner.startAnimating()
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        registerForPreviewing(with: self, sourceView: view)
        setupTable()
        addLoader()
        getUserTransactions(currentUser.uid) {[unowned self] (res) in
            parseUserData(data: res)
            self.unsettledTable.reloadData()
            getOverview(currentUser.uid, {[unowned self] (res) in
                parseOverviewData(data: res)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {[unowned self] in
                    self.spinner.stopAnimating()
                })
            })
        }
    }
    
    @objc fileprivate func refreshPulled() {
        refreshAction.endRefreshing()
        getUserTransactions(currentUser.uid) {[unowned self] (res) in
            parseUserData(data: res)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.unsettledTable.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("updateWallet"), object: nil)
            })
        }
    }
}

extension Home: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(1, unsettledTransactions.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if unsettledTransactions.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellId, for: indexPath) as! EmptyHomeCell
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeCell
        cell.item = unsettledTransactions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if unsettledTransactions.count == 0 {
            tableView.separatorStyle = .none
            return tableView.frame.height - 100
        }
        tableView.separatorStyle = .singleLine
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if unsettledTransactions.count == 0 { return }
        let item = unsettledTransactions[indexPath.row]
        let controller = Transaction(item: item)
        controller.index = indexPath.row
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension Home: TransactionDelegate {
    func settle(at: Int) {
        let item = unsettledTransactions[at]
        debit -= item.amount
        deleteRowAt(at)
        settledTransactions.insert(item.settle(), at: 0)
        NotificationCenter.default.post(name: NSNotification.Name("updateWallet"), object: nil)
    }
    
    func delete(at: Int) {
        let item = unsettledTransactions[at]
        credit -= item.amount
        deleteRowAt(at)
        NotificationCenter.default.post(name: NSNotification.Name("updateWallet"), object: nil)
    }
    
    fileprivate func deleteRowAt(_ index: Int) {
        unsettledTransactions.remove(at: index)
        unsettledTable.reloadData()
    }
}

extension Home: emptyCellAction {
    func performAction() {
        let add = Add()
        add.delegate = self
        let controller = UINavigationController(rootViewController:  add)
        present(controller, animated: true, completion: nil)
    }
}

extension Home: AddTransactionDelegate {
    func addedTransaction(item: Unsettled) {
        unsettledTransactions.insert(item, at: 0)
        unsettledTable.reloadData()
        if item.isDebt {
            debit += item.amount
        } else {
            credit += item.amount
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("updateWallet"), object: nil)
    }
}

//Previewing Context
extension Home: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let adjustedY = location.y + unsettledTable.bounds.origin.y
        if let index = unsettledTable.indexPathForRow(at: CGPoint(x: location.x, y: adjustedY)) {
            let item = unsettledTransactions[index.row]
            let controller = Transaction(item: item)
            controller.index = index.row
            controller.delegate = self
            return controller
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}
