import UIKit
import DZNEmptyDataSet
import UserNotifications

class Notification: UIViewController {
    
    let ID = "NotificationsCell"
    var data:[String] = []
    lazy var notifications: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.allowsSelection = false
        table.rowHeight = 80.0
        return table
    }()
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.text = "Notifications"
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        get_data()
        UIApplication.shared.applicationIconBadgeNumber = 0
        navigationItem.titleView = navigation_title
        notifications.register(UITableViewCell.self, forCellReuseIdentifier: ID)
        view.addSubview(notifications)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: notifications)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: notifications)
    }
    
    fileprivate func get_data() {
        data = []
        UNUserNotificationCenter.current().getPendingNotificationRequests {[unowned self] (list)
            in
            for item in list {
                self.data.append(item.content.body)
            }
            execute_on_main {[unowned self] in
                self.notifications.reloadData()
            }
        }
    }
}

//MARK: Table data and functions
extension Notification: UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notifications.dequeueReusableCell(withIdentifier: ID, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return data.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: "No Notifications!", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "Your have no pending notifications.", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "alerts")
    }
}
