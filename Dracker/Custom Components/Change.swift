import UIKit

class Change: UIViewController {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.text_color
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let textfield: UITextField = {
        let field = UITextField()
        field.font = .systemFont(ofSize: 18)
        return field
    }()
    
    let top = UIImageView(image: #imageLiteral(resourceName: "Line"))
    let bottom = UIImageView(image: #imageLiteral(resourceName: "Line"))
    let button: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.backgroundColor = .theme
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.65), for: .normal)
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 18)
        return button
    }()
    
    var keyboard_type: UIKeyboardType?
    
    var completion: ((String) -> Bool )?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        textfield.becomeFirstResponder()
    }
    
    fileprivate func setup() {
        view.addSubview(label)
        view.addSubview(image)
        view.addSubview(textfield)
        view.addSubview(top)
        view.addSubview(bottom)
        view.addSubview(button)
        view.addConstraintsWithFormat(format: "V:|-80-[v0(60)]-10-[v1(50)]-10-[v2(40)]-30-[v3(50)]", views: image, label, textfield, button)
        view.center_X(item: image)
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        view.addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: label)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: textfield)
        top.bottomAnchor.constraint(equalTo: textfield.topAnchor).isActive = true
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: top)
        top.heightAnchor.constraint(equalToConstant: 1.25).isActive = true
        bottom.topAnchor.constraint(equalTo: textfield.bottomAnchor).isActive = true
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: bottom)
        bottom.heightAnchor.constraint(equalToConstant: 1.00).isActive = true
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: button)
    }
    
    func create(from: Configuration) {
        label.text = from.title
        image.image = UIImage(named: from.image)
        textfield.placeholder = from.placeholder
        textfield.isSecureTextEntry = from.isSecure
        if keyboard_type != nil {
            textfield.keyboardType = keyboard_type!
        }
        button.setTitle(from.button, for: .normal)
        completion = from.action
        button.addTarget(self, action: #selector(perform_action), for: .touchUpInside)
    }
    
    @objc func perform_action() {
        if (completion?(textfield.text!))! {
            //Push back to root view controller.
            navigationController?.popViewController(animated: true)
        }
    }
}
