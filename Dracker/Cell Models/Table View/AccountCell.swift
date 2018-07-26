import UIKit

class AccountCell: BaseTableViewCell {
    let size: CGFloat = 40
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 17)
        return label
    }()
    lazy var image_view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.65)
        view.clipsToBounds = true
        view.layer.cornerRadius = size/2
        return view
    }()
    let institution: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 17)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate func setup_image() {
        addSubview(image_view)
        image_view.addSubview(institution)
        image_view.addConstraintsWithFormat(format: "H:|[v0]|", views: institution)
        image_view.addConstraintsWithFormat(format: "V:|[v0]|", views: institution)
        addConstraintsWithFormat(format: "H:|-10-[v0(\(size))]", views: image_view)
        center_Y(item: image_view)
        image_view.heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        addSubview(name)
        setup_image()
        addConstraintsWithFormat(format: "H:[v0]-100-|", views: name)
        center_Y(item: name)
    }
    
    func setup(account: Account) {
        name.text = account.name
        institution.text = get_initial(institution: account.institution)
        if (institution.text?.count)! > 3 {
            let size = 17.0 - (0.5 * CGFloat((institution.text?.count)!))
            institution.font =  UIFont(name: "Avenir-Book", size: size)
        }
    }
    
    fileprivate func get_initial(institution: String) -> String{
        var institution_initials = ""
        let comps = institution.components(separatedBy: " ")
        for component in comps {
            let initial = component[component.startIndex]
            institution_initials += String(initial)
        }
        return institution_initials
    }
}
