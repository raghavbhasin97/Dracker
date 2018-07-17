import UIKit
import LocalAuthentication

struct SettingData {
    var title: String
    var image: String
}
class Settings: UIView {
    let ID = "SettingsCell"
    let sections = ["Preferences", "Options"]
    let data = [[SettingData(title: "Auto Login", image: "authorization"), SettingData(title: "Tocuh ID", image: "fingerprint"), SettingData(title: "Reminders", image: "notification"), SettingData(title: "Scan Sound", image: "sound")],
                [SettingData(title: "Alerts", image: "alerts"), SettingData(title: "Change Passcode", image: "passcode")]
    ]
    let defaults_key = ["auto_login", "touch", "reminder", "sound"]
    weak var parent: Home?
    lazy var table: UITableView = {
        let table = UITableView()
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.sectionHeaderHeight = 70.0
        table.rowHeight = 60.0
        return table
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
        addSubview(table)
        addConstraintsWithFormat(format: "H:|[v0]|", views: table)
        addConstraintsWithFormat(format: "V:|[v0]-80-|", views: table)
        table.register(SettingsCell.self, forCellReuseIdentifier: ID)
    }
}

//MARK: Table data and fuctions
extension Settings: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! SettingsCell
        cell.create_view(data: data[indexPath.section][indexPath.row])
        if indexPath.section == 0 {
            let accessory_view = IndexSwitch(frame: CGRect.zero, itemIndex: indexPath.row)
            accessory_view.addTarget(self, action: #selector(switch_action), for: .valueChanged)
            accessory_view.set_possition()
            cell.accessoryView = accessory_view
        } else {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        switch indexPath.row {
        case 0:
            let controller = Notification()
            self.parent?.navigationController?.pushViewController(controller, animated: true)
            break
        case 1:
            if !UserDefaults.standard.bool(forKey: "touch") {
                present_alert_error(message: .touchid_not_enabled, target: parent!)
                return
            }
            let controller = Change()
            controller.keyboard_type = .numberPad
            controller.create(from: Configuration(title: "Enter the new passcode", image: "passcode", button: "Change Passcode", placeholder: "Enter 4 digit passcode", isSecure: true, action: { (passcode) -> Bool in
                if !valid_pin(pin: passcode) {
                    let target = UIApplication.shared.keyWindow?.rootViewController
                    present_alert_error(message: .incorrect_passcode, target: target!)
                    return false
                }
                UserDefaults.standard.set(passcode, forKey: "pin")
                return true
            }))
            self.parent?.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
    }
}

//MARK: Switch Actions
extension Settings {
    @objc fileprivate func switch_action(accessory: IndexSwitch) {
        UserDefaults.standard.set(accessory.isOn, forKey: defaults_key[accessory.itemIndex])
        if accessory.isOn {
            UserDefaults.standard.set(false, forKey: defaults_key[accessory.itemIndex])
            accessory.setOn(false, animated: false)
            switch accessory.itemIndex {
            case 0:
                UserDefaults.standard.set(true, forKey: defaults_key[accessory.itemIndex])
                accessory.setOn(true, animated: true)
                break
            case 3:
                UserDefaults.standard.set(true, forKey: defaults_key[accessory.itemIndex])
                accessory.setOn(true, animated: true)
                break
            case 1:
                let controller = Change()
                controller.keyboard_type = .numberPad
                controller.create(from: Configuration(title: "Enter the new passcode", image: data[0][accessory.itemIndex].image, button: "Set Passcode", placeholder: "Enter 4 digit passcode", isSecure: true, action: {[unowned self] (passcode) -> Bool in
                    if !valid_pin(pin: passcode) {
                        let target = UIApplication.shared.keyWindow?.rootViewController
                        present_alert_error(message: .incorrect_passcode, target: target!)
                        UserDefaults.standard.set(false, forKey: self.defaults_key[accessory.itemIndex])
                        accessory.setOn(false, animated: false)
                        return false
                    }
                    UserDefaults.standard.set(passcode, forKey: "pin")
                    UserDefaults.standard.set(true, forKey: "auth")
                    UserDefaults.standard.set(true, forKey: self.defaults_key[accessory.itemIndex])
                    accessory.setOn(true, animated: true)
                    return true
                }))
                self.parent?.navigationController?.pushViewController(controller, animated: true)
                break
            case 2:
                let controller = Change()
                controller.keyboard_type = .numberPad
                controller.create(from: Configuration(title: "Enter frequency of Reminder", image: data[0][accessory.itemIndex].image, button: "Set Frequency", placeholder: "Number of days", isSecure: false, action: {[unowned self] (frequency) -> Bool in
                    if !valid_frequency(frequency: frequency){
                        let target = UIApplication.shared.keyWindow?.rootViewController
                        present_alert_error(message: .incorrect_frequency, target: target!)
                        UserDefaults.standard.set(false, forKey: self.defaults_key[accessory.itemIndex])
                        accessory.setOn(false, animated: false)
                        return false
                    }
                    UserDefaults.standard.set(frequency, forKey: "frequency")
                    UserDefaults.standard.set(true, forKey: self.defaults_key[accessory.itemIndex])
                    accessory.setOn(true, animated: true)
                    return true
                }))
                self.parent?.navigationController?.pushViewController(controller, animated: true)
                break
            default:
                fatalError("Internal Inconsistency")
            }
        }
    }
}
