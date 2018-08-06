import UIKit

class AccountCell: BaseTableViewCell {
    let size: CGFloat = 40
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 14)
        label.numberOfLines = 3
        label.textAlignment = .left
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
        contentView.addSubview(image_view)
        image_view.addSubview(institution)
        image_view.addConstraintsWithFormat(format: "H:|[v0]|", views: institution)
        image_view.addConstraintsWithFormat(format: "V:|[v0]|", views: institution)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0(\(size))]-50-[v1(120)]", views: image_view, name)
        contentView.center_Y(item: image_view)
        image_view.heightAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    override func setup() {
        backgroundColor = .white
        contentView.addSubview(name)
        setup_image()
        contentView.center_Y(item: name)
        name.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
    func setup(account: Account) {
        name.text = account.institution + " - " + account.name
        institution.text = get_initial(institution: account.institution)
        if account.is_default {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
        if (institution.text?.count)! > 3 {
            let size = 17.0 - (1.0 * CGFloat((institution.text?.count)!))
            institution.font =  UIFont(name: "Avenir-Book", size: size)
        }
    }
    
    fileprivate func get_initial(institution: String) -> String{
        var institution_initials = ""
        let comps = institution.components(separatedBy: " ")
        if comps.count == 1 { return institution }
        for component in comps {
            let initial = component[component.startIndex]
            institution_initials += String(initial)
        }
        return institution_initials
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }
}
