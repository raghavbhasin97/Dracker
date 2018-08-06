import UIKit

class OptionsCell: BaseCollectionViewCell {
    
    lazy var content: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setup_cell() {
        super.setup_cell()
        addSubview(content)
        addConstraintsWithFormat(format: "H:|[v0]|", views: content)
        addConstraintsWithFormat(format: "V:|[v0]|", views: content)
    }
    
    func insert_component(component: UIView) {
        content.addSubview(component)
        content.addConstraintsWithFormat(format: "H:|[v0]|", views: component)
        content.addConstraintsWithFormat(format: "V:|[v0]|", views: component)
    }

}
