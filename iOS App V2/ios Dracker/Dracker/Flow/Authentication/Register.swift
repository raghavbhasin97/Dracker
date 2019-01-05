import UIKit

class Register: BaseViewController {

    fileprivate let itemSpacing: CGFloat = 15.0
    fileprivate let itemHeight: CGFloat = 50.0
    
    let loginText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Already have an account?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .drBlack
        return label
    }()

    let loginView: UIView = {
        let view = UIView()
        view.addLine(position: .Top)
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In.", for: .normal)
        button.setTitleColor(.theme, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    fileprivate func setupLoginView() {
        view.addSubview(loginView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: loginView)
        loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        
        let spacing: CGFloat = 2.0
        loginView.addSubview(loginText)
        loginView.centerY(item: loginText)
        loginView.centerX(item: loginText, constant: -(loginButton.frame.width/2 + spacing))
        loginView.addSubview(loginButton)
        loginView.centerY(item: loginButton)
        loginButton.leftAnchor.constraint(equalTo: loginText.rightAnchor, constant: spacing).isActive = true
    }
    
    override func setup() {
        view.backgroundColor = .white
        setupLoginView()
    }

    
    @objc fileprivate func showLogin() {
        navigationController?.popViewController(animated: true)
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
