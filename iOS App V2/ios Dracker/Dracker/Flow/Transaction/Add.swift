import UIKit


protocol AddTransactionDelegate {
    func addedTransaction(item: Unsettled)
}

class Add: BaseViewController {
    
    let spinner = Spinner(type: .ballPulse, color: .theme)
    var selectedUser: User?
    let userIcon = UIImageView(image: #imageLiteral(resourceName: "phone"))
    var isDebt = false
    fileprivate let disabledAlpha: CGFloat = 0.40
    fileprivate let buttonsDisabledAlpha: CGFloat = 0.85
    fileprivate let descriptionHeight: CGFloat = 22.5
    var taggedImage: NSURL?
    var delegate: AddTransactionDelegate?
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .drBlack
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.text = "$"
        return label
    }()
    
    lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        picker.allowsEditing = false
        return picker
    }()
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        label.text = "Add Transaction"
        return label
    }()
    
    let paymentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let amountView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var descriptionView: UITextView = {
        let text = PlaceholderTextView(placeholder: "what's it for?")
        text.textColor = .drBlack
        text.font = .systemFont(ofSize: 16, weight: .regular)
        text.delegate = self
        text.inputAccessoryView = accessoryView
        return text
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(closePressed))
        return button
    }()
    
    lazy var amountField: UITextField = {
        let field = UITextField()
        field.keyboardType = .decimalPad
        field.placeholder = "how much?"
        field.addTarget(self, action: #selector(shouldEnable), for: .allEditingEvents)
        field.inputAccessoryView = accessoryView
        field.textColor = .charge
        return field
    }()
    
    lazy var payerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("with whom?", for: .normal)
        button.setTitleColor(.drBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(choosePayer), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Charge", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(disabledAlpha), for: .normal)
        button.addTarget(self, action: #selector(commitPay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .themeLight
        button.isEnabled = false
        return button
    }()
    
    lazy var debtButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(setDebt), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "payer").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(buttonsDisabledAlpha)
        button.isEnabled = false
        button.backgroundColor = .themeLight
        return button
    }()
    
    lazy var imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(tagImage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "image").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .themeLight
        return button
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightBlack
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = "0/\(DESCRIPTION_MAX_LIMIT)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionHeader: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate func addLoader() {
        view.addSubview(spinner)
        spinner.fillSuperview()
        spinner.startAnimating()
    }
    
    fileprivate func setupDescriptionHeader() {
        view.addSubview(descriptionHeader)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: descriptionHeader)
        descriptionHeader.heightAnchor.constraint(equalToConstant: descriptionHeight).isActive = true
        descriptionHeader.topAnchor.constraint(equalTo: amountView.bottomAnchor).isActive = true
        
        //Add Header
        let headerLabel: UILabel = {
            let label = UILabel()
            label.textColor = .drBlack
            label.font = .systemFont(ofSize: 15.5, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Description"
            return label
        }()
        descriptionHeader.addSubview(headerLabel)
        headerLabel.bottomAnchor.constraint(equalTo: descriptionHeader.bottomAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: descriptionHeader.leftAnchor, constant: 15).isActive = true
        //Add Counter
        descriptionHeader.addSubview(counterLabel)
        counterLabel.bottomAnchor.constraint(equalTo: descriptionHeader.bottomAnchor).isActive = true
        counterLabel.rightAnchor.constraint(equalTo: descriptionHeader.rightAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupUserIcon() {
        paymentView.addSubview(userIcon)
        paymentView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: userIcon)
        paymentView.addConstraintsWithFormat(format: "H:|-10-[v0]", views: userIcon)
        userIcon.widthAnchor.constraint(equalTo: userIcon.heightAnchor).isActive = true
    }
    
    fileprivate func setupPaymentButton() {
        paymentView.addSubview(payerButton)
        paymentView.addConstraintsWithFormat(format: "V:|[v0]|", views: payerButton)
        payerButton.leftAnchor.constraint(equalTo: userIcon.rightAnchor, constant: 10).isActive = true
        payerButton.rightAnchor.constraint(equalTo: paymentView.rightAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupPaymentView() {
        view.addSubview(paymentView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: paymentView)
        paymentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        setupUserIcon()
        setupPaymentButton()
        paymentView.addLine(position: .Bottom)
    }
    
    fileprivate func setupAmountField() {
        amountView.addSubview(amountField)
        amountField.leftAnchor.constraint(equalTo: amountLabel.rightAnchor, constant: 3).isActive = true
        amountField.rightAnchor.constraint(equalTo: amountView.rightAnchor, constant: -10).isActive = true
        amountView.addConstraintsWithFormat(format: "V:|[v0]|", views: amountField)
    }
    
    fileprivate func setupAmountLabel() {
        amountView.addSubview(amountLabel)
        amountView.addConstraintsWithFormat(format: "H:|-16-[v0(20)]", views: amountLabel)
        amountView.centerY(item: amountLabel)
    }
    
    fileprivate func setupAmountView() {
        view.addSubview(amountView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: amountView)
        amountView.topAnchor.constraint(equalTo: paymentView.bottomAnchor).isActive = true
        amountView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupAmountLabel()
        setupAmountField()
        amountView.addLine(position: .Bottom)
    }
    
    fileprivate func setupDescriptionView() {
        view.addSubview(descriptionView)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: descriptionView)
        descriptionView.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
        setupPaymentView()
        setupAmountView()
        setupDescriptionHeader()
        setupDescriptionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionView.becomeFirstResponder()
    }
    
    
    lazy var accessoryView: UIView = {
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        //Confirm Button
        accessoryView.addSubview(confirmButton)
        accessoryView.addConstraintsWithFormat(format: "V:|[v0]|", views: confirmButton)
        accessoryView.centerX(item: confirmButton)
        confirmButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
        //Debt Button
        accessoryView.addSubview(debtButton)
        accessoryView.addConstraintsWithFormat(format: "H:|[v0(50)]", views: debtButton)
        accessoryView.addConstraintsWithFormat(format: "V:|[v0]|", views: debtButton)
        //Image Button
        accessoryView.addSubview(imageButton)
        accessoryView.addConstraintsWithFormat(format: "H:[v0(50)]|", views: imageButton)
        accessoryView.addConstraintsWithFormat(format: "V:|[v0]|", views: imageButton)
        return accessoryView
    }()
    
    fileprivate func getFirstResponder() -> UIView{
        if descriptionView.isFirstResponder {
            return descriptionView
        } else {
            return amountField
        }
    }
    
    
    @objc func shouldEnable() {
        let amount = amountField.text!
        let description = descriptionView.text!
        if(selectedUser == nil ||
            !validAmount(amount: amount) ||
            !validDescription(description: description)) {
            confirmButton.isEnabled = false
            confirmButton.setTitleColor(
            UIColor.white.withAlphaComponent(disabledAlpha), for: .normal)
        } else {
            confirmButton.isEnabled = true
            confirmButton.setTitleColor(.white, for: .normal)
        }
    }
    
    
    @objc fileprivate func closePressed() {
        resignFirstResponder()
        amountField.resignFirstResponder()
        descriptionView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func choosePayer() {
        let payer = Payer()
        payer.selectionDelegate = self
        let controller = UINavigationController(rootViewController: payer)
        present(controller, animated: true, completion: nil)
    }
    
    @objc fileprivate func commitPay() {
        addLoader()
        view.endEditing(true)
        let imageName = taggedImage == nil ? "noImage" : "img_" + generateUID()
        let notification = "notification_" + generateUID()
        var params: [String: Any] = [:]
        let description = descriptionView.text.trimmingCharacters(in: .whitespaces)
        let amount = amountField.text!
        params["amount"] = amount
        params["description"] = description
        params["image"] = imageName
        params["notification"] = notification
        params["payee_name"] = isDebt ? currentUser.name : selectedUser?.name
        params["payee_phone"] = isDebt ? currentUser.phone : selectedUser?.phone
        params["payee_uid"] = isDebt ? currentUser.uid : selectedUser?.uid
        params["payer_name"] = !isDebt ? currentUser.name : selectedUser?.name
        params["payer_phone"] = !isDebt ? currentUser.phone : selectedUser?.phone
        params["payer_uid"] = !isDebt ? currentUser.uid : selectedUser?.uid
        params["time"] = Date().formatDate(option: .full)
        addTransaction(params: params) {[unowned self] (transactionId) in
            if transactionId == nil {
                self.showError(message: .transactionAddError, handler: {
                    [unowned self](_) in
                    self.descriptionView.becomeFirstResponder()
                })
                self.spinner.stopAnimating()
                return
            }
            if(self.taggedImage != nil) {
                uploadTransactionImage(key: imageName, data: self.taggedImage!)
            }
            if self.isDebt {
                createNotification(title: "You have a pending transaction", body: "You owe \(self.selectedUser?.name ?? "") $\(amount) for \(description)", identifier: notification)
            }
            self.view.endEditing(true)
            self.delegate?.addedTransaction(item: self.getUnsetteledTransaction(id: transactionId!, imageName: imageName, notification: notification))
            self.dismiss(animated: true, completion: nil)
            self.spinner.stopAnimating()
        }
    }
    
    @objc fileprivate func setDebt() {
        let options = OptionsController(title: "Who payed?", message: "Select who originally payed for this transaction, you or " + (selectedUser?.name ?? "") + ".",  firstResponder: getFirstResponder())
        options.addButton(image: #imageLiteral(resourceName: "up"), title: currentUser.name, color: .optionGreen) {
            [unowned self] in
            self.charge()
        }
        options.addButton(image: #imageLiteral(resourceName: "down"), title: selectedUser?.name ?? "", color: .optionRed) { [unowned self] in
            self.pay()
        }
        options.show()
    }
    
    @objc fileprivate func tagImage() {
        let options = OptionsController(title: "Tag an Image!", message: "Select an image to tag with this transaction. It can be a bill or just another image.", firstResponder: getFirstResponder())
        options.addButton(image: #imageLiteral(resourceName: "camera"), title: "Camera", color: .optionBlue) {
            [unowned self] in
            self.takePicture()
        }
        options.addButton(image: #imageLiteral(resourceName: "gallery"), title: "Photo Gallery", color: .optionGreen) { [unowned self] in
            self.selectFromGallery()
        }
        options.show()
    }
    
    fileprivate func selectFromGallery() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func takePicture() {
        picker.sourceType = .camera
        picker.cameraDevice = .rear
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func pay() {
        isDebt = true
        confirmButton.setTitle("Pay", for: .normal)
        amountField.textColor = .pay
    }
    
    fileprivate func charge() {
        isDebt = false
        confirmButton.setTitle("Charge", for: .normal)
        amountField.textColor = .charge
    }
    
    fileprivate func getUnsetteledTransaction(id: String, imageName: String, notification: String?)  -> Unsettled{
        var params: [String: Any] = [:]
        params["amount"] = amountField.text!
        params["description"] = descriptionView.text.trimmingCharacters(in: .whitespaces)
        params["is_debt"] = isDebt
        params["tagged_image"] = imageName
        params["notification_identifier"] = isDebt ? notification : nil
        params["name"] = selectedUser?.name
        params["phone"] = selectedUser?.phone
        params["uid"] = selectedUser?.uid
        params["time"] = Date().formatDate(option: .full)
        params["transaction_id"] = id
        return Unsettled(data: params)
    }
}

extension Add: PayerSelectonDelegate {
    func didDissmiss() {
        shouldEnable()
    }
    
    func didSelected(user: User) {
        selectedUser = user
        shouldEnable()
        payerButton.setTitle(user.name.nameHandle(), for: .normal)
        debtButton.tintColor = .white
        debtButton.isEnabled = true
    }
    
}

extension Add: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text!.trimmingCharacters(in: .whitespaces)
        if text.count == 0 {
            counterLabel.textColor = .lightBlack
        } else if text.count < DESCRIPTION_MIN_LIMIT {
            counterLabel.textColor = .pay
        } else if text.count > DESCRIPTION_MAX_LIMIT {
            counterLabel.textColor = .pay
        } else {
            counterLabel.textColor = .charge
        }
        
        counterLabel.text = "\(text.count)/\(DESCRIPTION_MAX_LIMIT)"
        
        shouldEnable()
    }
}

extension Add: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        taggedImage = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        dismiss(animated: true, completion: nil)
    }
}
