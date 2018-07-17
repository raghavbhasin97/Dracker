import UIKit
import Firebase

class Login: UIViewController {
    let logo_height: CGFloat = 120.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    let input_area: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        title.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 22)
        title.text = "Dracker"
        title.textColor = .white
        title.textAlignment = .center
        return title
    }()
    
    lazy var email_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.borderStyle = .roundedRect
        field.backgroundColor = .textfield
        field.placeholder = "Email"
        field.delegate = self
        field.autocapitalizationType = .none
        field.returnKeyType = .next
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
        field.delegate = self
        field.returnKeyType = .go
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
        button.setTitleColor(.theme, for: .normal)
        button.setTitleColor(UIColor.theme.withAlphaComponent(0.65), for: .highlighted)
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
        label.textColor = .text_color
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let signup_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.theme, for: .normal)
        button.setTitleColor(UIColor.theme.withAlphaComponent(0.65), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitle("Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setup()
    {
        //main view
        self.view.backgroundColor = .theme
        
        //Add subViews
        view.addSubview(input_area)
        view.addSubview(letter_D)
        view.addSubview(title_tag)
        view.addSubview(email_field)
        view.addSubview(password_field)
        view.addSubview(login_button)
        view.addSubview(forget_button)
        view.addSubview(signup_view)
        signup_view.addSubview(signup_label)
        signup_view.addSubview(signup_button)
        
        //Logo View
        view.center_X(item: letter_D)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: title_tag)
        letter_D.widthAnchor.constraint(equalToConstant: logo_height).isActive = true
        let logo_padding: CGFloat? =  5.0
        view.addConstraintsWithFormat(format: "V:|-\(logo_padding!)-[v0(\(logo_height))]-5-[v1]", views: letter_D, title_tag)
        
        
        //white area
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: input_area)
        view.addConstraintsWithFormat(format: "V:|-180-[v0]|", views: input_area)

        
        //Email address Constraints
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: email_field)
        view.addConstraintsWithFormat(format: "V:|-200-[v0(40)]-18-[v1(40)]-28-[v2(50)]-10-[v3(20)]", views: email_field, password_field, login_button, forget_button)
        
        //Password Constraints
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: password_field)
        
        //Button add
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: login_button)
        view.center_X(item: forget_button)
        forget_button.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        // Signup setup
        view.addConstraintsWithFormat(format: "V:[v0(20)]-16-|", views: signup_view)
        signup_view.widthAnchor.constraint(equalToConstant: 227).isActive = true
        view.center_X(item: signup_view)
        signup_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signup_label)
        signup_view.addConstraintsWithFormat(format: "H:|[v0(161)][v1(65)]", views: signup_label, signup_button)
        signup_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signup_button)
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textfields_valid()
        {
            UIView.animate(withDuration: 0.2) {
                self.login_button.isUserInteractionEnabled = true
                self.login_button.backgroundColor = .theme_unselected
            }
        } else  {
            UIView.animate(withDuration: 0.2) {
                self.login_button.isUserInteractionEnabled = false
                self.login_button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email_field {
            password_field.becomeFirstResponder()
        } else {
            if textfields_valid() {
                login_clicked()
            } else {
                view.endEditing(true)
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
