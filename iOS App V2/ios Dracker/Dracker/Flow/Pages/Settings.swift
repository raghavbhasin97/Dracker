import UIKit
import Firebase

class Settings: BaseViewController {
    
    let cellId = "settingsCell"
    
    lazy var reminderSwitch: UISwitch = {
        let rswitch = UISwitch()
        rswitch.addTarget(self, action: #selector(reminderToggled(_:)), for: .valueChanged)
        rswitch.onTintColor = .theme
        rswitch.isOn = UserDefaults.standard.bool(forKey: "setReminder")
        rswitch.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
        return rswitch
    }()
    
    lazy var data: [Option] = [Option(title: "Prefrences", items:
        [
            OptionItem(icon: #imageLiteral(resourceName: "reminder"), title: "Payment Reminders", accessoryView: reminderSwitch),
            OptionItem(icon: #imageLiteral(resourceName: "frequency"), title: "Reminder Frequency",  accessoryType: (currentUser.setReminder ? .disclosureIndicator : .none), action: changeFrequency),
            OptionItem(icon: #imageLiteral(resourceName: "bank"), title: "Funding Sources", accessoryType: .disclosureIndicator, action: fundingSources)
        ]),
        Option(title: "Account", items: [
            OptionItem(icon: #imageLiteral(resourceName: "payer"), title: "Profile", action: showProfile),
            OptionItem(icon: #imageLiteral(resourceName: "email"), title: "Update Email", accessoryType: .disclosureIndicator, action: changeEmail),
            OptionItem(icon: #imageLiteral(resourceName: "qr"), title: "Scan QR")
        ]),
        Option(title: "Security", items: [
            OptionItem(icon: #imageLiteral(resourceName: "password"), title: "Update Password", accessoryType: .disclosureIndicator, action: changePassword)
        ]),
        Option(title: "", items: [
            OptionItem(icon: #imageLiteral(resourceName: "logout"), title: "Logout", action: logoutUser)
        ])
    ]
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        label.text = "Options"
        return label
    }()
    
    lazy var optionsTable: UITableView = {
        let footer = UIView()
        footer.backgroundColor = .lighterGray
        let table = UITableView()
        table.backgroundColor = .lighterGray
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = footer
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.bounces = false
        table.register(SettingCell.self, forCellReuseIdentifier: cellId)
        return table
    }()
    
    fileprivate func setupOptionsTable() {
        view.addSubview(optionsTable)
        optionsTable.fillSuperview()
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        setupOptionsTable()
    }
    
    @objc fileprivate func reminderToggled(_ sender: UISwitch) {
        let state = sender.isOn
        let image = state ? #imageLiteral(resourceName: "reminderOn"): #imageLiteral(resourceName: "reminderOff")
        currentUser.setReminder = state
        UserDefaults.standard.set(state, forKey: "setReminder")
        presentConfirmation(image: image, message: "Reminders have been turned \(state ? "on\nwith the default frequency of 1 day" : "off")")
        let cell = optionsTable.cellForRow(at: IndexPath(row: 1, section: 0))
        cell?.accessoryType = state ? .disclosureIndicator : .none
        if let cell = cell as? SettingCell {
            cell.setState(state: state)
        }
    }
    
    fileprivate func logoutUser() {
        clearUserdata()
        let login = UINavigationController(rootViewController: Login())
        present(login, animated: true)
    }
    
    fileprivate func showProfile() {
        let controller = ProfileChange()
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func changePassword() {
        let controller = OptionSetController()
        controller.item = OptionSetParams(title: "Update Password", icon: #imageLiteral(resourceName: "passwordForget"), description: "Please enter in the new password below. A strong password should have more than 6 characters and a mix of alphanumeric characters.", validation: validPassword, action: {[unowned self] (newPassword, completion, error) in
            Auth.auth().signIn(withEmail: currentUser.email, password: currentUser.password, completion: { (user, err) in
                user?.user.updatePassword(to:newPassword, completion: { (err) in
                    if err != nil {
                        error(.passwordUpdateFailed)
                    } else {
                        completion()
                        currentUser.password = newPassword
                        self.presentConfirmation(image: #imageLiteral(resourceName: "success"), message: "Password Updated")
                    }
                })
            })
            }, buttonTitle: "Update Password", filedIcon: #imageLiteral(resourceName: "password"), isSecure: true, keyboardType: .default)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func changeEmail() {
        let controller = OptionSetController()
        controller.item = OptionSetParams(title: "Update Email", icon: #imageLiteral(resourceName: "emailChange"), description: "Please enter in the new email below. Remember you will need to confirm this email and then you can use it to Log In in the future.", validation: validEmail, action: {[unowned self] (newEmail, completion, error) in
            updateEmail(email: newEmail, completion: {[unowned self] (success) in
                if success {
                    completion()
                    currentUser.email = newEmail
                    self.presentConfirmation(image: #imageLiteral(resourceName: "success"), message: "Email Updated")
                } else {
                    error(.emailUpdateFailed)
                }
            })
            }, buttonTitle: "Update Email", filedIcon: #imageLiteral(resourceName: "email"), isSecure: false, keyboardType: .emailAddress)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func changeFrequency() {
        if !currentUser.setReminder { return }
        let controller = OptionSetController()
        controller.item = OptionSetParams(title: "Change Reminder Frequency", icon: #imageLiteral(resourceName: "frequency-1"), description: "Please enter in the new reminder frequency below. Remember that it must be an integer and between 1 and 7 days. ", validation: validFrequency, action: {[unowned self] (newFrequency, completion, error) in
                completion()
                UserDefaults.standard.set(newFrequency, forKey: "reminderFrequency")
                self.presentConfirmation(image: #imageLiteral(resourceName: "success"), message: "Reminder Frequency set to \(newFrequency) days")
            }, buttonTitle: "Chnage Frequency", filedIcon: #imageLiteral(resourceName: "frequency"), isSecure: false, keyboardType: .numberPad)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func fundingSources() {
        let controller = FundingSources()
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension Settings: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingCell
        cell.item = data[indexPath.section].items[indexPath.row]
        if indexPath.section == 0 && indexPath.row == 1 {
            cell.setState(state: currentUser.setReminder)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SettingHeader(title: data[section].title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42.50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = data[indexPath.section].items[indexPath.row].action
        action?()
    }
}
