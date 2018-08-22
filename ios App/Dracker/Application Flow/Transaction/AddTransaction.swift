import UIKit

class AddTransaction: UIViewController {
    weak var dahsboard: HomeView?
    var image_url: NSURL?
    var is_debt = false
    var others_name: String?
    var others_uid: String?
    var bottom_anchor: NSLayoutConstraint?
    
    enum state: Int {
        case normal = 0
        case selected = 1
    }
    enum action: String {
        case a_camera = "camera"
        case a_person = "person"
    }
    lazy var picker: UIImagePickerController = {
        let image_picker = UIImagePickerController()
        image_picker.delegate = self
        image_picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return image_picker
    }()
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.text = "Add Transaction"
        title.textAlignment = .center
        return title
    }()
    
    lazy var phone_button: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = .center
        button.setTitle("@Phone", for: .normal)
        button.setTitleColor(.text_color, for: .normal)
        button.setTitleColor(UIColor.text_color.withAlphaComponent(0.65), for: .highlighted)
        button.addTarget(self, action: #selector(choose_phone), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 25)
        return button
    }()
    
    
    let amount_field: UITextField = {
        let field = UITextField()
        field.placeholder = "$0.00"
        field.font = .systemFont(ofSize: 40)
        field.keyboardType = .decimalPad
        field.textColor = .text_color
        return field
    }()
    
    let description_field: UITextField = {
        let field = UITextField()
        field.placeholder = "Say something..."
        field.font = .systemFont(ofSize: 24)
        field.textColor = .text_color
        return field
    }()
    
    lazy var camera: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "camera_h"), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(add_photo), for: .touchUpInside)
        return button
    }()
    
    lazy var payer: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "person_green"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "person_greenh"), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.tintColor = .red
        button.addTarget(self, action: #selector(select_payer), for: .touchUpInside)
        return button
    }()
    
    //MARK: Action views setup
    let add_button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add_transaction))
    let amount_line = UIImageView(image: #imageLiteral(resourceName: "Line"))
    let description_line = UIImageView(image: #imageLiteral(resourceName: "Line"))
    let tag = UIImageView(image: #imageLiteral(resourceName: "tag"))
    let pencil = UIImageView(image: #imageLiteral(resourceName: "pencil"))
    let camera_label: UILabel = {
        let label = UILabel()
        label.textColor = .theme
        label.font = .systemFont(ofSize: 12)
        label.text = "Tag an image!"
        label.textAlignment = .center
        return label
    }()
    
    let payer_label: UILabel = {
        let label = UILabel()
        label.textColor = .theme
        label.font = .systemFont(ofSize: 12)
        label.text = "Select the payer!"
        label.textAlignment = .center
        return label
    }()
    
    lazy var options_view: UIView = {
        let view = UIView()
        //Subview camera
        view.addSubview(camera)
        camera.addSubview(camera_label)
        view.addConstraintsWithFormat(format: "H:|-30-[v0(59)]", views: camera)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(59)][v1]", views: camera,camera_label)
        camera.center_X(item: camera_label)
        camera_label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        //Subview payer
        view.addSubview(payer)
        payer.addSubview(payer_label)
        view.addConstraintsWithFormat(format: "H:[v0(71)]-30-|", views: payer)
        view.addConstraintsWithFormat(format: "V:|-4.50-[v0(71)]-3.50-[v1]", views: payer,payer_label)
        payer.center_X(item: payer_label)
        payer_label.widthAnchor.constraint(equalToConstant: 97).isActive = true
        return view
    }()
    
    fileprivate func setup_view() {
        //Add subviews
        view.addSubview(phone_button)
        view.addSubview(amount_line)
        view.addSubview(description_line)
        view.addSubview(amount_field)
        view.addSubview(description_field)
        view.addSubview(tag)
        view.addSubview(pencil)
        view.addSubview(options_view)
        //Add constraints
        view.center_X(item: phone_button)
        view.addConstraintsWithFormat(format: "V:|-50-[v0]-25-[v1]-30-[v2]", views: phone_button, amount_field, description_field)
        view.addConstraintsWithFormat(format: "H:|-40-[v0(35)]-15-[v1]-20-|", views: tag, amount_field)
        view.addConstraintsWithFormat(format: "H:|-40-[v0(30)]-18-[v1]-20-|", views: pencil, description_field)
        view.addConstraintsWithFormat(format: "V:|-135-[v0(30)]", views: tag)
        view.addConstraintsWithFormat(format: "V:|-193-[v0(36)]", views: pencil)
        view.addConstraintsWithFormat(format: "H:|-78-[v0]-20-|", views: amount_line)
        view.addConstraintsWithFormat(format: "H:|-78-[v0]-20-|", views: description_line)
        amount_line.topAnchor.constraint(equalTo: amount_field.bottomAnchor, constant: 0).isActive = true
        description_line.topAnchor.constraint(equalTo: description_field.bottomAnchor, constant: 2).isActive = true
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: options_view)
        bottom_anchor = options_view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottom_anchor?.isActive = true
        options_view.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    fileprivate func add_observers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard_shows), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboard_hides), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc fileprivate func keyboard_shows(notification: NSNotification) {
        let keyboard = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        bottom_anchor?.constant = -keyboard!.height
        UIView.animate(withDuration: duration) {[unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    @objc fileprivate func keyboard_hides(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        bottom_anchor?.constant = 0
        UIView.animate(withDuration: duration) {[unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authorize {[unowned self] in
            self.setup_navigation()
            self.setup_view()
            self.amount_field.becomeFirstResponder()
        }
    }
    //Cleanup and prevent memory leaks
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        add_observers()
        amount_field.becomeFirstResponder()
    }
    
    fileprivate func setup_navigation() {
        navigationItem.titleView = navigation_title
        navigationItem.rightBarButtonItem = add_button
    }
    
    @objc fileprivate func choose_phone() {
        let main_frame = UIApplication.shared.keyWindow?.screen.bounds
        let top = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
        let payer = Payer()
        payer.parent = self
        payer.first_responder = get_first_responder()
        view.addSubview(payer)
        view.endEditing(true)
        payer.frame = main_frame!
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        payer.layer.transform = CATransform3DMakeTranslation(0, (main_frame?.height)!, 0)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[unowned self] in
            payer.layer.transform = CATransform3DMakeTranslation(0, -top, 0)
            self.navigation_title.text = "Select Phone"
        }, completion: nil)
    }
    
    fileprivate func extract_phone() -> String {
        let phone = phone_button.titleLabel?.text
        let start = phone?.index((phone?.startIndex)!, offsetBy: 1)
        return String(phone![start!...])
    }
    
    @objc fileprivate func add_transaction() {
        if !validate() { return }
        if !reachable() {
            present_alert_error(message: .no_internet, target: self)
            return
        }
        //Dissmiss view
        view.endEditing(true)
        //Get Fields
        let phone = extract_phone()
        let amount = amount_field.text!
        let description = (description_field.text!).trimmingCharacters(in: .whitespaces)
        let current_phone = UserDefaults.standard.object(forKey: "phone") as! String
        let current_uid = UserDefaults.standard.object(forKey: "uid") as! String
        let current_name = UserDefaults.standard.object(forKey: "name") as! String
        let time = Date().as_string(format: .full)
        let notification_identifier = uuid()
        //Process Image
        var transaction_image = "noImage"
        if self.image_url != nil {
            transaction_image = "img_\(uuid())"
            upload_to_S3(key: transaction_image, data: self.image_url!, bucket: .transactionImages)
        }
        var parameters: [String: String] = [:]
        //Prepare item to add
        var item = Unsettled(is_debt: is_debt, amount: amount, description: description, name: others_name!, tagged_image: transaction_image, time: time, uid: others_uid!, phone: phone, notification_identifier: notification_identifier, transaction_id: "")
        //Generate parameters
        parameters["amount"] = amount
        parameters["description"] = description
        parameters["image"] = transaction_image
        parameters["notification"] = notification_identifier
        parameters["time"] = time
        if is_debt {
            parameters["payee_name"] = current_name
            parameters["payee_phone"] = current_phone
            parameters["payee_uid"] = current_uid
            parameters["payer_name"] =  others_name!
            parameters["payer_phone"] =  phone
            parameters["payer_uid"] = others_uid!
        } else {
            parameters["payer_name"] = current_name
            parameters["payer_phone"] = current_phone
            parameters["payer_uid"] = current_uid
            parameters["payee_name"] =  others_name!
            parameters["payee_phone"] =  phone
            parameters["payee_uid"] = others_uid!
        }
        //Post to databse
        loading(target: self) { (_) in
            put_transaction(parameters: parameters) {[unowned self] (data) in
                let transaction_identifier = data.value as! String
                item.transaction_id = transaction_identifier
                if self.is_debt && UserDefaults.standard.bool(forKey: "reminder") {
                    var user_info: [AnyHashable: Any] = [:]
                    user_info["transaction_id"] = transaction_identifier
                    user_info["uid"] = current_uid
                    user_info["payer_uid"] = self.others_uid!
                    user_info["notification_identifier"] = notification_identifier
                    create_notification(title: "You have an outstanding payment.", body: "You owe \(self.others_name!) $\(amount) for \"\(description)\"", identifier: notification_identifier, info: user_info)
                }
                //Update internal data for consistency
                let amount_value = Double(amount)!
                if self.is_debt {
                    debit += amount_value
                } else {
                    credit += amount_value
                }
                self.insert_and_push_back(item: item)
            }
        }
    }
    
    fileprivate func validate() -> Bool{
        let amount = amount_field.text!
        let description = (description_field.text!).trimmingCharacters(in: .whitespaces)
        if !valid_amount(amount: amount) {
            present_alert_error(message: .invalid_amount, target: self)
            return false
        } else if description.count < 1 {
            present_alert_error(message: .empty_description, target: self)
            return false
        } else if !valid_description(description: description) {
            present_alert_error(message: .long_description, target: self)
            return false
        } else if !valid_phone(phone: extract_phone()) {
            present_alert_error(message: .incorrect_phone, target: self)
            return false
        }
        return true
    }
}

//MARK: Extra Actions
extension AddTransaction {
    @objc fileprivate func add_photo()
    {
        let first_responder = get_first_responder()
        view.endEditing(true)
        let actions = image_picker_action_sheet(controller: self, picker: picker, action1: "Tag an image from Library", action2: "Snap an image", camera: .rear, first_responder: first_responder)
        actions.addAction(UIAlertAction(title: "Tag from Web", style: .default, handler: {[unowned self] (_) in
            self.navigation_title.text = "Tag Image"
            let top = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
            let main_frame = UIApplication.shared.keyWindow?.screen.bounds
            let image_search = ImageSearch()
            image_search.initialSearch = self.description_field.text!
            image_search.parent = self
            image_search.first_responder = self.get_first_responder()
            image_search.render_view()
            self.view.addSubview(image_search)
            self.view.endEditing(true)
            image_search.frame = main_frame!
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            image_search.layer.transform = CATransform3DMakeTranslation(0, (main_frame?.height)!, 0)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                image_search.layer.transform = CATransform3DMakeTranslation(0, -top, 0)
            }, completion: nil)
        }))
        execute_on_main { [unowned self] in
            self.present(actions, animated: true, completion: nil)
        }
    }
    
   func set_options(state: state, type: action) {
        if state == .selected {
            if type == .a_camera {
                camera.setImage(#imageLiteral(resourceName: "camera_green"), for: .normal)
                camera.setImage(#imageLiteral(resourceName: "camera_greenh"), for: .highlighted)
            } else {
                payer.setImage(#imageLiteral(resourceName: "person"), for: .normal)
                payer.setImage(#imageLiteral(resourceName: "person_h"), for: .highlighted)
            }
        } else {
            if type == .a_camera {
                camera.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
                camera.setImage(#imageLiteral(resourceName: "camera_h"), for: .highlighted)
            } else {
                payer.setImage(#imageLiteral(resourceName: "person_green"), for: .normal)
                payer.setImage(#imageLiteral(resourceName: "person_greenh"), for: .highlighted)
            }
        }
    }
    
    @objc func select_payer() {
        if others_name == nil {
            present_alert_error(message: .phone_first, target: self)
            return
        }
        let first_responder = get_first_responder()
        view.endEditing(true)
        let actions = UIAlertController(title: nil, message: "Who payed for it?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Me", style: .default, handler: {[unowned self] (_) in
            self.is_debt = false
            self.set_options(state: .normal, type: .a_person)
            first_responder.becomeFirstResponder()
        })
        action1.setValue(UIColor.settle_action, forKey: "titleTextColor")
        actions.addAction(action1)
        let action2 = UIAlertAction(title: others_name!, style: .default, handler: {[unowned self] (_) in
            self.is_debt = true
            self.set_options(state: .selected, type: .a_person)
            first_responder.becomeFirstResponder()
        })
        action2.setValue(UIColor.delete_action, forKey: "titleTextColor")
        actions.addAction(action2)
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            first_responder.becomeFirstResponder()
        }))
        execute_on_main { [unowned self] in
            self.present(actions, animated: true, completion: nil)
        }
    }
    
    /**
     * This function allows to add the current item to Home View and push back to
     the main controller.
     */
    fileprivate func insert_and_push_back(item: Unsettled) {
        stop_loading()
        //Push back to root view controller.
        navigationController?.popToRootViewController(animated: true)
        //Start a delete transaction
        let index = IndexPath(row: 0, section: 0)
        unsettled_transactions.insert(item, at: 0)
        dahsboard?.tableView.beginUpdates()
        dahsboard?.tableView.insertRows(at: [index], with: .automatic)
        dahsboard?.tableView.endUpdates()
    }
}

extension AddTransaction: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            set_options(state: .selected, type: .a_camera)
            image_url = image.get_temporary_path(quality: 0.50)
        } else { return }
        dismiss(animated: true, completion: nil)
        amount_field.becomeFirstResponder()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        amount_field.becomeFirstResponder()
    }
    
    fileprivate func get_first_responder() -> UITextField{
        if amount_field.isFirstResponder {
            return amount_field
        } else {
            return description_field
        }
    }
}
