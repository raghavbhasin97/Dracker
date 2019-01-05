import UIKit
import LinkKit

class FundingSources: BaseViewController {

    fileprivate let cellId = "fundingSourcesCell"
    fileprivate var plaid:PLKPlaidLinkViewController!
    private let spinner = Spinner(type: .ballPulse, color: .theme)
    private var editingMode = false
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Funding Sources"
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        return label
    }()
    
    lazy var fundingsTable: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
        table.register(FundingSourceCell.self, forCellReuseIdentifier: cellId)
        table.showsVerticalScrollIndicator = false
        let footer = UIView()
        footer.backgroundColor = .lightWhite
        table.backgroundColor = .clear
        table.bounces = false
        table.tableFooterView = footer
        return table
    }()
    
    fileprivate func setupTable() {
        view.addSubview(fundingsTable)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: fundingsTable)
        fundingsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        fundingsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func setup() {
        plaid = PLKPlaidLinkViewController(delegate: self)
        view.backgroundColor = .lightWhite
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "pencil"), style: .plain, target: self, action: #selector(edit))
        setupTable()
        getFindingSources(phone: currentUser.phone) {[unowned self] (res) in
            parseFundingSources(data: res)
            self.fundingsTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc fileprivate func edit() {
        editingMode = !editingMode
        fundingsTable.setEditing(editingMode, animated: true)
    }
}


extension FundingSources: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fundings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FundingSourceCell
        if indexPath.row < fundings.count {
            cell.setupSourceCell(item: fundings[indexPath.row])
        } else {
            cell.setupAdd()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < fundings.count {
            if fundings[indexPath.row].isDefault { return }
            setDefaultFundingSource(sourceURL: fundings[indexPath.row].url) {[unowned self] (succ) in
                    if succ {
                        var newFundings:[FundingSource] = []
                        for (idx, source) in fundings.enumerated() {
                            var newSource = source
                            newSource.isDefault = idx == indexPath.row
                            newFundings.append(newSource)
                        }
                        fundings = newFundings
                        self.fundingsTable.reloadData()
                        self.presentConfirmation(image: #imageLiteral(resourceName: "success"), message: "\(fundings[indexPath.row].name) set as\n new default funding source")
                    }
            }
        } else {
            present(plaid, animated: true)

        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row == fundings.count ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if indexPath.row < fundings.count {
            if fundings[indexPath.row].isDefault {
                showError(message: .defaultSourceDeleteFailed)
                return
            }
            deleteFundingSource(fundungUrl: fundings[indexPath.row].url) {[unowned self] (success) in
                    if success {
                        fundings.remove(at: indexPath.row)
                        self.edit()
                    } else {
                         self.showError(message: .sourceDeleteFailed)
                    }
            }
         }
    }
}


extension FundingSources: PLKPlaidLinkViewDelegate {
    
    fileprivate func addLoader() {
        view.addSubview(spinner)
        spinner.fillSuperview()
        spinner.startAnimating()
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true){[unowned self] in
            self.addLoader()
            guard let account = metadata?["account"] as? [String: String] else {
                self.spinner.stopAnimating()
                self.showError(message: .sourceLinkFailed)
                return
            }
            guard let institution = metadata?["institution"] as? [String: String] else {
                self.spinner.stopAnimating()
                self.showError(message: .sourceLinkFailed)
                return
            }
            let name = account["name"]!
            let accountId = account["id"]!
            let institutionName = institution["name"]!
            let params = ["phone": currentUser.phone,
                          "token": publicToken,
                          "account_id": accountId,
                          "name": name,
                          "institution_name": institutionName
            ]
            addFundingSource(params: params) {[unowned self] (success, url) in
                if success {
                    fundings.append(FundingSource(name: name, institution: institutionName, url: url!, isDefault: false))
                    self.fundingsTable.reloadData()
                    self.presentConfirmation(image: #imageLiteral(resourceName: "success"), message: "Funding Source Added")
                    self.spinner.stopAnimating()
                } else {
                    self.spinner.stopAnimating()
                    self.showError(message: .sourceLinkFailed)
                }
            }
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {[unowned self] in
            if error != nil {
                self.showError(message: .sourceLinkFailed)
            }
        }
    }
    
}
