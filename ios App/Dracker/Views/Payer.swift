import UIKit
import DZNEmptyDataSet

class Payer: UIView {
    
    let ID = "PayerCell"
    weak var parent: AddTransaction?
    weak var first_responder: UITextField?
    var users_list: [User] = []
    var filtered_users_list: [User] = []
    let current_uid = UserDefaults.standard.object(forKey: "uid") as! String
    
    lazy var navigation: UINavigationBar = {
        let bar = UINavigationBar()
        bar.isTranslucent = false
        bar.tintColor = .white
        return bar
    }()
    
    lazy var search: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = false
        search.definesPresentationContext = false
        search.searchBar.isTranslucent = true
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Phone number"
        search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.keyboardType = .phonePad
        return search
    }()
    
    let status_bar: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        return view
    }()
    
    lazy var users: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.register(UserCell.self, forCellReuseIdentifier: ID)
        table.rowHeight = 50.0
        table.tableFooterView = UIView()
        return table
    }()
    
    let search_view: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        backgroundColor = .white
        addSubview(navigation)
        addSubview(status_bar)
        addSubview(users)
        addSubview(search_view)
        let height = UIApplication.shared.statusBarFrame.height
        addConstraintsWithFormat(format: "H:|[v0]|", views: navigation)
        addConstraintsWithFormat(format: "H:|[v0]|", views: search_view)
        addConstraintsWithFormat(format: "H:|[v0]|", views: users)
        addConstraintsWithFormat(format: "H:|[v0]|", views: status_bar)
        addConstraintsWithFormat(format: "V:|-\(height)-[v0][v1(50)]-5-[v2]|", views: navigation, search_view ,users)
        addConstraintsWithFormat(format: "V:|[v0(\(height))]", views: status_bar)
        search_view.addSubview(search.searchBar)
        search.searchBar.sizeToFit()
        let phone = UserDefaults.standard.object(forKey: "phone") as! String
        get_users_phone(phone: phone) {[unowned self] (data) in
            if data.isFailure {
                return
            }
            self.users_list = []
            let users = data.value as! [[String: Any]]
            for user in users {
                let name = user["name"] as! String
                let phone = user["phone"] as! String
                let uid = user["uid"] as! String
                if uid == self.current_uid {
                    continue
                }
                let new_user = User(phone: phone, name: name, uid: uid)
                self.users_list.append(new_user)
            }
            execute_on_main {
                self.users.reloadData()
            }
        }
    }
    
    @objc fileprivate func send_back() {
        search.dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layer.transform = CATransform3DMakeTranslation(0, self.frame.height, 0)
        }){[unowned self] (_) in
            self.first_responder?.becomeFirstResponder()
            self.parent?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.parent?.navigationController?.navigationBar.isUserInteractionEnabled = true
            self.parent?.navigationItem.setHidesBackButton(false, animated: true)
            self.parent?.add_button.isEnabled = true
            self.removeFromSuperview()
        }
    }
}
//MARK: Table datasource and delegate
extension Payer: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.isActive {
            return min(filtered_users_list.count, 40)
        } else {
            return min(users_list.count, 40)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = users.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! UserCell
        if search.isActive {
            cell.load_cell(data: filtered_users_list[indexPath.row])
        } else {
            cell.load_cell(data: users_list[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var user: User
        if search.isActive {
            user = filtered_users_list[indexPath.row]
        } else {
            user = users_list[indexPath.row]
        }
        if user.uid == "" {
            search.dismiss(animated: true) {[unowned self] in
                self.search.searchBar.text = ""
                let share_text = "Hey! Thought you would enjoy Dracker. It's an easy to use app to send/receive money and track debt. "
                let share_url = URL(string: "https://github.com/raghavbhasin97/Dracker")!
                let share_activity = UIActivityViewController(activityItems: [share_text, share_url], applicationActivities: [])
                share_activity.excludedActivityTypes = [.addToReadingList, .assignToContact, .print, .saveToCameraRoll]
                let parent = UIApplication.shared.keyWindow?.rootViewController
                parent?.present(share_activity, animated: true, completion: nil)
            }
            return
        }
        parent?.phone_button.setTitle("@" + user.phone, for: .normal)
        parent?.others_name = user.name
        parent?.others_uid = user.uid
        parent?.navigation_title.text = "Add Transaction"
        send_back()
    }
}

//MARK: Filtering
extension Payer: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text!
        if text.isEmpty || text == "" {
            filtered_users_list = users_list
            execute_on_main {
                self.users.reloadData()
            }
        } else {
            get_users_search(search: text) {[unowned self] (data) in
                if data.isFailure {
                    return
                }
                
                self.filtered_users_list = []
                let users = data.value as! [[String: Any]]
                if users.isEmpty && valid_phone(phone: text) {
                    let new_user = User(phone: text, name: "Invite " + text + " to Dracker", uid: "")
                    self.filtered_users_list = [new_user]
                }
                
                for user in users {
                    let name = user["name"] as! String
                    let phone = user["phone"] as! String
                    let uid = user["uid"] as! String
                    if uid == self.current_uid {
                        continue
                    }
                    let new_user = User(phone: phone, name: name, uid: uid)
                    self.filtered_users_list.append(new_user)
                }
                execute_on_main {
                    self.users.reloadData()
                }
            }
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        users.reloadData()
    }
}

//MARK: Empty Table datasource and delegate
extension Payer: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !reachable()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: "Network Issue!", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "There was an error fetching users. Please check your network connection.", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no_users")
    }
}
