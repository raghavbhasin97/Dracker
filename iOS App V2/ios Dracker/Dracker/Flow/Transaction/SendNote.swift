import UIKit

class SendNote: BaseViewController {

    fileprivate let disabledAlpha: CGFloat = 0.70
    fileprivate let descriptionHeight: CGFloat = 22.5
    fileprivate let notePadding: CGFloat = 10.0
    
    var item: Unsettled? {
        didSet {
            if let item = item {
                getUserData(phone: item.phone) {[unowned self] (user) in
                    self.email = user["email"] as? String
                }
                
                let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "Send a note to " + item.name + "\n", attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.drBlack,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)
                    
                    ]))
                attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)]))
                
                attributedText.append(NSAttributedString(string: "Enter what's on your mind below and we will ensure that it gets into " + item.name + "\'s inbox." , attributes: [
                    NSAttributedString.Key.foregroundColor : UIColor.drBlack,
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)
                    ]))
                descriptionText.attributedText = attributedText
            }
        }
    }
    var email: String!
    
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Send Note"
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        return label
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(closePressed))
        return button
    }()
    
    let descriptionText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var noteView: UITextView = {
        let text = PlaceholderTextView(placeholder: "what's on your mind?")
        text.textColor = .drBlack
        text.font = .systemFont(ofSize: 16, weight: .regular)
        text.inputAccessoryView = inputAccessory
        text.delegate = self
        return text
    }()

    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "note").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendPressed), for: .touchUpInside)
        button.setTitle("Send", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.isEnabled = false
        button.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
        return button
    }()
    
    fileprivate func setupDescriptionText() {
        view.addSubview(descriptionText)
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: descriptionText)
        descriptionText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    }
    
    fileprivate func setupNoteView() {
        view.addSubview(noteView)
        view.addConstraintsWithFormat(format: "H:|-\(notePadding)-[v0]-\(notePadding)-|", views: noteView)
        noteView.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor).isActive = true
        noteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    lazy var inputAccessory: UIView = {
        let accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        accessoryView.addSubview(sendButton)
        sendButton.fillSuperview()
        return accessoryView
    }()
    
    let counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightBlack
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = "0/\(NOTE_MAX_LIMIT)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionHeader: UIView = {
        let view = UIView()
        return view
    }()
    
    
    fileprivate func setupDescriptionHeader() {
        view.addSubview(descriptionHeader)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: descriptionHeader)
        descriptionHeader.heightAnchor.constraint(equalToConstant: descriptionHeight).isActive = true
        descriptionHeader.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 12.5).isActive = true
        
        //Add Header
        let headerLabel: UILabel = {
            let label = UILabel()
            label.textColor = .drBlack
            label.font = .systemFont(ofSize: 15.5, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Note"
            label.textAlignment = .center
            return label
        }()
        descriptionHeader.addSubview(headerLabel)
        headerLabel.bottomAnchor.constraint(equalTo: descriptionHeader.bottomAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: descriptionHeader.leftAnchor, constant: notePadding + 2.5).isActive = true
        //Add Counter
        descriptionHeader.addSubview(counterLabel)
        counterLabel.bottomAnchor.constraint(equalTo: descriptionHeader.bottomAnchor).isActive = true
        counterLabel.rightAnchor.constraint(equalTo: descriptionHeader.rightAnchor, constant: -10).isActive = true
    }
    
    override func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = closeButton
        setupDescriptionText()
        setupDescriptionHeader()
        setupNoteView()
        noteView.becomeFirstResponder()
    }

    @objc fileprivate func closePressed() {
        noteView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func sendPressed() {
        let note = noteView.text!
        print(note)
        let file = Bundle.main.path(forResource: "note", ofType: "html")
        guard let fileContent = try? String(contentsOfFile: file!, encoding: String.Encoding.utf8) else { return }
        
        let emalBody = fileContent.replacingOccurrences(of: "{receiver}", with: item?.name ?? "").replacingOccurrences(of: "{sender}", with: currentUser.name).replacingOccurrences(of: "{description}", with: item?.description ?? "").replacingOccurrences(of: "{photo}", with: item?.imageURL ?? "noImage").replacingOccurrences(of: "{note}", with: note).trimmingCharacters(in: .whitespaces)
        let subject = currentUser.name + " added a note"
        sendEmail(email: email, text: emalBody, subject: subject) {[unowned self] (success) in
            if success {
                DispatchQueue.main.async {
                    self.showSuccess(message: .successAddingNote, handler: {[unowned self] (_) in
                        self.closePressed()
                    })
                }
            } else {
                DispatchQueue.main.async {
                    self.showError(message: .errorAddingNote)
                }
            }
        }
    }
}

extension SendNote: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text!.trimmingCharacters(in: .whitespaces)
        if text.count == 0 {
            disableSend()
            counterLabel.textColor = .lightBlack
        } else if text.count < NOTE_MIN_LIMIT {
            disableSend()
            counterLabel.textColor = .pay
        } else if text.count > NOTE_MAX_LIMIT {
            disableSend()
            counterLabel.textColor = .pay
        } else {
            enableSend()
            counterLabel.textColor = .charge
        }
        
        counterLabel.text = "\(text.count)/\(NOTE_MAX_LIMIT)"
    }
    
    fileprivate func disableSend() {
        sendButton.isEnabled = false
        sendButton.backgroundColor = UIColor.theme.withAlphaComponent(disabledAlpha)
    }
    
    fileprivate func enableSend() {
        sendButton.isEnabled = true
        sendButton.backgroundColor = .themeLight
    }
}
