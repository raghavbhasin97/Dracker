import UIKit

class MenuBar: UIView {
    
    let ID = "MenuCell"
    var Home: Home?
    var menu_items = ["home", "transaction", "profile", "settings"]
    
    lazy var Menu: UICollectionView = {
        let menu = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        menu.backgroundColor = UIColor.theme
        menu.dataSource = self
        menu.delegate = self
        menu.register(MenuCell.self, forCellWithReuseIdentifier: ID)
        menu.isScrollEnabled = false
        return menu
    }()
    
    func count() -> CGFloat{
        return CGFloat(menu_items.count)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.theme
        //Add the menu and setup constraints
        self.addSubview(Menu)
        addConstraintsWithFormat(format: "H:|[v0]|", views: Menu)
        addConstraintsWithFormat(format: "V:|[v0]|", views: Menu)
        
        Menu.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.bottom)
        setup_slider()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var left_anchor: NSLayoutConstraint?
    
    func setup_slider() {
        let slider = UIView()
        slider.backgroundColor = UIColor(white: 0.95, alpha: 1)
        slider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(slider)
        left_anchor = slider.leftAnchor.constraint(equalTo: self.leftAnchor)
        left_anchor?.isActive = true
        slider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 4.0).isActive = true
        slider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
    }
}

//MARK: UICollectionView Delegates
extension MenuBar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu_items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! MenuCell
        cell.MenuItem.image = UIImage(named: menu_items[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.theme_unselected
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Home?.scroll_to_menu_item(item: indexPath.item)
    }
}
