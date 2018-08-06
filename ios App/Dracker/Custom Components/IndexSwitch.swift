import UIKit

class IndexSwitch: UISwitch {
    var itemIndex: Int!
    let defaults_key = ["auto_login", "touch", "reminder", "sound"]
    init(frame: CGRect, itemIndex: Int ) {
        super.init(frame: frame)
        self.itemIndex = itemIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set_possition() {
        self.setOn(UserDefaults.standard.bool(forKey: defaults_key[itemIndex!]), animated: false)
    }
}
