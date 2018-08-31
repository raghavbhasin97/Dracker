import UIKit
import DZNEmptyDataSet

class HomeView: UIView {
    var parent: UIViewController?
    let Menu_height: CGFloat = 50.00
    let ID = "HomeViewCell"
    var uid: String?
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.rowHeight = 95
        table.showsVerticalScrollIndicator = false
        table.addSubview(update_action)
        table.tableFooterView = UIView()
        return table
    }()
    
    lazy var update_action: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .red
        refresh.addTarget(self, action: #selector(self.refetch_data), for: .valueChanged)
        return refresh
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        tableView.reloadData()
    }
    
    func setup() {
        tableView.register(DashboardCell.self, forCellReuseIdentifier: ID)
        addSubview(tableView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithFormat(format: "V:|[v0]-80-|", views: tableView)
        parent?.registerForPreviewing(with: self, sourceView: self)
    }

    @objc func refetch_data() {
        fetch_data(user_id: uid!) {
            execute_on_main {
                let home = self.parent as? Home
                self.tableView.reloadData()
                home?.stop_loading()
            }
        }
        self.update_action.endRefreshing()
    }
}

extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  unsettled_transactions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! DashboardCell
        cell.load_cell(data: unsettled_transactions[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = Detail()
        controller.data = unsettled_transactions[(indexPath.row)]
        controller.dahsboard = self
        controller.index = indexPath
        parent?.navigationController?.pushViewController(controller, animated: true)
    }

}

extension HomeView: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return unsettled_transactions.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: "Nothing to see!", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "Your transactions' history is empty. Add transactions to get started.", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty_transactions")
    }
}

extension HomeView: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let item = tableView.indexPathForRow(at: location)
        if item == nil { return nil }
        let controller = Detail()
        controller.data = unsettled_transactions[(item?.row)!]
        controller.dahsboard = self
        controller.index = item
        controller.note.alpha = 0.0
        previewingContext.sourceRect = (tableView.cellForRow(at: item!)?.frame)!
        return controller
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let controller = viewControllerToCommit as? Detail {
            controller.note.alpha = 1.0
        }
        parent?.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
