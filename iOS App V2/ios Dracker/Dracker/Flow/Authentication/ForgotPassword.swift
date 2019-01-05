import UIKit
import Firebase

class ForgotPassword: BaseViewController {
    
    fileprivate let itemSpacing: CGFloat = 15.0
    fileprivate let itemHeight: CGFloat = 50.0
    fileprivate let disabledAlpha: CGFloat = 0.70
    
    let logo: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "passwordForget"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to Log In", for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15.25, weight: .semibold)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginView: UIView = {
        let view = UIView()
        view.addLine(position: .Top)
        return view
    }()
    
    lazy var emailField: IconField = {
        let field = IconField(image: #imageLiteral(resourceName: "email"), width: view.frame.width)
        field.addLine(position: .Bottom)
        field.textColor = .drBlack
        field.font = .systemFont(ofSize: 14.5)
        field.attributedPlaceholder =   NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.drBlack.withAlphaComponent(0.5)])
        field.keyboardType = .emailAddress
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.delegate = self
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(shouldEnable), for: .editingChanged)
        return field
    }()
    
    lazy var forgotButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.isEnabled = false
        button.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(sendResetLink), for: .touchUpInside)
        button.setTitle("Send Reset Link", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailField, forgotButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = itemSpacing
        return stack
    }()
    
    let descriptionText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate func setupContentStack() {
        view.addSubview(contentStack)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: contentStack)
        contentStack.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 30).isActive = true
        
        let width = CGFloat(contentStack.arrangedSubviews.count) * itemHeight + (CGFloat(contentStack.arrangedSubviews.count - 1)) * itemSpacing
        contentStack.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    fileprivate func setupLoginView() {
        view.addSubview(loginView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: loginView)
        loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        loginView.addSubview(loginButton)
        loginView.centerY(item: loginButton)
        loginView.centerX(item: loginButton)
    }
    
    fileprivate func setupLogo() {
        view.addSubview(logo)
        view.centerX(item: logo)
        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.10).isActive = true
    }
    
    fileprivate func setupDescriptionText() {
        view.addSubview(descriptionText)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: descriptionText)
        descriptionText.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20).isActive = true
        
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "Trouble logging in?\n", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.drBlack,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            
            ]))
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]))
        
        attributedText.append(NSAttributedString(string: "Enter your email and we'll send you a password reset link to get back into your account.", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.drBlack,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]))
        descriptionText.attributedText = attributedText
    }
    
    override func setup() {
        view.backgroundColor = .white
        setupLoginView()
        setupLogo()
        setupDescriptionText()
        setupContentStack()
    }
    
    @objc fileprivate func showLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func sendResetLink() {
        view.endEditing(true)
        let email = emailField.text!
        let activity: UIActivityIndicatorView = {
            let activity = UIActivityIndicatorView(style: .white)
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            activity.startAnimating()
            return activity
        }()
        forgotButton.setTitle(nil, for: .normal)
        forgotButton.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: forgotButton.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: forgotButton.centerYAnchor).isActive = true
        Auth.auth().sendPasswordReset(withEmail: email) {[unowned self] (error) in
            if error != nil {
                self.forgotButton.setTitle("Send Reset Link", for: .normal)
                activity.removeFromSuperview()
                self.showError(message: .userNotFound)
                return
            }
            self.forgotButton.setTitle("Email Sent", for: .normal)
            activity.removeFromSuperview()
            self.showSuccess(message: .passwordReset, handler: {[unowned self] (_) in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc fileprivate func shouldEnable() {
        let email = emailField.text!
        if(validEmail(email: email)) {
            forgotButton.isEnabled = true
            forgotButton.backgroundColor = .theme
        } else {
            forgotButton.isEnabled = false
            forgotButton.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
        }
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


extension ForgotPassword: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
