import UIKit

class Passcode: UIViewController {
    var size: CGFloat = 0.0
    let padding: CGFloat = 30.0
    let spacing: CGFloat = 20.0
    var passcode: String?
    var current_length: Int = 0
    var current_passcode: String = ""
    let passcode_size: CGFloat = 15.0
    let passcode_length:CGFloat = 4.0
    var completion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        passcode = UserDefaults.standard.object(forKey: "pin") as? String
    }
    
    let buttons_view: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var button1: PasscodeButton = {
        let button = PasscodeButton(value: 1)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button2: PasscodeButton = {
        let button = PasscodeButton(value: 2)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button3: PasscodeButton = {
        let button = PasscodeButton(value: 3)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button4: PasscodeButton = {
        let button = PasscodeButton(value: 4)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button5: PasscodeButton = {
        let button = PasscodeButton(value: 5)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button6: PasscodeButton = {
        let button = PasscodeButton(value: 6)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button7: PasscodeButton = {
        let button = PasscodeButton(value: 7)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button8: PasscodeButton = {
        let button = PasscodeButton(value: 8)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button9: PasscodeButton = {
        let button = PasscodeButton(value: 9)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    lazy var button0: PasscodeButton = {
        let button = PasscodeButton(value: 0)
        button.addTarget(self, action: #selector(button_pressed), for: .touchUpInside)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 25)
        label.textColor = .text_color
        label.text = "Enter Passcode"
        label.textAlignment = .center
        return label
    }()
    
    let passcode_view: PasscodeIndicator = {
        let view = PasscodeIndicator()
        return view
    }()
    
    fileprivate func setup_buttons() {
        size = (view.frame.width - (2*padding) - (2*spacing))/3 - 10
        let buttons = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9]
        for button in buttons {
            button.layer.cornerRadius = size/2
            buttons_view.addSubview(button)
        }
        buttons_view.addConstraintsWithFormat(format: "H:|-20-[v0(\(size))]-\(spacing)-[v1(\(size))]-\(spacing)-[v2(\(size))]", views: button1, button2, button3)
        buttons_view.addConstraintsWithFormat(format: "V:|-20-[v0(\(size))]-\(spacing)-[v1(\(size))]-\(spacing)-[v2(\(size))]", views: button1, button4, button7)
        buttons_view.addConstraintsWithFormat(format: "V:|-20-[v0(\(size))]-\(spacing)-[v1(\(size))]-\(spacing)-[v2(\(size))]-\(spacing)-[v3(\(size))]", views: button2, button5, button8, button0)
        buttons_view.addConstraintsWithFormat(format: "V:|-20-[v0(\(size))]-\(spacing)-[v1(\(size))]-\(spacing)-[v2(\(size))]", views: button3, button6, button9)
        buttons_view.addConstraintsWithFormat(format: "H:|-20-[v0(\(size))]-\(spacing)-[v1(\(size))]-\(spacing)-[v2(\(size))]", views: button4, button5, button6)
        buttons_view.addConstraintsWithFormat(format: "H:|-20-[v0(\(size))]-\(spacing)-[v1(\(size))]-\(spacing)-[v2(\(size))]", views: button7, button8, button9)
        view.center_X(item: button0, constant: 5);
        button0.widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    fileprivate func setup() {
        view.addSubview(buttons_view)
        view.addSubview(label)
        view.addSubview(passcode_view)
        view.addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: buttons_view)
        view.center_X(item: passcode_view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: label)
        view.addConstraintsWithFormat(format: "V:|-60-[v0]-40-[v1(\(passcode_size))]-10-[v2]-20-|", views: label, passcode_view, buttons_view)
        passcode_view.length = 4
        passcode_view.size = passcode_size
        passcode_view.widthAnchor.constraint(equalToConstant: passcode_size*passcode_length + 30)
        setup_buttons()
    }
    
    fileprivate func reset() {
        current_length = 0
        passcode_view.highlighted = 0
        current_passcode = ""
    }
    @objc func button_pressed(_ sender: PasscodeButton) {
        let current_pressed = sender.titleLabel?.text!
        current_passcode += current_pressed!
        current_length += 1
        passcode_view.highlighted = current_length
        if current_length == passcode?.count {
            if current_passcode == passcode {
                execute_on_main_delay(delay: 0.7) {[unowned self] in
                    UserDefaults.standard.set(true, forKey: "auth")
                    self.dismiss(animated: true, completion: nil)
                    self.completion?()
                }
            } else {
                animate_cycle(view: passcode_view) {[unowned self] (_) in
                    self.reset()
                }
            }
        }
    }
}
