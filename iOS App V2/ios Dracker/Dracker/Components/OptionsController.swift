import UIKit

class OptionsController: UIViewController {
    fileprivate let tag = 2345
    fileprivate let titleHeight: CGFloat = 50.0
    fileprivate let messagePadding: CGFloat = 20
    fileprivate let buttonHeight: CGFloat = 50.0
    fileprivate let tagBase = 10
    
    private var messageText: String?
    private var titleText: String?
    private var firstResponder: UIView?
    private var heightOfContainer: CGFloat = 0
    private var activeViewController: UIViewController?
    private var buttons: [OptionButton] = []
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(title: String?, message: String?, firstResponder: UIView? = nil) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .overlay
        self.firstResponder = firstResponder
        titleText = title
        messageText = message
        activeViewController = getActiveController()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black.withAlphaComponent(0.9)
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        label.textAlignment = .center
        label.addLine(position: .Bottom)
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - messagePadding, height: .greatestFiniteMagnitude))
        label.textColor = .drBlack
        label.font = UIFont(name: "Avenir Next", size: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cancel: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .themeLight
        button.setTitle("Dissmiss", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        button.addTarget(self, action: #selector(dissmissPressed), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    
    fileprivate func getActiveController() -> UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    
    fileprivate func addToViewHeirarchy() {
        if let window = UIApplication.shared.keyWindow {
            if window.viewWithTag(tag) == nil {
                view.tag = tag
                window.addSubview(view)
            }
        }
    }
    
    public func show() {
        if buttons.count == 0 {
            fatalError("The Options View is comletely empty, which is not allowed. Add alteast 1 button, or title, or message.")
        }
        view.backgroundColor = .overlay
        addToViewHeirarchy()
        activeViewController?.addChild(self)
        let activeView = activeViewController?.view
        activeView?.endEditing(true)
        setupContainer()
        UIView.animate(withDuration: 0.3,
            delay: 0.2,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0,
            options: .curveEaseIn,
            animations: {
                self.containerView.layer.transform = CATransform3DMakeTranslation(0,0, 0)
            }, completion: nil)
    }
    
    public func addButton(image: UIImage, title: String, color: UIColor, action: @escaping (() -> Void)) {
        buttons.append(OptionButton(image: image, title: title, color: color, action: action))
    }
    
    fileprivate func setupButton(tag: Int, item: OptionButton) -> UIButton {
        let button = HighlightingButton(color: item.color)
        button.tag = tag
        button.setTitle(item.title, for: .normal)
        button.setImage(item.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(performAction(_:)), for: .touchUpInside)
        button.addLine(position: .Bottom)
        return button
    }
    
    fileprivate func setupTitleLabel() {
        if titleText == nil { return }
        containerView.addSubview(titleLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        titleLabel.text = titleText
        heightOfContainer += titleHeight
    }
    
    fileprivate func setupMessageLabel() {
        if messageText == nil { return }
        // Add to Container
        containerView.addSubview(messageLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(messagePadding/2)-[v0]-\(messagePadding/2)-|", views: messageLabel)
        //Size the label && Height Dynamically
        messageLabel.text = messageText
        messageLabel.sizeToFit()
        let messageHeight = messageLabel.frame.height + messagePadding
        messageLabel.heightAnchor.constraint(equalToConstant: messageHeight).isActive = true
        //Descide Where to anchor and anchor
        let yAnchor = titleText == nil ? containerView.topAnchor : titleLabel.bottomAnchor
        messageLabel.topAnchor.constraint(equalTo: yAnchor).isActive = true
        heightOfContainer += messageHeight
    }
    
    fileprivate func setupButtons() {
        var actionButtons = [UIButton]()
        for (index, item) in buttons.enumerated() {
            let tag = tagBase + index
            actionButtons.append(setupButton(tag: tag, item: item))
        }
        actionButtons.append(cancel)
        let buttonsContainer: UIStackView = {
            let stack = UIStackView(arrangedSubviews: actionButtons)
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.addLine(position: .Top, width: 0.50)
            return stack
        }()
        let buttonsContainerHeight = CGFloat(actionButtons.count) * buttonHeight
        containerView.addSubview(buttonsContainer)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: buttonsContainer)
        buttonsContainer.heightAnchor.constraint(equalToConstant: buttonsContainerHeight).isActive = true
        let YAnchor = messageText == nil ?
            (titleText == nil ? containerView.topAnchor: titleLabel.bottomAnchor) : messageLabel.bottomAnchor
        buttonsContainer.topAnchor.constraint(equalTo: YAnchor).isActive = true
        heightOfContainer += buttonsContainerHeight
    }
    
    fileprivate func setupContainer() {
        view.addSubview(containerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        setupTitleLabel()
        setupMessageLabel()
        setupButtons()
        
        containerView.heightAnchor.constraint(equalToConstant: heightOfContainer).isActive = true
        containerView.layer.transform = CATransform3DMakeTranslation(0, heightOfContainer, 0)
    }
    
    @objc fileprivate func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let heightOfBackground = view.frame.height - heightOfContainer
        if(location.y < heightOfBackground) {
            dissmissView()
        }
    }
    
    fileprivate func dissmissView() {
        UIView.animate(withDuration: 0.3,
        delay: 0.2,
        usingSpringWithDamping: 0.9,
        initialSpringVelocity: 0,
        options: .curveEaseIn,
        animations: {[unowned self] in
            self.containerView.layer.transform = CATransform3DMakeTranslation(0,self.heightOfContainer, 0)
        }, completion: {[unowned self] (_) in
                self.firstResponder?.becomeFirstResponder()
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
    
    @objc fileprivate func performAction(_ sender: UIButton) {
        let index = Int(sender.tag % tagBase)
        let function = buttons[index].action
        function()
        dissmissView()
    }
    
    @objc fileprivate func dissmissPressed() {
        dissmissView()
    }
}
