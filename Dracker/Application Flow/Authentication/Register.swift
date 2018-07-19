import UIKit
import Firebase

class Register: UIViewController {
    let icon_height: CGFloat = 24.0
    let profile_height: CGFloat = 110.0
    let logo_padding: CGFloat? =  30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    var image_url: NSURL?
    
    let signin_view: UIView = {
        let view = UIView()
        return view
    }()
    
    let profile_label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 15)
        label.textColor = .white
        label.text = "Profile Information"
        return label
    }()
    
    let personal_label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 15)
        label.textColor = .white
        label.text = "Personal Information"
        return label
    }()
    
    let signin_label: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let email_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.50)
        return view
    }()
    
    let email_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "email")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let password_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    
    let password_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "password")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let phone_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    
    let phone_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "phone_register")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let name_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    
    let name_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "name")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var email_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.delegate = self
        field.autocapitalizationType = .none
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        field.textColor = .white
        field.autocorrectionType = .no
        return field
    }()
    
    lazy var password_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.delegate = self
        field.returnKeyType = .go
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        field.textColor = .white
        return field
    }()
    
    lazy var name_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.autocapitalizationType = .words
        field.delegate = self
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        field.textColor = .white
        return field
    }()
    
    lazy var phone_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.delegate = self
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .go
        field.attributedPlaceholder =   NSAttributedString(string: "Phone", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        field.textColor = .white
        return field
    }()
    lazy var signup_button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
        button.setTitle("Sign Up", for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(signup_clicked), for: .touchUpInside)
        return button
    }()
    
    let signin_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.theme_unselected, for: .normal)
        button.setTitleColor(UIColor.theme_unselected.withAlphaComponent(0.65), for: .highlighted)
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
        profile.layer.cornerRadius = profile_height/2
        return profile
    }()
    
    
    let input_area: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var picker: UIImagePickerController = {
        let image_picker = UIImagePickerController()
        image_picker.delegate = self
        image_picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return image_picker
    }()
    
    fileprivate func setup_signIn() {
        view.addSubview(signin_view)
        signin_view.addSubview(signin_label)
        signin_view.addSubview(signin_button)
        view.addConstraintsWithFormat(format: "V:[v0(20)]-16-|", views: signin_view)
        signin_view.widthAnchor.constraint(equalToConstant: 233).isActive = true
        view.center_X(item: signin_view)
        signin_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signin_label)
        signin_view.addConstraintsWithFormat(format: "H:|[v0(176)][v1(63)]", views: signin_label, signin_button)
        signin_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signin_button)
    }
    
    fileprivate func setup_profile() {
        view.addSubview(profile_image)
        view.center_X(item: profile_image)
        profile_image.widthAnchor.constraint(equalToConstant: profile_height).isActive = true
    }
    
    fileprivate func setup_email() {
        input_area.addSubview(email_image)
        input_area.addSubview(email_line)
        input_area.addSubview(email_field)
        email_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        email_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        email_image.topAnchor.constraint(equalTo: email_field.topAnchor).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: email_line)
        email_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        email_line.topAnchor.constraint(equalTo: email_field.bottomAnchor, constant: 8).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: email_image, email_field)
    }
    
    fileprivate func setup_password() {
        input_area.addSubview(password_image)
        input_area.addSubview(password_line)
        input_area.addSubview(password_field)
        password_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        password_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        password_image.topAnchor.constraint(equalTo: password_field.topAnchor).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: password_line)
        password_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        password_line.topAnchor.constraint(equalTo: password_field.bottomAnchor, constant: 8).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: password_image, password_field)
    }
    
    fileprivate func setup_phone() {
        input_area.addSubview(phone_image)
        input_area.addSubview(phone_line)
        input_area.addSubview(phone_field)
        phone_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        phone_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        phone_image.topAnchor.constraint(equalTo: phone_field.topAnchor).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: phone_line)
        phone_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        phone_line.topAnchor.constraint(equalTo: phone_field.bottomAnchor, constant: 8).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: phone_image, phone_field)
    }
    
    fileprivate func setup_name() {
        input_area.addSubview(name_image)
        input_area.addSubview(name_line)
        input_area.addSubview(name_field)
        name_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        name_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        name_image.topAnchor.constraint(equalTo: name_field.topAnchor).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: name_line)
        name_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        name_line.topAnchor.constraint(equalTo: name_field.bottomAnchor, constant: 8).isActive = true
        input_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: name_image, name_field)
    }
    
    fileprivate func setup_signUp() {
        input_area.addSubview(signup_button)
        input_area.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: signup_button)
    }
    
    fileprivate func setup_sections() {
        input_area.addSubview(personal_label)
        input_area.addConstraintsWithFormat(format: "H:|-30-[v0]", views: personal_label)
        input_area.addSubview(profile_label)
        input_area.addConstraintsWithFormat(format: "H:|-30-[v0]", views: profile_label)
    }
    
    fileprivate func setup()
    {
        //Main View
        view.backgroundColor = .theme
        view.addSubview(input_area)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: input_area)
 
        //Setup Component
        setup_signIn()
        setup_profile()
        setup_email()
        setup_password()
        setup_phone()
        setup_name()
        setup_signUp()
        setup_sections()
        
        //Relative possition
        view.addConstraintsWithFormat(format: "V:|-\(logo_padding!)-[v0(\(profile_height))][v1]|", views: profile_image, input_area )
        input_area.addConstraintsWithFormat(format: "V:|-15-[v0]-5-[v1(\(icon_height))]-18-[v2(\(icon_height))]-25-[v3]-5-[v4(\(icon_height))]-18-[v5(\(icon_height))]-25-[v6(50)]", views: profile_label, email_field, password_field, personal_label, name_field, phone_field, signup_button)
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
        if !validate_input(){ return } //Just a safecheck
        
        //Add Blur view
        view.addSubview(background_blur)
        view.addSubview(activity_indicator)
        activity_indicator.show()
        activity_indicator.alpha = 0
        background_blur.alpha = 0
        activity_indicator.layer.transform = CATransform3DMakeTranslation(0, view.frame.height/2, 0)
        //Get Parameters
        let email = email_field.text!
        let password = password_field.text!
        let phone = phone_field.text!
        let name = name_field.text!
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            background_blur.alpha = 1.0
            activity_indicator.alpha = 1.0
            activity_indicator.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }) { (_) in
            create_user(phone: phone, password: password, email: email, name: name) {[unowned self] (res) in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[unowned self] in
                    background_blur.alpha = 0
                    activity_indicator.alpha = 0
                    activity_indicator.layer.transform = CATransform3DMakeTranslation(0, self.view.frame.height/2, 0)
                }, completion: {[unowned self] (_) in
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
        } else if !valid_name(name: name_field.text!) {
            present_alert_error(message: .incorrect_name, target: self)
            return false
        } else if image_url == nil {
            present_alert_error(message: .incorrect_profile, target: self)
            return false
        }
        return true
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
        return valid_email(email: email_field.text!)  && valid_password(password: password_field.text!) && valid_phone(phone: phone_field.text!) && valid_name(name: name_field.text!) && (image_url != nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textfields_valid()
        {
            UIView.animate(withDuration: 0.2) {
                self.signup_button.isUserInteractionEnabled = true
                self.signup_button.backgroundColor = UIColor.theme_unselected
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.signup_button.isUserInteractionEnabled = false
                self.signup_button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email_field {
            password_field.becomeFirstResponder()
        } else if textField == password_field {
            name_field.becomeFirstResponder()
        } else if textField == name_field {
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
