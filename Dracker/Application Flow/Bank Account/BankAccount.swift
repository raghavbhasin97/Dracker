import UIKit
import LinkKit

class BankAccount: UIViewController {

    lazy var bar: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIApplication.shared.statusBarFrame.height)
        return view
    }()
    
    let bank_label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 18)
        label.numberOfLines = 3
        label.textColor = .text_color
        label.text = "Connect your bank account to start sending and receiving money..."
        return label
    }()
    
    let bank = UIImageView(image: #imageLiteral(resourceName: "bank"))
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Connect", for: .normal)
        button.addTarget(self, action: #selector(attach_bank_account), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.65), for: .highlighted)
        button.backgroundColor = .theme
        button.clipsToBounds = true
        button.layer.cornerRadius = 5.0
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup_graphics() {
        view.backgroundColor = .white
        view.addSubview(bar)
        view.addSubview(bank_label)
        view.addSubview(bank)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: bank_label)
        view.center_Y(item: bank_label, constant: -80)
        bank.bottomAnchor.constraint(equalTo: bank_label.topAnchor, constant: -10).isActive = true
        let h_gap = (view.frame.width - bank.frame.width) / 2
        view.addConstraintsWithFormat(format: "H:|-\(h_gap)-[v0]", views: bank)
    }
    
    fileprivate func setup_button() {
        view.addSubview(button)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.topAnchor.constraint(equalTo: bank_label.bottomAnchor, constant: 30).isActive = true
    }
    
    fileprivate func setup() {
        setup_graphics()
        setup_button()
    }
    
    @objc func attach_bank_account() {
        present_plaid()
    }

    func present_plaid() {
        let linkViewDelegate = self
        let controller = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            controller.modalPresentationStyle = .formSheet;
        }
        present(controller, animated: true)
    }
}

extension BankAccount : PLKPlaidLinkViewDelegate {
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            loading(target: self, completion: { (_) in
                let phone = UserDefaults.standard.object(forKey: "phone") as! String
                let account = metadata?["account"] as! [String: String]
                put_funding_source(token: publicToken, account_id: account["id"]!, phone: phone, name: account["name"]!, completion: {[unowned self] (data) in
                    if data.isFailure {
                        return
                    }
                    stop_loading()
                    let response = data.value as! [String: Any]
                    let message = response["message"] as! String
                    if message == "SUCCESS" {
                        
                        present_alert_with_handler_and_message(message: .success_bank_attach, target: self, handler: { (_) in
                            UserDefaults.standard.set(true, forKey: "bank")
                            let controller = root_navigation()
                            self.present(controller, animated: true, completion: nil)
                        })
                    } else {
                        present_alert_error(message: .funding_error, target: self)
                    }
                })
            })
        }
    }

    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if error != nil {
                present_alert_error(message: .funding_error, target: self)
            }
        }
    }
}
