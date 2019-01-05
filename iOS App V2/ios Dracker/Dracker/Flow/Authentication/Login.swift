import UIKit
import Firebase

class Login: BaseViewController {
    
    fileprivate let itemSpacing: CGFloat = 15.0
    fileprivate let itemHeight: CGFloat = 50.0
    fileprivate let disabledAlpha: CGFloat = 0.70
    
    let registerText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Don't have an account?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .drBlack
        return label
    }()
    
    let orText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "OR"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .drBlack
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register.", for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(showRegister), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    lazy var forgotButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15.25, weight: .semibold)
        button.addTarget(self, action: #selector(showForgotPassword), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    let registerView: UIView = {
        let view = UIView()
        view.addLine(position: .Top)
        return view
    }()
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var emailField: IconField = {
        let field = IconField(image: #imageLiteral(resourceName: "email"), width: view.frame.width)
        field.addLine(position: .Bottom)
        field.textColor = .drBlack
        field.font = .systemFont(ofSize: 14.5)
        field.attributedPlaceholder =   NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.drBlack.withAlphaComponent(0.5)])
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.delegate = self
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(shouldEnable), for: .editingChanged)
        return field
    }()
    
    lazy var passwordField: IconField = {
        let field = IconField(image: #imageLiteral(resourceName: "password"), width: view.frame.width)
        field.addLine(position: .Bottom)
        field.textColor = .drBlack
        field.font = .systemFont(ofSize: 14.5)
        field.attributedPlaceholder =   NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.drBlack.withAlphaComponent(0.5)])
        field.keyboardType = .default
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.delegate = self
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(shouldEnable), for: .editingChanged)
        return field
    }()
    
    lazy var loginStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = itemSpacing
        return stack
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.isEnabled = false
        button.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate func setupRegisterView() {
        view.addSubview(registerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: registerView)
        registerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        registerView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        let spacing: CGFloat = 2.0
        registerView.addSubview(registerText)
        registerView.centerY(item: registerText)
        registerView.centerX(item: registerText, constant: -(registerButton.frame.width/2 + spacing))
        registerView.addSubview(registerButton)
        registerView.centerY(item: registerButton)
        registerButton.leftAnchor.constraint(equalTo: registerText.rightAnchor, constant: spacing).isActive = true
    }
    
    fileprivate func setupLogo() {
        view.addSubview(logo)
        view.centerX(item: logo)
        logo.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.10).isActive = true
    }
    
    fileprivate func setupLoginStack() {
        view.addSubview(loginStack)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: loginStack)
        loginStack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30).isActive = true
        
        let width = CGFloat(loginStack.arrangedSubviews.count) * itemHeight + (CGFloat(loginStack.arrangedSubviews.count - 1)) * itemSpacing
        loginStack.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    fileprivate func setupOrText(_ containerView: UIView) {
         //Add the container
        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: containerView)
        containerView.topAnchor.constraint(equalTo: loginStack.bottomAnchor, constant: 20).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        //Get a helf view
        let halfView: UIView = {
            let view = UIView()
            view.addLine(position: .Bottom)
            return view
        }()
         //Add view with line till half height
        containerView.addSubview(halfView)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: halfView)
        containerView.addConstraintsWithFormat(format: "V:|[v0(\(itemHeight/2))]", views: halfView)
        
         //Add text
        containerView.addSubview(orText)
        containerView.centerY(item: orText)
        containerView.centerX(item: orText)
        orText.widthAnchor.constraint(equalToConstant: itemHeight * 1.5).isActive = true
    }
    
    fileprivate func setupForgotButton(_ containerView: UIView) {
        view.addSubview(forgotButton)
        view.centerX(item: forgotButton)
        forgotButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
    }
    
    override func setup() {
        view.backgroundColor = .white
        setupRegisterView()
        setupLogo()
        setupLoginStack()
        
        //Container View for OR Section
        let containerView: UIView = {
            let view = UIView()
            return view
        }()
        setupOrText(containerView)
        setupForgotButton(containerView)
    }
    
    @objc fileprivate func showRegister() {
        let controller = Register()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc fileprivate func loginAction() {
        view.endEditing(true)
        let activity: UIActivityIndicatorView = {
            let activity = UIActivityIndicatorView(style: .white)
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activity.startAnimating()
            return activity
        }()
        loginButton.setTitle(nil, for: .normal)
        loginButton.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor).isActive = true
        
        let email = emailField.text!
        let password = passwordField.text!
        Auth.auth().signIn(withEmail: email, password: password) {[unowned self] (res, error) in
            if error != nil {
                activity.removeFromSuperview()
                self.loginButton.setTitle("Log In", for: .normal)
                if let code = AuthErrorCode(rawValue: error!._code) {
                    switch code {
                        case .userNotFound:
                            self.showError(message: .userNotFound)
                            break
                        case .wrongPassword:
                            self.showError(message: .wrongPassword)
                            break
                        default:
                            self.showError(message: .invalidLogin)
                    }
                } else {
                    self.showError(message: .invalidLogin)
                }
                
                return
            }
            
            guard let user = res?.user else {
                self.showError(message: .invalidLogin)
                return
            }
            
            if !user.isEmailVerified {
                self.showError(message: .unverifiedEmail)
                user.sendEmailVerification(completion: nil)
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {[unowned self] in
                storeUserdata(user: user, password: password)
                let main = Main()
                self.present(main, animated: true, completion: nil)
            })
        }
    }
    
    
    @objc fileprivate func shouldEnable() {
        let email = emailField.text!
        let password = passwordField.text!
        
        if(validEmail(email: email) && validPassword(password: password)) {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .theme
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
        }
    }
    
    @objc fileprivate func showForgotPassword() {
        let controller = ForgotPassword()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}


extension Login: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return false
    }
}
