import UIKit
import Firebase

class Register: UIViewController {
    //MARK: COnstants
    let icon_height: CGFloat = 24.0
    let profile_height: CGFloat = 110.0
    let logo_padding: CGFloat? =  30.0
    let view_padding: CGFloat =  20.0
    let sliding_height: CGFloat = 200
    let ID = "RegisterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    var image_url: NSURL?
    
    //MARK: Profile
    lazy var picker: UIImagePickerController = {
        let image_picker = UIImagePickerController()
        image_picker.delegate = self
        image_picker.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        return image_picker
    }()
    lazy var profile_image: UIImageView = {
        let profile = UIImageView()
        profile.image = UIImage(named: "select_profile")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(select_image))
        profile.addGestureRecognizer(gesture)
        profile.isUserInteractionEnabled = true
        profile.contentMode = .scaleAspectFill
        profile.clipsToBounds = true
        profile.layer.cornerRadius = profile_height/2
        return profile
    }()
    fileprivate func setup_profile() {
        view.addSubview(profile_image)
        view.center_X(item: profile_image)
        profile_image.widthAnchor.constraint(equalToConstant: profile_height).isActive = true
    }
    
    //MARK: Sliding view
    lazy var options: ProfileOptions = {
        let slider = ProfileOptions()
        slider.container = self
        return slider
    }()
    lazy var slidingViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collections = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collections.dataSource = self
        collections.delegate = self
        collections.backgroundColor = .clear
        collections.register(OptionsCell.self, forCellWithReuseIdentifier: ID)
        collections.isPagingEnabled = true
        collections.showsHorizontalScrollIndicator = false
        return collections
    }()
    
    //MARK: Personal Information - Components
    fileprivate func setup_basic_area() {
        basic_area.addSubview(personal_label)
        basic_area.addConstraintsWithFormat(format: "H:|-30-[v0]", views: personal_label)
        setup_name()
        setup_email()
        setup_phone()
        let height = view.frame.height - (logo_padding! + profile_height + 50.0 + UIApplication.shared.statusBarFrame.height + sliding_height)
        basic_area.addConstraintsWithFormat(format: "V:|-\(height)-[v0]-5-[v1(\(icon_height))]-18-[v2(\(icon_height))]-18-[v3(\(icon_height))]", views: personal_label, name_field, email_field, phone_field)
    }
    lazy var basic_area: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: sliding_height))
        view.backgroundColor = .clear
        return view
    }()
    let personal_label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 15)
        label.textColor = .white
        label.text = "Personal Information"
        return label
    }()
    
    //MARK: Email
    let email_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.50)
        return view
    }()
    let email_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "email")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var email_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.delegate = self
        field.autocapitalizationType = .none
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.autocorrectionType = .no
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_email() {
        basic_area.addSubview(email_image)
        basic_area.addSubview(email_line)
        basic_area.addSubview(email_field)
        email_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        email_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        email_image.topAnchor.constraint(equalTo: email_field.topAnchor).isActive = true
        basic_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: email_line)
        email_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        email_line.topAnchor.constraint(equalTo: email_field.bottomAnchor, constant: 8).isActive = true
        basic_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: email_image, email_field)
    }
    
    //MARK: Name
    let name_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let name_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "name")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var name_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.autocapitalizationType = .words
        field.delegate = self
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Name (First & Last)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_name() {
        basic_area.addSubview(name_image)
        basic_area.addSubview(name_line)
        basic_area.addSubview(name_field)
        name_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        name_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        name_image.topAnchor.constraint(equalTo: name_field.topAnchor).isActive = true
        basic_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: name_line)
        name_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        name_line.topAnchor.constraint(equalTo: name_field.bottomAnchor, constant: 8).isActive = true
        basic_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: name_image, name_field)
    }
    
    //MARK: Phone
    let phone_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let phone_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "phone_register")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var phone_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.delegate = self
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "Phone", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_phone() {
        basic_area.addSubview(phone_image)
        basic_area.addSubview(phone_line)
        basic_area.addSubview(phone_field)
        phone_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        phone_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        phone_image.topAnchor.constraint(equalTo: phone_field.topAnchor).isActive = true
        basic_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: phone_line)
        phone_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        phone_line.topAnchor.constraint(equalTo: phone_field.bottomAnchor, constant: 8).isActive = true
        basic_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: phone_image, phone_field)
    }

    //MARK: Address- Components
    fileprivate func setup_address_area() {
        address_area.addSubview(address_label)
        address_area.center_X(item: address_label)
        setup_street()
        setup_city()
        setup_zip_state()
        let height = view.frame.height - (logo_padding! + profile_height + 70.0 + UIApplication.shared.statusBarFrame.height + sliding_height)
        address_area.addConstraintsWithFormat(format: "V:|-\(height)-[v0]-5-[v1(\(icon_height))]-18-[v1(\(icon_height))]-18-[v2(\(icon_height))]-18-[v3(\(icon_height))]", views: address_label, street_field, city_field, zip_field)
        address_area.addConstraintsWithFormat(format: "V:|-\(height)-[v0]-5-[v1(\(icon_height))]-18-[v1(\(icon_height))]-18-[v2(\(icon_height))]-18-[v3(\(icon_height))]", views: address_label, street_field, city_field, state_field)
    }
    
    let address_label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 15)
        label.textColor = .white
        label.text = "Address Information"
        return label
    }()
    
    //MARK: Street
    let street_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let street_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "street").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var street_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.autocapitalizationType = .words
        field.delegate = self
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "123 Main Street", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_street() {
        address_area.addSubview(street_image)
        address_area.addSubview(street_line)
        address_area.addSubview(street_field)
        street_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        street_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        street_image.topAnchor.constraint(equalTo: street_field.topAnchor).isActive = true
        address_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: street_line)
        street_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        street_line.topAnchor.constraint(equalTo: street_field.bottomAnchor, constant: 8).isActive = true
        address_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: street_image, street_field)
    }

    //MARK: City
    lazy var address_area: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: sliding_height))
        view.backgroundColor = .clear
        return view
    }()
    let city_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let city_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "city").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var city_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.autocapitalizationType = .words
        field.delegate = self
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "City", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_city() {
        address_area.addSubview(city_image)
        address_area.addSubview(city_line)
        address_area.addSubview(city_field)
        city_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        city_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        city_image.topAnchor.constraint(equalTo: city_field.topAnchor).isActive = true
        address_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: city_line)
        city_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        city_line.topAnchor.constraint(equalTo: city_field.bottomAnchor, constant: 8).isActive = true
        address_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: city_image, city_field)
    }
    
    //MARK: Zip
    let zip_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let zip_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "zip").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var zip_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.autocapitalizationType = .words
        field.delegate = self
        field.returnKeyType = .next
        field.autocorrectionType = .no
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "11001", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_zip_state() {
        address_area.addSubview(zip_image)
        address_area.addSubview(zip_line)
        address_area.addSubview(zip_field)
        zip_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        zip_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        zip_image.topAnchor.constraint(equalTo: zip_field.topAnchor).isActive = true
        address_area.addConstraintsWithFormat(format: "H:|-25-[v0(110)]-40-[v1(110)]", views: zip_line, state_line)
        zip_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        zip_line.topAnchor.constraint(equalTo: zip_field.bottomAnchor, constant: 8).isActive = true
        
        address_area.addSubview(state_image)
        address_area.addSubview(state_line)
        address_area.addSubview(state_field)
        state_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        state_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        state_image.topAnchor.constraint(equalTo: state_field.topAnchor).isActive = true
        state_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        state_line.topAnchor.constraint(equalTo: state_field.bottomAnchor, constant: 8).isActive = true
        
        let width = 100 - icon_height - 10
        address_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1(\(width))]-40-[v2]-10-[v3(\(width))]", views: zip_image, zip_field, state_image, state_field)
    }
    //MARK: State
    let state_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let state_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "state").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var state_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.autocapitalizationType = .allCharacters
        field.delegate = self
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .done
        field.attributedPlaceholder =   NSAttributedString(string: "CA", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()

    //MARK: Security-Components
    lazy var security_area: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: sliding_height))
        view.backgroundColor = .clear
        return view
    }()
    fileprivate func setup_security_area() {
        security_area.addSubview(security_label)
        security_area.addConstraintsWithFormat(format: "H:[v0]-30-|", views: security_label)
        setup_password()
        setup_ssn()
        setup_birthdate()
        let height = view.frame.height - (logo_padding! + profile_height + 70.0 + UIApplication.shared.statusBarFrame.height + sliding_height)
        security_area.addConstraintsWithFormat(format: "V:|-\(height)-[v0]-5-[v1(\(icon_height))]-18-[v2(\(icon_height))]-18-[v3(\(50))]", views: security_label, password_field, ssn_field, birthdate_field)
    }
    
    let security_label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 15)
        label.textColor = .white
        label.text = "Security Information"
        return label
    }()
    
    //MARK: Birthdate
    let birthdate_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let birthdate_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "birthdate").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var birthdate_field: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .clear
        picker.tintColor = .white
        picker.setValue(UIColor.white, forKeyPath: "textColor")
        picker.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        picker.addTarget(self, action: #selector(tapped), for: .allTouchEvents)
        return picker
    }()
    fileprivate func setup_birthdate() {
        security_area.addSubview(birthdate_image)
        security_area.addSubview(birthdate_line)
        security_area.addSubview(birthdate_field)
        birthdate_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        birthdate_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        birthdate_image.centerYAnchor.constraint(equalTo: birthdate_field.centerYAnchor).isActive = true
        security_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: birthdate_line)
        birthdate_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        birthdate_line.topAnchor.constraint(equalTo: birthdate_field.bottomAnchor, constant: 8).isActive = true
        security_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: birthdate_image, birthdate_field)
    }
    
    //MARK: SSN
    let ssn_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let ssn_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "ssn").withRenderingMode(.alwaysTemplate)
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var ssn_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.delegate = self
        field.autocapitalizationType = .none
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.returnKeyType = .next
        field.attributedPlaceholder =   NSAttributedString(string: "SSN (Last 4)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.autocorrectionType = .no
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_ssn() {
        security_area.addSubview(ssn_image)
        security_area.addSubview(ssn_line)
        security_area.addSubview(ssn_field)
        ssn_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        ssn_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        ssn_image.topAnchor.constraint(equalTo: ssn_field.topAnchor).isActive = true
        security_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: ssn_line)
        ssn_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        ssn_line.topAnchor.constraint(equalTo: ssn_field.bottomAnchor, constant: 8).isActive = true
        security_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: ssn_image, ssn_field)
    }
    
    //MARK: Password
    let password_line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.40)
        return view
    }()
    let password_image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "password")
        image.tintColor = .white
        image.contentMode = .scaleAspectFill
        return image
    }()
    lazy var password_field: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.borderStyle = .none
        field.backgroundColor = .clear
        field.isSecureTextEntry = true
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.delegate = self
        field.returnKeyType = .next
        field.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16.5)
        field.attributedPlaceholder =   NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        field.textColor = .white
        field.addTarget(self, action: #selector(valueChange), for: .allEditingEvents)
        return field
    }()
    fileprivate func setup_password() {
        security_area.addSubview(password_image)
        security_area.addSubview(password_line)
        security_area.addSubview(password_field)
        password_image.widthAnchor.constraint(equalToConstant: icon_height).isActive = true
        password_image.heightAnchor.constraint(equalToConstant: icon_height).isActive = true
        password_image.topAnchor.constraint(equalTo: password_field.topAnchor).isActive = true
        security_area.addConstraintsWithFormat(format: "H:|-25-[v0]-25-|", views: password_line)
        password_line.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        password_line.topAnchor.constraint(equalTo: password_field.bottomAnchor, constant: 8).isActive = true
        security_area.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1]-30-|", views: password_image, password_field)
    }
    
    //MARK: SignIn
    let signin_view: UIView = {
        let view = UIView()
        return view
    }()
    let signin_label: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    let signin_button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.theme_unselected, for: .normal)
        button.setTitleColor(UIColor.theme_unselected.withAlphaComponent(0.65), for: .highlighted)
        button.isUserInteractionEnabled = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitle("Sign In.", for: .normal)
        button.addTarget(self, action: #selector(signin), for: .touchUpInside)
        return button
    }()
    fileprivate func setup_signIn() {
        view.addSubview(signin_view)
        signin_view.addSubview(signin_label)
        signin_view.addSubview(signin_button)
        view.addConstraintsWithFormat(format: "V:[v0(20)]-16-|", views: signin_view)
        signin_view.widthAnchor.constraint(equalToConstant: 233).isActive = true
        view.center_X(item: signin_view)
        signin_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signin_label)
        signin_view.addConstraintsWithFormat(format: "H:|[v0(176)][v1(63)]", views: signin_label, signin_button)
        signin_view.addConstraintsWithFormat(format: "V:|[v0]|", views: signin_button)
    }
    
    //MARK: SignUp
    lazy var signup_button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.isUserInteractionEnabled = false
        button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
        button.setTitle("Sign Up", for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(signup_clicked), for: .touchUpInside)
        return button
    }()
    fileprivate func setup_signUp() {
        view.addSubview(signup_button)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: signup_button)
    }
    
    //MARK: View Setup
    fileprivate func setup() {
        //Main View
        view.backgroundColor = .theme
        view.addSubview(options)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: options)
        view.addSubview(slidingViews)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: slidingViews)
 
        //Setup Component
        setup_signIn()
        setup_signUp()
        setup_profile()
        setup_basic_area()
        setup_security_area()
        setup_address_area()
        
        //Relative possition
        view.addConstraintsWithFormat(format: "V:|-\(logo_padding!)-[v0(\(profile_height))][v1(50)][v2(\(sliding_height))][v3(50)]", views: profile_image,options,slidingViews, signup_button)
    }
    
    //MARK: Actions
    @objc func signin()
    {
        let controller = Login()
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
    @objc func signup_clicked() {
        view.endEditing(true)
        let background_blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        let activity_indicator = TextActivity(text: "Signing Up!")
        background_blur.frame = view.frame
        if !validate_input(){ return }
        
        //Add Blur view
        view.addSubview(background_blur)
        view.addSubview(activity_indicator)
        activity_indicator.show()
        activity_indicator.alpha = 0
        background_blur.alpha = 0
        activity_indicator.layer.transform = CATransform3DMakeTranslation(0, view.frame.height/2, 0)
        //Get Parameters
        let email = email_field.text!
        let password = password_field.text!
        let phone = phone_field.text!
        let name = name_field.text!
        let street = street_field.text!
        let city = city_field.text!
        let state = state_field.text!
        let zip = zip_field.text!
        let ssn = ssn_field.text!
        let birthdate = birthdate_field.date
        //Add animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            background_blur.alpha = 1.0
            activity_indicator.alpha = 1.0
            activity_indicator.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }) { (_) in
            //Make API Call to register
            create_user(phone: phone, password: password, email: email, name: name, address: street, city: city, state: state, zip: zip, birthdate: birthdate, ssn: ssn ) {[unowned self] (res) in
                //Remove animations
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[unowned self] in
                    background_blur.alpha = 0
                    activity_indicator.alpha = 0
                    activity_indicator.layer.transform = CATransform3DMakeTranslation(0, self.view.frame.height/2, 0)
                }, completion: {[unowned self] (_) in
                    background_blur.removeFromSuperview()
                    activity_indicator.removeFromSuperview()
                    if res.isFailure {
                        present_alert_error(message: .no_internet, target: self)
                        return
                    }
                    let response = res.value as! [String: Any]
                    let message = response["message"] as! String
                    //Email Exists
                    if  message == "EMAIL_EXISTS" {
                        present_alert_error(message: .duplicate_account, target: self)
                        return
                    }
                    //Phone Exists
                    else if message == "PHONE_NUMBER_EXISTS" {
                        present_alert_error(message: .duplicate_phone, target: self)
                        return
                    }
                    //Identity check failed
                    else if message == "ERROR" {
                        present_alert_error(message: .identity_unverified, target: self)
                        return
                    }
                    //Upload image
                    let uid = response["uid"] as! String
                    upload_to_S3(key: uid, data: self.image_url!, bucket: .profiles)
                    //Present success
                    present_alert_with_handler_and_message(message: .account_created, target: self, handler: { [unowned self](_) in
                        self.signin()
                    })
                })
            }
        }
    }
    
    fileprivate func validate_input() -> Bool {
        if image_url == nil {
            present_alert_error(message: .incorrect_profile, target: self)
            return false
        }
        return true
    }
    
    @objc func select_image() {
        let actions = image_picker_action_sheet(controller: self, picker: picker, action1: "Choose from Library", action2: "Take a picture", camera: .front)
        execute_on_main { [unowned self] in
            self.present(actions, animated: true, completion: nil)
        }
    }
}

//MARK: Transitioning Delegates
extension Register: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return slide_backward()
    }
}

//MARK: Textfield Delegates
extension Register: UITextFieldDelegate{
    func textfields_valid() -> Bool {
        return valid_email(email: email_field.text!)  && valid_password(password: password_field.text!) && valid_phone(phone: phone_field.text!) && valid_name(name: name_field.text!) && valid_street(street: street_field.text!) && valid_city(city: city_field.text!) && valid_zip(zip: zip_field.text!) && valid_state(state: state_field.text!) && valid_ssn(ssn: ssn_field.text!) && valid_birthdate(birthdate: birthdate_field.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func valueChange() {
        if textfields_valid() {
            signup_button.isUserInteractionEnabled = true
            signup_button.backgroundColor = .theme_unselected
        } else  {
            signup_button.isUserInteractionEnabled = false
            signup_button.backgroundColor = UIColor.theme_unselected.withAlphaComponent(0.75)
        }
    }
    
    @objc fileprivate func tapped() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name_field {
            email_field.becomeFirstResponder()
        } else if textField == email_field {
            phone_field.becomeFirstResponder()
        } else if textField == phone_field {
            street_field.becomeFirstResponder()
            scroll_to_menu_item(item: 1)
        } else if textField == street_field {
            city_field.becomeFirstResponder()
        } else if textField == city_field {
            zip_field.becomeFirstResponder()
        } else if textField == zip_field {
            state_field.becomeFirstResponder()
        } else if textField == state_field {
            view.endEditing(true)
        } else if textField == password_field {
            ssn_field.becomeFirstResponder()
        } else if textField == ssn_field {
            view.endEditing(true)
        }
        return false
    }
}

//MARK: Image Picker Options
extension Register: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            profile_image.image = image
            image_url = image.get_temporary_path(quality: 0.50)
        } else { return }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Sliding Collection view Datasource & Delegate
extension Register: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(options.count())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! OptionsCell
        if indexPath.item == 0 {
            cell.insert_component(component: basic_area)
        } else if indexPath.item == 1 {
            cell.insert_component(component: address_area)
        } else if indexPath.item == 2 {
            cell.insert_component(component: security_area)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scroll_to_menu_item(item: Int) {
        view.endEditing(true)
        let path = IndexPath(item: item, section: 0)
        slidingViews.scrollToItem(at: path, at: .left, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        view.endEditing(true)
        let index = targetContentOffset.pointee.x/view.frame.width
        let path = IndexPath(item: Int(index), section: 0)
        options.Menu.selectItem(at: path, animated: true, scrollPosition: .left)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
