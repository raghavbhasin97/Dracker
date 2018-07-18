import UIKit
import Firebase

class Register: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    var image_url: NSURL?
    let blue_area: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        return view
    }()
    
    let signin_view: UIView = {
        let view = UIView()
        return view
    }()
    
    let signin_label: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.textColor = .text_color
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var email_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.borderStyle = .roundedRect
        field.backgroundColor = .textfield
        field.placeholder = "Email"
        field.autocapitalizationType = .none
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    lazy var password_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.backgroundColor = .textfield
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.returnKeyType = .next
        field.delegate = self
        return field
    }()
    
    lazy var phone_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .roundedRect
        field.backgroundColor = .textfield
        field.placeholder = "Phone"
        field.keyboardType = .numberPad
        field.autocapitalizationType = .none
        field.returnKeyType = .go
        field.delegate = self
        return field
    }()
    lazy var signup_button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.theme.withAlphaComponent(0.75)
        button.setTitle("Sign Up", for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(signup_clicked), for: .touchUpInside)
        return button
    }()
    
    let signin_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.theme, for: .normal)
        button.setTitleColor(UIColor.theme.withAlphaComponent(0.65), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitle("Sign In.", for: .normal)
        button.addTarget(self, action: #selector(signin), for: .touchUpInside)
        return button
    }()
    
    lazy var profile_image: UIImageView = {
        let profile = UIImageView()
        profile.image = UIImage(named: "select_profile")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(select_image))
        profile.addGestureRecognizer(gesture)
        profile.isUserInteractionEnabled = true
        profile.contentMode = .scaleAspectFill
        profile.clipsToBounds = true
        profile.layer.cornerRadius = 70
        return profile
    }()
    
    let name_view: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var name_button: UIButton = {
        let button = UIButton()
        button.setTitle("@Name", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .highlighted)
        button.addTarget(self, action: #selector(set_name), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy var picker: UIImagePickerController = {
        let image_picker = UIImagePickerController()
        image_picker.delegate = self
        image_picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return image_picker
    }()
    fileprivate func setup()
    {
        view.backgroundColor = .white
        
        //Add sub views
        view.addSubview(blue_area)
        view.addSubview(signin_view)
        signin_view.addSubview(signin_label)
        signin_view.addSubview(signin_button)
        view.addSubview(email_field)
        view.addSubview(password_field)
        view.addSubview(phone_field)
        view.addSubview(signup_button)
        view.addSubview(profile_image)
        view.addSubview(name_view)
        name_view.addSubview(name_button)
        
        //profile Image
        view.addConstraint(NSLayoutConstraint(item: profile_image, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        profile_image.widthAnchor.constraint(equalToConstant: 140).isActive = true
        view.addConstraintsWithFormat(format: "V:|-\(UIApplication.shared.statusBarFrame.height + 8.0)-[v0(140)]", views: profile_image)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: name_view)
        name_view.heightAnchor.constraint(equalToConstant: 20).isActive = true
        view.addConstraint(NSLayoutConstraint(item: name_view, attribute: .top, relatedBy: .equal, toItem: profile_image, attribute: .bottom, multiplier: 1, constant: 2))
        
        // Theme setup
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: blue_area)
        view.addConstraintsWithFormat(format: "V:|[v0(\(UIApplication.shared.statusBarFrame.height))]", views: blue_area)
        // Signin setup
        view.addConstraintsWithFormat(format: "V:[v0(20)]-16-|", views: signin_view)
        signin_view.widthAnchor.constraint(equalToConstant: 233).isActive = true
        view.center_X(item: signin_view)
        signin_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signin_label)
        signin_view.addConstraintsWithFormat(format: "H:|[v0(176)][v1(63)]", views: signin_label, signin_button)
        signin_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signin_button)
        
        //Textfields setup and signup button
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: email_field)
        view.addConstraintsWithFormat(format: "V:|-220-[v0(40)]-18-[v1(40)]-18-[v2(40)]-28-[v3(50)]", views: email_field, password_field, phone_field, signup_button)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: password_field)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: phone_field)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: signup_button)
        //Name view
        name_view.addConstraintsWithFormat(format: "V:|[v0(20)]|", views: name_button)
        name_view.addConstraintsWithFormat(format: "H:|[v0]|", views: name_button)
    }
    
    @objc func signin()
    {
        let controller = Login()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    @objc func signup_clicked()
    {
        view.endEditing(true)
        let background_blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        let activity_indicator = TextActivity(text: "Signing Up!")
        background_blur.frame = view.frame
        if !validate_input(){ return }
        
        //ADD Blur view
        view.addSubview(background_blur)
        view.addSubview(activity_indicator)
        activity_indicator.show()
        background_blur.alpha = 0
        activity_indicator.layer.transform = CATransform3DMakeTranslation(0, view.frame.height/2, 0)
        //Get Parameters
        let email = email_field.text!
        let password = password_field.text!
        let phone = phone_field.text!
        let name = extract_name(name: (name_button.titleLabel?.text!)!)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            background_blur.alpha = 1.0
            activity_indicator.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }) { (_) in
            create_user(phone: phone, password: password, email: email, name: name) {[unowned self] (res) in
                background_blur.removeFromSuperview()
                activity_indicator.removeFromSuperview()
                if res.isFailure {
                    present_alert_error(message: .no_internet, target: self)
                    return
                }
                let response = res.value as! [String: Any]
                let message = response["message"] as! String
                if  message == "EMAIL_EXISTS" {
                    present_alert_error(message: .duplicate_account, target: self)
                    return
                } else if message == "PHONE_NUMBER_EXISTS" {
                    present_alert_error(message: .duplicate_phone, target: self)
                    return
                }
                //Upload image
                let uid = response["uid"] as! String
                upload_to_S3(key: uid, data: self.image_url!, bucket: .profiles)
                //Present success
                present_alert_with_handler_and_message(message: .account_created, target: self, handler: { [unowned self](_) in
                    self.signin()
                })
            }
        }
    }
    
    fileprivate func validate_input() -> Bool
    {
        if !valid_email(email: email_field.text!)
        {
            present_alert_error(message: .incorrect_email, target: self)
            return false
        } else if !valid_password(password: password_field.text!) {
            present_alert_error(message: .incorrect_password, target: self)
            return false
        } else if !valid_phone(phone: phone_field.text!) {
            present_alert_error(message: .incorrect_phone, target: self)
            return false
        } else if !valid_name(name: extract_name(name: (name_button.titleLabel?.text!)!)) {
            present_alert_error(message: .incorrect_name, target: self)
            return false
        } else if image_url == nil {
            present_alert_error(message: .incorrect_profile, target: self)
            return false
        }
        return true
    }
    @objc func set_name()
    {
        present_alert_with_textfield(target: self, message: .regiser_name, title: "", placeholder: "Name", keyboard: .default) { [unowned self] (name) in
            if !valid_name(name: name) {
                self.name_button.setTitle("@Name", for: .normal)
                present_alert_error(message: .incorrect_name, target: self)
                return
            }
            self.name_button.setTitle("@" + name, for: .normal)
        }
    }
    fileprivate func extract_name(name: String) -> String {
        let index = name.index(name.startIndex, offsetBy: 1)
        return String(name[index...])
    }
    
    @objc func select_image()
    {
        let actions = image_picker_action_sheet(controller: self, picker: picker, action1: "Choose from Library", action2: "Take a picture", camera: .front)
        execute_on_main { [unowned self] in
            self.present(actions, animated: true, completion: nil)
        }
    }
}

extension Register: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return slide_backward()
    }
}


extension Register: UITextFieldDelegate{
    func textfields_valid() -> Bool
    {
        return valid_email(email: email_field.text!)  && valid_password(password: password_field.text!) && valid_phone(phone: phone_field.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textfields_valid()
        {
            UIView.animate(withDuration: 0.2) {
                self.signup_button.isUserInteractionEnabled = true
                self.signup_button.backgroundColor = UIColor.theme
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.signup_button.isUserInteractionEnabled = false
                self.signup_button.backgroundColor = UIColor.theme.withAlphaComponent(0.75)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email_field {
            password_field.becomeFirstResponder()
        } else if textField == password_field {
            phone_field.becomeFirstResponder()
        } else {
            if textfields_valid() {
                signup_clicked()
            } else {
                view.endEditing(true)
            }
        }
        return false
    }
}

extension Register: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profile_image.image = image
            image_url = image.get_temporary_path(quality: 0.50)
        } else { return }
        dismiss(animated: true, completion: nil)
    }
}
