import UIKit
import Firebase
import UserNotifications

struct Options {
    var title: String
    var image: String
}

class Profile: UIView {
    
    let ID = "ProfileCell"
    let profile_dim: CGFloat = 200.0
    let profile_padding: CGFloat = 20.0
    let marker_dim: CGFloat = 40.0
    let multiplier: CGFloat = 1.25
    var uid: String?
    let marker = UIImageView(image: #imageLiteral(resourceName: "marker"))
    weak var parent: UIViewController?
    var image_url: NSURL?
    let data = [Options(title: "Change Password", image: "password_reset"),
                Options(title: "Change Email", image: "email_change"),
                Options(title: "Logout", image: "logout")]
    
    var actions = [Configuration(title: "Enter the new password below.", image: "password_reset", button: "Change Password", placeholder: "Password", isSecure: true, action: {(password) in
                if !valid_password(password: password) {
                    let target = UIApplication.shared.keyWindow?.rootViewController
                    present_alert_error(message: .incorrect_password, target: target!)
                    return false
                }
                Auth.auth().currentUser?.updatePassword(to: password, completion: { (err) in
                    if err == nil {
                        UserDefaults.standard.set(password.encrypt(), forKey: "password")
                        let target = UIApplication.shared.keyWindow?.rootViewController
                        present_alert_success(message: .password_reset_successful, target: target!)
                    } else {
                        let target = UIApplication.shared.keyWindow?.rootViewController
                        present_alert_error(message: .error_reset, target: target!)
                    }
                })
                    return true
        }),
        Configuration(title: "Enter the new email below.", image: "email_change", button: "Change Email", placeholder: "Email", isSecure: false, action: { (email) -> Bool in
                    if !valid_email(email: email) {
                        let target = UIApplication.shared.keyWindow?.rootViewController
                        present_alert_error(message: .incorrect_email, target: target!)
                        return false
                    }
                    var parameters: [String: String] = [:]
                    parameters["old_email"] = (UserDefaults.standard.object(forKey: "email") as! String).decrypt()
                    parameters["new_email"] = email
                    let target = UIApplication.shared.keyWindow?.rootViewController
                    update_email(parameters: parameters, completion: { (res) in
                        if res.isFailure {
                            present_alert_error(message: .no_internet, target: target!)
                            return
                        }
                        let response = res.value as! [String: Any]
                        if response["message"] == nil {
                            present_alert_error(message: .error_reset, target: target!)
                            return
                        }
                        let message = response["message"] as! String
                        if  message != "SUCCESS" {
                            present_alert_error(message: .error_reset, target: target!)
                            return
                        } else {
                            UserDefaults.standard.set(email.encrypt(), forKey: "email")
                            UserDefaults.standard.set(false, forKey: "auto_login")
                            present_alert_success(message: .email_reset_successful, target: target!)
                        }
                    })
                    return true
        })
    ]
    lazy var picker: UIImagePickerController = {
        let image_picker = UIImagePickerController()
        image_picker.delegate = self
        image_picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return image_picker
    }()
    
    lazy var options: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 60
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        let footer = UIView()
        footer.backgroundColor = .profile_background
        table.tableFooterView = footer
        let header = UIView()
        header.backgroundColor = .profile_background
        table.tableHeaderView = header
        return table
    }()
    
    lazy var profile: ActivityImageView = {
        let image = ActivityImageView()
        image.layer.cornerRadius = profile_dim/2
        image.clipsToBounds = true
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(select_image)))
        image.image = #imageLiteral(resourceName: "default_profile")
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .text_color
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup(width: CGFloat){
        backgroundColor = .profile_background
        addSubview(profile)
        addSubview(marker)
        addSubview(name)
        addSubview(options)
        center_X(item: profile)
        addConstraintsWithFormat(format: "V:|-\(profile_padding)-[v0(\(profile_dim))]-5-[v1(20)]-20-[v2(180)]", views: profile, name, options)
        profile.widthAnchor.constraint(equalToConstant: profile_dim).isActive = true
        let marker_h = width/2 + profile_dim/2  - (multiplier * marker_dim)
        let marker_v = profile_padding + profile_dim - (multiplier * marker_dim)
        addConstraintsWithFormat(format: "H:|-\(marker_h)-[v0(\(marker_dim))]", views: marker)
        addConstraintsWithFormat(format: "V:|-\(marker_v)-[v0(\(marker_dim))]", views: marker)
        center_X(item: name)
        addConstraintsWithFormat(format: "H:|[v0]|", views: options)
        options.register(ProfileCell.self, forCellReuseIdentifier: ID)
    }
    
    func setup_view(uid: String, width: CGFloat, parent: UIViewController) {
        self.parent = parent
        self.uid = uid
        setup(width: width)
        profile.start_downloading()
        profile.init_from_S3(key: self.uid!, bucket_name: .profiles) {[unowned self] in
            self.profile.stop_downloading()
        }
        let name = UserDefaults.standard.object(forKey: "name") as! String
        self.name.text = "@" + name
    }
}

//MARK: Profile Image actions
extension Profile: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func select_image()
    {
        if !reachable() {
            present_alert_error(message: .no_internet, target: parent!)
            return
        }
        let actions = image_picker_action_sheet(controller: parent!, picker: picker, action1: "Choose from Library", action2: "Take a picture", camera: .front)
        execute_on_main { [unowned self] in
            self.parent?.present(actions, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profile.image = image
            image_url = image.get_temporary_path(quality: 0.50)
            upload_to_S3(key: self.uid!, data: image_url!, bucket: .profiles)
            cache.setObject(UIImagePNGRepresentation(image) as AnyObject, forKey: self.uid! as AnyObject )
        } else { return }
        parent?.dismiss(animated: true, completion: nil)
    }
}

//MARK: Tableview Functions (Options Menu)
extension Profile: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! ProfileCell
        let item = self.data[indexPath.row]
        cell.set_option(title: item.title, image: item.image)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !reachable() {
            present_alert_error(message: .no_internet, target: parent!)
            return
        }
        let index = indexPath.row
        if index != 2 {
            let controller = Change()
            controller.create(from: actions[indexPath.row])
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        } else {
            do {
                try  Auth.auth().signOut()
            } catch {
                //Will never happen
            }
            UserDefaults.standard.set(false, forKey: "auto_login")
            UserDefaults.standard.set(false, forKey: "touch")
            UserDefaults.standard.set(false, forKey: "reminder")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            self.parent?.present(Login(), animated: true, completion: nil)
        }
    }
}
