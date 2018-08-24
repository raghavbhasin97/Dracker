import UIKit
import DZNEmptyDataSet

class Contacts: UIViewController {
    let ID = "ContactsCell"
    let background_blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    var activty: UIActivityIndicatorView? = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.color = .red
        return activity
    }()
    
    fileprivate func loading() {
        //Add Loading logic
        let window = UIScreen.main.bounds
        view.addSubview(background_blur)
        view.addSubview(activty!)
        background_blur.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activty?.center = CGPoint(x: window.width/2, y: window.height/2)
        activty?.startAnimating()
    }
    
    fileprivate func stop_loading() {
        activty?.stopAnimating()
        activty?.removeFromSuperview()
        activty = nil
        background_blur.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let user_id = UserDefaults.standard.object(forKey: "uid") as! String
        loading()
        authorize {[unowned self] in
            fetch_friends(user_id: user_id) {[unowned self] in
                self.setup()
                self.stop_loading()
                execute_on_main {
                    self.friends_table.reloadData()
                }
            }
        }
    }
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.text = "Friends"
        return title
    }()
    
    lazy var friends_table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.tableFooterView = UIView()
        table.rowHeight = 70.0
        return table
    }()
    
    fileprivate func setup() {
        navigationItem.titleView = navigation_title
        friends_table.register(FriendsCell.self, forCellReuseIdentifier: ID)
        view.addSubview(friends_table)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: friends_table)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: friends_table)
    }
}

//MARK: Table Datasource and delegates
extension Contacts: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friends_table.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! FriendsCell
        let data = friends[indexPath.row]
        cell.create_view(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        let controller = FriendDetail()
        controller.uid = friend.uid
        controller.name = friend.name
        controller.amount = friend.amount
        controller.phone = friend.phone
        controller.transactions_list = friend.transactions
        controller.setup_data()
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: Empty Datasource and delegates
extension Contacts: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return friends.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: "No Summary!", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "Nothing to see here. Start dracking to see a summary... ", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "friend")
    }
}
