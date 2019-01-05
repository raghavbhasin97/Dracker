import UIKit

class ProfileChange: BaseViewController {

    fileprivate let profileSize: CGFloat = 150
    fileprivate let editSize: CGFloat = 40
    let progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var progressBarWidth: NSLayoutConstraint?
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightRed
        button.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "pencil"), for: .normal)
        button.addTarget(self, action: #selector(changeProfile), for: .touchUpInside)
        button.layer.cornerRadius = editSize/2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var picker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        picker.allowsEditing = false
        return picker
    }()
    
    let image: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "blankProfile"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = profileSize/2
        return imageView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "close").withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var name: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(currentUser.name, for: .normal)
        button.setImage(#imageLiteral(resourceName: "qrCode"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.themeLight, for: .normal)
        button.tintColor = .themeLight
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.addTarget(self, action: #selector(showQR), for: .touchUpInside)
        return button
    }()
    
    let headerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var email: IconField = {
        let field = IconField(image: #imageLiteral(resourceName: "email"), width: view.frame.width)
        field.addLine(position: .Bottom)
        field.textColor = .drBlack
        field.font = .systemFont(ofSize: 14.5)
        field.isEnabled = false
        field.text = currentUser.email
        return field
    }()
    
    lazy var phone: IconField = {
        let field = IconField(image: #imageLiteral(resourceName: "phone"), width: view.frame.width)
        field.addLine(position: .Bottom)
        field.textColor = .drBlack
        field.font = .systemFont(ofSize: 14.5)
        field.isEnabled = false
        field.text = currentUser.phone
        return field
    }()
    
    fileprivate func setupHeader() {
        view.addSubview(headerContainer)
        headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: headerContainer)
        //Setup Title
        let titleView: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.text = "PROFILE"
            label.font = .systemFont(ofSize: 15.5, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        headerContainer.addSubview(titleView)
        headerContainer.centerX(item: titleView)
        headerContainer.centerY(item: titleView)
        //Add close button
        headerContainer.addSubview(closeButton)
        headerContainer.centerY(item: closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    fileprivate func setupProfileImage() {
        image.addSubview(profileImage)
        image.centerX(item: profileImage)
        image.centerY(item: profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: profileSize).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: profileSize).isActive = true
        //Add Edit Button
        view.addSubview(editButton)
        editButton.widthAnchor.constraint(equalToConstant: editSize).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: editSize).isActive = true
        editButton.topAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: editSize/2 + (editSize/profileSize*editSize*0.06)).isActive = true
        editButton.leftAnchor.constraint(equalTo: profileImage.centerXAnchor, constant: profileSize/2 - editSize*0.70).isActive = true
    }
    
    fileprivate func setupName() {
        view.addSubview(name)
        view.centerX(item: name)
        name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15).isActive = true
    }
    
    fileprivate func setupImageView() {
        view.addSubview(image)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: image)
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: view.frame.height * 0.475).isActive = true
        //Load Image
        image.loadProfile(key: currentUser.uid) {[unowned self] (success) in
            //Since it is already cached just a fast return
            DispatchQueue.main.async {
                self.profileImage.loadProfile(key: currentUser.uid)
            }
        }
        //Add Blue
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        image.addSubview(blur)
        blur.fillSuperview()
        setupHeader()
        //Setup Profile Image View Not Blurred
        setupProfileImage()
    }
    
    fileprivate func setupProgressBar() {
        view.addSubview(progressBar)
        progressBar.heightAnchor.constraint(equalToConstant: 4.0).isActive = true
        progressBar.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 0.10).isActive = true
        progressBarWidth = progressBar.widthAnchor.constraint(equalToConstant: 0)
        progressBarWidth?.isActive = true
    }
    
    fileprivate func removeProgresBar() {
        progressBarWidth = nil
        progressBar.removeConstraints(progressBar.constraints)
        progressBar.removeFromSuperview()
    }
    
    fileprivate func updateProgressBar(percentComplete: CGFloat) {
        progressBarWidth?.constant = view.frame.width * percentComplete
        progressBar.layoutIfNeeded()
    }
    
    fileprivate func setupDetails() {
        
        let stack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [email, phone])
            stack.spacing = 10
            stack.axis = .vertical
            stack.distribution = .fillEqually
            return stack
        }()
        
        view.addSubview(stack)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: stack)
        stack.heightAnchor.constraint(equalToConstant: 110).isActive = true
        stack.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20).isActive = true
    }
    
    override func setup() {
        view.backgroundColor = .white
        setupImageView()
        setupName()
        setupDetails()
    }
    
    @objc fileprivate func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func changeProfile() {
        let options = OptionsController(title: "Update your Profile Image!", message: "Select an image from gallery or take a new one to replace your current Profile.")
        options.addButton(image: #imageLiteral(resourceName: "camera"), title: "Camera", color: .optionBlue) {
            [unowned self] in
            self.takePicture()
        }
        options.addButton(image: #imageLiteral(resourceName: "gallery"), title: "Photo Gallery", color: .optionGreen) { [unowned self] in
            self.selectFromGallery()
        }
        options.show()
    }
    
    @objc fileprivate func showQR() {
        let controller = QRCode()
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func selectFromGallery() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    fileprivate func takePicture() {
        picker.sourceType = .camera
        picker.cameraDevice = .front
        present(picker, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}

extension ProfileChange: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? NSURL {
            setupProgressBar()
            uploadProfileImage(key: currentUser.uid, data: url, confirmationBlock: {[unowned self] in
                DispatchQueue.main.async {
                    self.removeProgresBar()
                    self.presentConfirmation(image: #imageLiteral(resourceName: "upload"), message: "Profile Updated")
                    self.image.image = newImage
                    self.profileImage.image = newImage
                }
            }) {[unowned self] (_, uploaded, totalSize) in
                let percentComplete = CGFloat(uploaded)/CGFloat(totalSize)
                DispatchQueue.main.async {
                    self.updateProgressBar(percentComplete: percentComplete)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
