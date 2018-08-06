import UIKit

class MenuCell: BaseCollectionViewCell {
    
    let MenuItem: UIImageView = {
        let item = UIImageView()
        return item
    }()
    
    override func setup_cell()
    {
        super.setup_cell()
        //Add the imageView
        addSubview(MenuItem)
        addConstraintsWithFormat(format: "H:[v0(32)]", views: MenuItem)
        addConstraintsWithFormat(format: "V:[v0(32)]", views: MenuItem)
        
        //Add centring constraints
        center_X(item: MenuItem)
        center_Y(item: MenuItem)
    }
    
    override var isHighlighted: Bool {
        didSet {
            MenuItem.tintColor = isHighlighted ? UIColor.white: UIColor.theme_unselected
        }
    }
    
    override var isSelected: Bool {
        didSet {
            MenuItem.tintColor = isSelected ? UIColor.white: UIColor.theme_unselected
        }
    }
}
