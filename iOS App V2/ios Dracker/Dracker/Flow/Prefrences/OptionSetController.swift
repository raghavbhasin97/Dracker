import UIKit

struct OptionSetParams {
    var title: String
    var icon: UIImage
    var description: String
    var validation: ((String) -> Bool)
    var action: (String, @escaping () -> Void, @escaping (ErrorMessage) -> Void) -> Void
    var buttonTitle: String
    var filedIcon: UIImage
    var isSecure: Bool
    var keyboardType: UIKeyboardType
}

class OptionSetController: BaseViewController {
    
    private let spinner = Spinner(type: .ballPulse, color: .theme)
    fileprivate let disabledAlpha: CGFloat = 0.70
    private var fieldValue: String!
    
    var item: OptionSetParams? {
        didSet {
            if let item = item {
                loadView(item)
            }
        }
    }
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        return label
    }()

    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.isEnabled = false
        button.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        setupLogo()
        setupDescriptionText()
    }

    fileprivate func setupLogo() {
        view.addSubview(icon)
        view.centerX(item: icon)
        icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    fileprivate func setupDescriptionText() {
        view.addSubview(descriptionText)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descriptionText)
        descriptionText.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 10).isActive = true
    }
    
    fileprivate func loadView(_ item: OptionSetParams) {
        titleView.text = item.title
        icon.image = item.icon
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: item.title + "\n", attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.drBlack,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            ]))
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 2)]))
        
        attributedText.append(NSAttributedString(string: item.description, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.drBlack,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)
            ]))
        descriptionText.attributedText = attributedText
        button.setTitle(item.buttonTitle, for: .normal)
        let field: UITextField = {
            let field = IconField(image: item.filedIcon, width: view.frame.width)
            field.addLine(position: .Bottom)
            field.textColor = .drBlack
            field.font = .systemFont(ofSize: 14.5)
            field.isSecureTextEntry = item.isSecure
            field.clearButtonMode = .whileEditing
            field.addTarget(self, action: #selector(shouldEnable(_:)), for: .allEditingEvents)
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.keyboardType = item.keyboardType
            return field
        }()
        view.addSubview(field)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: field)
        field.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 20).isActive = true
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(button)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: button)
        button.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc fileprivate func buttonTapped() {
        addLoader()
        if let item = item {
            item.action(fieldValue, completion, errorOccurred)
        }
    }
    
    @objc fileprivate func shouldEnable(_ field: UITextField) {
        fieldValue = field.text!
        if item?.validation(fieldValue) ?? true {
            button.isEnabled = true
            button.backgroundColor = .theme
        } else {
            button.isEnabled = false
            button.backgroundColor =  UIColor.theme.withAlphaComponent(disabledAlpha)
        }
    }
    
    fileprivate func addLoader() {
        view.addSubview(spinner)
        spinner.fillSuperview()
        spinner.startAnimating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func errorOccurred(message: ErrorMessage) {
        spinner.stopAnimating()
        showError(message: message)
    }
    
    fileprivate func completion() {
        spinner.stopAnimating()
        navigationController?.popViewController(animated: true)
    }
}
