import UIKit

class ProfileOptions: UIView {
    
    let ID = "MenuCell"
    var container: Register?
    var menu_items = ["basic","address" ,"security"]
    let view_padding: CGFloat = 20
    
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: UICollectionView Delegates
extension ProfileOptions: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
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
        return CGSize(width: frame.width/count(), height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        container?.scroll_to_menu_item(item: indexPath.item)
    }
}
