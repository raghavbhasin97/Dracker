import UIKit
import LinkKit

class BankAccount: UIViewController {
    //MARK: Data Fields
    var accounts_list: [Account] = []
    let ID = "AccountsCell"
    let phone = UserDefaults.standard.object(forKey: "phone") as! String
    
    let cover: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    var activty: UIActivityIndicatorView? = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.color = .red
        return activity
    }()
    
    //MARK: Components
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.text = "Bank Accounts"
        return title
    }()
    
    let button_container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Link New Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.65), for: .highlighted)
        button.backgroundColor = .theme
        button.addTarget(self, action: #selector(attach_bank_account), for: .touchUpInside)
        return button
    }()
    
    lazy var accounts_view: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .bank_back
        table.tableFooterView = UIView()
        table.rowHeight = 60.0
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.addSubview(cover)
        cover.frame = view.frame
        view.addSubview(activty!)
        activty?.startAnimating()
        activty?.center = view.center
        get_accounts(phone: phone) {[unowned self] (res) in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.activty?.alpha = 0.0
                self.cover.alpha = 0.0
            }, completion: { (_) in
                self.cover.removeFromSuperview()
                self.activty?.removeFromSuperview()
            })
            if res.isFailure {
                present_alert_error(message: .no_internet, target: self)
            }
            let data = res.value as! [String: Any]
            let message = data["message"] as! String
            if message == "ERROR" {
                return
            } else {
                let accounts_string = (data["list"] as? String)?.data(using: .utf8)!
                do {
                    self.accounts_list = try JSONDecoder().decode([Account].self, from: accounts_string!)
                } catch {
                    //Should never happen
                }
                self.accounts_view.reloadData()
            }
        }
    }

    fileprivate func setup_graphics() {
        view.backgroundColor = .bank_back
        navigationItem.titleView = navigation_title
    }
    
    fileprivate func setup_table() {
        view.addSubview(accounts_view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: accounts_view)
    }
    
    fileprivate func setup_button() {
        button_container.addSubview(button)
        button_container.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: button)
        button_container.center_Y(item: button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.clipsToBounds = true
        button.layer.cornerRadius = 5.0
    }
    
    fileprivate func setup_container() {
        view.addSubview(button_container)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: button_container)
        let shadow    = #colorLiteral(red: 0.01176470588, green: 0.1921568627, blue: 0.337254902, alpha: 0.1)
        button_container.layer.shadowColor   = shadow.cgColor
        button_container.layer.shadowOffset  = CGSize(width: 0, height: -1)
        button_container.layer.shadowRadius  = 2
        button_container.layer.shadowOpacity = 1
        setup_button()
    }
    
    fileprivate func setup() {
        accounts_view.register(AccountCell.self, forCellReuseIdentifier: ID)
        setup_graphics()
        setup_table()
        setup_container()
        view.addConstraintsWithFormat(format: "V:|[v0][v1(110)]|", views: accounts_view, button_container)
    }
    
    @objc func attach_bank_account() {
        present_plaid()
    }
    
    func present_plaid() {
        let linkViewDelegate = self
        let controller = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            controller.modalPresentationStyle = .formSheet;
        }
        present(controller, animated: true)
    }

}

//MARK: TableView datasource and delegates

extension BankAccount : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = accounts_view.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! AccountCell
        let account = accounts_list[indexPath.row]
        cell.setup(account: account)
        if account.is_default {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accounts_list[indexPath.row]
        clear_selected()
        set_default_account(phone: phone, url: account.url)
        let cell = accounts_view.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    fileprivate func clear_selected() {
        for row in 0..<accounts_list.count {
            let cell = accounts_view.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.accessoryType = .none
        }
    }
}

extension BankAccount : PLKPlaidLinkViewDelegate {
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            loading(target: self, completion: {[unowned self] (_) in
                let account = metadata?["account"] as! [String: String]
                let institution = metadata?["institution"] as! [String: String]
                put_funding_source(token: publicToken, account_id: account["id"]!, phone: self.phone, name: account["name"]!, institution_name: institution["name"]!, completion: {[unowned self] (data) in
                    if data.isFailure {
                        return
                    }
                    stop_loading()
                    let response = data.value as! [String: Any]
                    let message = response["message"] as! String
                    if message == "SUCCESS" {
                        let url = response["url"] as! String
                        let account = Account(name: account["name"]!, institution: institution["name"]!, url: url, is_default: false)
                        self.accounts_list.append(account)
                        self.accounts_view.beginUpdates()
                        self.accounts_view.insertRows(at: [IndexPath(row: self.accounts_list.count, section: 0)], with: .automatic)
                        self.accounts_view.endUpdates()
                    } else {
                        if let code = response["code"] {
                            if (code as! String) == "DuplicateResource" {
                                present_alert_error(message: .duplicate_bank_account, target: self)
                            }
                        } else {
                            present_alert_error(message: .funding_error, target: self)
                        }
                    }
                })
            })
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if error != nil {
                present_alert_error(message: .funding_error, target: self)
            }
        }
    }
}
