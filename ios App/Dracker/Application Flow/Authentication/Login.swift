import UIKit
import Firebase

class Login: UIViewController {
    let logo_height: CGFloat = 100.0
    let icon_height: CGFloat = 24.0
    let logo_padding: CGFloat? =  80.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    let input_area: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        return view
    }()
    
    let letter_D: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = #imageLiteral(resourceName: "letter-D")
        return image
    }()
    
    let title_tag: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 15)
        title.text = "Dracker"
        title.textColor = .white
        title.textAlignment = .center
        return title
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
    
    lazy var email_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.delegate = self
        field.autocapitalizationType = .none
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(textfieldDidChange), for: .allEditingEvents)
        return field
    }()
    
    lazy var password_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.delegate = self
        field.returnKeyType = .done
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.attributedPlaceholder =   NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(textfieldDidChange), for: .allEditingEvents)
        return field
    }()
    
    lazy var login_button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
        button.setTitle("Login", for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(login_clicked), for: .touchUpInside)
        return button
    }()
    
    lazy var forget_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.theme_unselected, for: .normal)
        button.setTitleColor(UIColor.theme_unselected.withAlphaComponent(0.65), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.titleLabel?.textAlignment = .center
        button.setTitle("Forgot Password", for: .normal)
        button.addTarget(self, action: #selector(forgot_password), for: .touchUpInside)
        return button
    }()
    
    let signup_view: UIView = {
        let view = UIView()
        return view
    }()
    
    let signup_label: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let signup_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.theme_unselected, for: .normal)
        button.setTitleColor(UIColor.theme_unselected.withAlphaComponent(0.65), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitle("Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setup_signUp() {
        view.addSubview(signup_view)
        signup_view.addSubview(signup_label)
        signup_view.addSubview(signup_button)
        view.addConstraintsWithFormat(format: "V:[v0(20)]-16-|", views: signup_view)
        signup_view.widthAnchor.constraint(equalToConstant: 227).isActive = true
        view.center_X(item: signup_view)
        signup_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signup_label)
        signup_view.addConstraintsWithFormat(format: "H:|[v0(161)][v1(65)]", views: signup_label, signup_button)
        signup_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signup_button)
    }
    
    fileprivate func setup_buttons() {
        input_area.addSubview(login_button)
        input_area.addSubview(forget_button)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: login_button)
        view.center_X(item: forget_button)
        forget_button.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    fileprivate func setup_logo() {
        view.addSubview(letter_D)
        view.addSubview(title_tag)
        view.center_X(item: letter_D)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: title_tag)
        letter_D.widthAnchor.constraint(equalToConstant: logo_height).isActive = true
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: input_area)
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
    
    fileprivate func setup()
    {
        //main view
        self.view.backgroundColor = .theme
      
        //Add views
        view.addSubview(input_area)
        
        // Call component setups
        setup_logo()
        setup_email()
        setup_password()
        setup_buttons()
        setup_signUp()
        
        //Relative vertical positioning
        view.addConstraintsWithFormat(format: "V:|-\(logo_padding!)-[v0(\(logo_height))]-10-[v1]-20-[v2]|", views: letter_D, title_tag, input_area)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(\(icon_height))]-18-[v1(\(icon_height))]-25-[v2(50)]-10-[v3(20)]", views: email_field, password_field, login_button, forget_button)
    }
    
    @objc func login_clicked()
    {
        if !validate_input() {
            return
        }
        view.endEditing(true)
        let email = email_field.text!
        let password = password_field.text!
        authenticate_visual(caller: self, email: email, password: password)
    }
    
    fileprivate func validate_input() -> Bool
    {
        if !valid_email(email: email_field.text!) {
            present_alert_error(message: .incorrect_email, target: self)
            return false
        } else if !valid_password(password: password_field.text!) {
            present_alert_error(message: .incorrect_password, target: self)
            return false
        }
        return true
    }
    
    @objc func forgot_password()
    {
        view.endEditing(true)
        let email = email_field.text!
        if !valid_email(email: email) {
            present_alert_error(message: .incorrect_email, target: self)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (err) in
            if err != nil {
                present_alert_error(message: .account_not_found, target: self)
            } else {
                present_alert_success(message: .reset_email, target: self)
            }
        }
    }
    
    @objc func signup()
    {
        let controller = Register()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
}

extension Login: UITextFieldDelegate{
    func textfields_valid() -> Bool
    {
        return valid_email(email: email_field.text!)  && valid_password(password: password_field.text!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func textfieldDidChange() {
        if textfields_valid() {
            login_button.isUserInteractionEnabled = true
            login_button.backgroundColor = .theme_unselected
        } else  {
            login_button.isUserInteractionEnabled = false
            login_button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email_field {
            password_field.becomeFirstResponder()
        } else {
            view.endEditing(true)
            if login_button.isUserInteractionEnabled {
                login_clicked()
            }
        }
        return false
    }
}

extension Login: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return slide_forward()
    }
}
