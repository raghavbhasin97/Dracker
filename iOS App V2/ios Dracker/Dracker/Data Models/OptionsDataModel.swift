import UIKit

struct OptionItem {
    var icon: UIImage
    var title: String
    var accessoryType: UITableViewCell.AccessoryType?
    var accessoryView: UIView?
    var action: (() -> Void)?
    
    init(icon: UIImage, title: String, accessoryType: UITableViewCell.AccessoryType? = nil, accessoryView: UIView? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.accessoryType = accessoryType
        self.accessoryView = accessoryView
        self.action = action
    }
}

struct Option {
    var title: String
    var items: [OptionItem]
}

