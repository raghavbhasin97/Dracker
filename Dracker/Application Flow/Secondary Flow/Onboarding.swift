import UIKit

class Onboarding: UIViewController {
    
    var verification: Int?
    var uid: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup_view()
        phone_field.becomeFirstResponder()
    }
    //MARK: components
    let phone_label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 3
        label.textColor = .text_color
        label.text = "Please confirm your Phone number to start."
        return label
    }()
    
    lazy var bar: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height)
        return view
    }()
    
    let phone_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.placeholder = "Phone number"
        field.font = .systemFont(ofSize: 20)
        return field
    }()
    
    let conformation_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.placeholder = "Confirmation code"
        field.font = .systemFont(ofSize: 20)
        field.isUserInteractionEnabled = false
        return field
    }()
    
    let disable_view: UIView = {
        let view = UIView()
        view.backgroundColor = .textfield_disabled
        return view
    }()
    
    
    lazy var continue_button: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(register_phone), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.65), for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        return button
    }()
    
    lazy var continue_view: UIView = {
        let bar = UIView()
        bar.backgroundColor = .theme
        bar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        bar.addSubview(continue_button)
        return bar
    }()
    let top = UIImageView(image: #imageLiteral(resourceName: "Line"))
    let bottom = UIImageView(image: #imageLiteral(resourceName: "Line"))
    let phone = UIImageView(image: #imageLiteral(resourceName: "phone"))
    let c_bottom = UIImageView(image: #imageLiteral(resourceName: "Line"))
    var disabled_top: NSLayoutConstraint?
    var disabled_bottom: NSLayoutConstraint?
    
    fileprivate func setup_confirmation_field() {
        //Setup confirmation field
        view.addSubview(conformation_field)
        view.addSubview(c_bottom)
        conformation_field.inputAccessoryView = continue_view
        view.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: conformation_field)
        view.addConstraintsWithFormat(format: "V:|-270-[v0(50)]", views: conformation_field)
        c_bottom.topAnchor.constraint(equalTo: conformation_field.bottomAnchor).isActive = true
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: c_bottom)
        c_bottom.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    fileprivate func setup_phone_field() {
        //Setup phone field
        view.addSubview(phone_field)
        view.addSubview(top)
        view.addSubview(bottom)
        phone_field.inputAccessoryView = continue_view
        view.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: phone_field)
        view.addConstraintsWithFormat(format: "V:|-220-[v0(50)]", views: phone_field)
        top.bottomAnchor.constraint(equalTo: phone_field.topAnchor).isActive = true
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: top)
        top.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        bottom.topAnchor.constraint(equalTo: phone_field.bottomAnchor).isActive = true
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: bottom)
        bottom.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    fileprivate func setup_graphic() {
        view.addSubview(bar)
        view.addSubview(phone_label)
        view.addSubview(phone)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: phone_label)
        view.addConstraintsWithFormat(format: "V:|-120-[v0(80)]", views: phone_label)
        phone.bottomAnchor.constraint(equalTo: phone_label.topAnchor).isActive = true
        let h_gap = (view.frame.width - phone.frame.width) / 2
        view.addConstraintsWithFormat(format: "H:|-\(h_gap)-[v0]", views: phone)
    }
    
    fileprivate func setup_disabled_view() {
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: disable_view)
        disabled_top = disable_view.topAnchor.constraint(equalTo: conformation_field.topAnchor, constant: 2)
        disabled_top?.isActive = true
        disabled_bottom = disable_view.bottomAnchor.constraint(equalTo: conformation_field.bottomAnchor, constant: -0.5)
        disabled_bottom?.isActive = true
    }
    
    fileprivate func  setup_view() {
        //Add subviews
        view.addSubview(disable_view)
        setup_phone_field()
        setup_confirmation_field()
        setup_graphic()
        setup_disabled_view()
    }
    
    @objc fileprivate func register_phone() {
        let number = phone_field.text!
        if !valid_phone(phone: number) {
            present_alert_error(message: .incorrect_phone, target: self)
            return
        }
    
        verification = random_code()
        let message = "\(verification!) is your Dracker confirmation code."
        send_message(phone: number, message: message)
        disabled_top?.constant = -49.50
        disabled_bottom?.constant = -50.50
        UIView.animate(withDuration: 0.5) {[unowned self] in
            self.view.layoutIfNeeded()
            self.continue_button.setTitle("Confirm", for: .normal)
            self.continue_button.removeTarget(self, action: #selector(self.register_phone), for: .touchUpInside)
            self.continue_button.addTarget(self, action: #selector(self.confirm_code), for: .touchUpInside)
            self.conformation_field.isUserInteractionEnabled = true
            self.phone_field.isUserInteractionEnabled = false
            self.conformation_field.becomeFirstResponder()
        }
    }
    
    fileprivate func save_and_redirect(number: String, name: String) {
        
        UserDefaults.standard.set(true, forKey: "sound")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(number, forKey: "phone")
        let controller = root_navigation()
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc fileprivate func confirm_code() {
        let number = conformation_field.text!
        if !valid_code(code: number) || Int(number) != verification! {
            present_alert_error(message: .incorrect_code, target: self)
            return
        }
        loading(target: self) {[unowned self] (_) in
            get_user_data(phone: self.phone_field.text!) { (data) in
                stop_loading()
                if data.isFailure {
                    return
                }
                let response = data.value as! [String: Any]
                let uid = response["uid"] as! String
                let name = response["name"] as! String
                if uid != (UserDefaults.standard.object(forKey: "uid") as! String) {
                    present_alert_error(message: .phone_not_match, target: self)
                } else {
                    self.save_and_redirect(number: self.phone_field.text!, name: name)
                }
            }
        }
    }
}
