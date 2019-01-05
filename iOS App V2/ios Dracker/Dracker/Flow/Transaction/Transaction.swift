import UIKit

protocol TransactionDelegate {
    func settle(at: Int)
    func delete(at: Int)
}

class Transaction: UIViewController {
    
    let spinner = Spinner(type: .ballPulse, color: .theme)
    var item: Unsettled!
    var index: Int!
    var delegate: TransactionDelegate?
    let titleView: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17.5, weight: .semibold)
        return label
    }()
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "noImage")
        return imageView
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    let detailsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    
    init(item: Unsettled) {
        super.init(nibName: nil, bundle: nil)
        self.item = item
        setup()
        setupData(item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addLoader() {
        view.addSubview(spinner)
        spinner.fillSuperview()
        spinner.startAnimating()
    }
    
    fileprivate func setupGestures() {
        if item.imageURL == "noImage" { return }
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(imageTap))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(gesture)
    }
    
    fileprivate func setupImage() {
        view.addSubview(image)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: image)
        image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        image.heightAnchor.constraint(equalToConstant: view.frame.height * 0.40).isActive = true
        setupGestures()
    }
    
    fileprivate func setupAmountLabel() {
        view.addSubview(amountLabel)
        amountLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        view.centerX(item: amountLabel)
    }
    
    fileprivate func setupDetailsLabel() {
        detailsContainer.addSubview(detailsLabel)
        detailsLabel.fillSuperview(padding: 10)
    }
    
    fileprivate func setupDetails() {
        view.addSubview(detailsContainer)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: detailsContainer)
        detailsContainer.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 20).isActive = true
        setupDetailsLabel()
    }
    
    fileprivate func setup() {
        view.backgroundColor = .white
        navigationItem.titleView = titleView
        setupImage()
        setupAmountLabel()
        setupDetails()
    }
    
    fileprivate func setupNavigationButton(isDebt: Bool) {
        let note = UIBarButtonItem(image: #imageLiteral(resourceName: "note").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(sendNote))
        
        if isDebt {
            let settle = UIBarButtonItem(image: #imageLiteral(resourceName: "settle").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settleAction))
            navigationItem.rightBarButtonItems = [note, settle]
        } else {
            let delete = UIBarButtonItem(image: #imageLiteral(resourceName: "delete").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(deleteAction))
            navigationItem.rightBarButtonItems = [note, delete]
        }
    }
    
    fileprivate func setupData(_ item: Unsettled) {
        setupNavigationButton(isDebt: item.isDebt)
        titleView.text = item.name
        image.loadImage(key: item.imageURL)
        var creator = ""
        if(item.isDebt) {
            amountLabel.textColor = .pay
            creator = item.name
            amountLabel.text = item.amount.asAmount() + "↓"
        } else {
            amountLabel.textColor = .charge
            creator = "you"
            amountLabel.text = item.amount.asAmount() + "↑"
        }
        let attributedText = item.getDescription(fontSize: 18)
        attributedText.append(NSAttributedString(string: "\n"))
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 5)]))
        let transactionId = Array(item.id)
        appendToDetails(attributedText: attributedText, weight: .regular, text: "Dracker transaction with ID #")
        transactionId.forEach { (character) in
            appendToDetails(attributedText: attributedText, weight: .bold, text: String(character))
           appendToDetails(attributedText: attributedText, weight: .regular, text: " ", fontSize: 0.01)

        }
        appendToDetails(attributedText: attributedText, weight: .regular, text:  " was created by ")
        appendToDetails(attributedText: attributedText, weight: .bold, text:  creator)
        appendToDetails(attributedText: attributedText, weight: .regular, text:  " with description ")
        appendToDetails(attributedText: attributedText, weight: .bold, text: "\"" + item.description + "\"")
        appendToDetails(attributedText: attributedText, weight: .regular, text:  " on ")
         appendToDetails(attributedText: attributedText, weight: .bold, text: item.transactionTime.formatDate(option: .monthNameDayYear) + " at " + item.transactionTime.formatDate(option: .time))
        detailsLabel.attributedText = attributedText
    }
    
    @objc fileprivate func settleAction() {
        addLoader()
        settleTransaction(id: item.id, payer: item.userId) {[unowned self] (status) in
            if status != 200 {
                self.showError(message: .couldNotSettle)
                self.spinner.stopAnimating()
                return
            }
            self.delegate?.settle(at: self.index)
            self.navigationController?.popViewController(animated: true)
            self.spinner.stopAnimating()
        }
    }
    
    @objc fileprivate func deleteAction() {
        addLoader()
        deleteTransaction(id: item.id, payee: item.userId) {[unowned self] in
            self.delegate?.delete(at: self.index)
            self.navigationController?.popViewController(animated: true)
            self.spinner.stopAnimating()
        }
    }
    
    @objc fileprivate func sendNote() {
        let note = SendNote()
        note.item = item
        let controller = UINavigationController(rootViewController: note)
        present(controller, animated: true, completion: nil)
    }
    
    private func appendToDetails(attributedText: NSMutableAttributedString, weight: UIFont.Weight, text: String, fontSize: CGFloat = 14.0) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        attributedText.append(NSAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor : UIColor.drBlack,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: weight),
            NSAttributedString.Key.paragraphStyle: paragraph
        ]))
    }
    
    @objc fileprivate func imageTap() {
        let share = UIActivityViewController(activityItems: [image.image!], applicationActivities: [])
        share.completionWithItemsHandler = {
            [unowned self] (activityType, completed, returnedItems, error) in
            if activityType == UIActivity.ActivityType.saveToCameraRoll {
                if error == nil {
                    self.presentConfirmation(image: #imageLiteral(resourceName: "success"), message: "Saved to Photo Gallery")
                }
            }
        }
        present(share, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        tabBarController?.tabBar.isHidden = false
    }
    
}
