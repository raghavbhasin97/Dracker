import UIKit

class Note: UIViewController {
    var data: Unsettled?
    let box: UITextView = {
        let text = UITextView()
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 1.0
        text.becomeFirstResponder()
        text.layer.cornerRadius = 5.0
        text.clipsToBounds = true
        return text
    }()
    
    let profile: UIImageView = {
        let profile = UIImageView()
        profile.clipsToBounds = true
        profile.contentMode = .scaleAspectFill
        profile.layer.cornerRadius = 40
        return profile
    }()
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc fileprivate func send_note() {
        if box.text == "" { return }
        if !reachable() {
            present_alert_error(message: .no_internet, target: self)
            return
        }
        let transaction = data!
        get_user_data(phone: (data?.phone)!) { (result) in
            if result.isFailure {
                return
            }
            let response = result.value as! [String: Any]
            let email = response["email"] as! String
            send_note_email(email: email, name: transaction.name, photo: transaction.tagged_image, title: transaction.description, note: self.box.text)
        }
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setup_navigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(send_note))
        navigationItem.titleView = navigation_title
        navigation_title.text = "Add Note"
    }
    
    fileprivate func setup() {
        view.backgroundColor = .white
        setup_navigation()
        //Add subviews and constraints
        view.addSubview(box)
        view.addSubview(profile)
        view.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: box)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(80)]-20-[v1(200)]", views: profile,  box)
        view.center_X(item: profile)
        profile.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profile.init_from_S3(key: (data?.uid)!, bucket_name: .profiles)
    }
}
