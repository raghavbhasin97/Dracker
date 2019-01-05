import UIKit

class FundingSourceCell: BaseTableViewCell {

    fileprivate let imageWidth: CGFloat = 55
    fileprivate let imageHeight: CGFloat = 55
    
    lazy var institutionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    override func setup() {
        backgroundColor = .white
        addLine(position: .Bottom)
    }
    
    fileprivate func setupInstitutionImage(base: UIView) {
        base.addSubview(institutionImage)
        institutionImage.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
        base.centerY(item: institutionImage)
    }
    
    fileprivate func setupName(base: UIView) {
        base.addSubview(name)
        base.centerY(item: name)
        name.leftAnchor.constraint(equalTo: institutionImage.rightAnchor, constant: 20).isActive = true
    }
    
    func setupSourceCell(item: FundingSource) {
        clearView()
        setupInstitutionImage(base: contentView)
        setupName(base: contentView)
        institutionImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        institutionImage.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        institutionImage.loadInstitution(name: item.institution)
        name.text = item.name
        if item.isDefault {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
    
    func setupAdd() {
        clearView()
        setupInstitutionImage(base: self)
        setupName(base: self)
        institutionImage.widthAnchor.constraint(equalToConstant: imageWidth/2).isActive = true
        institutionImage.heightAnchor.constraint(equalToConstant: imageHeight/2).isActive = true
        name.numberOfLines = 0
        institutionImage.image = #imageLiteral(resourceName: "addNew")
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "Add a funding source\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.55, weight: .bold)]))
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 1, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "No purchase fees", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        name.attributedText = attributedText
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: animated)
    }
    
    func clearView() {
        institutionImage.removeConstraints(institutionImage.constraints)
        removeConstraints(institutionImage.constraints)
        removeConstraints(name.constraints)
        institutionImage.removeFromSuperview()
        name.removeFromSuperview()
    }
    
}
