import UIKit

class FriendDetail: UIViewController {
    let ID = "FridensDetailCell"
    let profile_size: CGFloat = 150
    var transactions_list: [Friends_Data] = []
    var uid: String?
    var name: String?
    var width_anchor: NSLayoutConstraint?
    var height_anchor: NSLayoutConstraint?
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        return title
    }()
    lazy var profile_image: ActivityImageView = {
        let image_view = ActivityImageView()
        image_view.contentMode = .scaleAspectFit
        image_view.clipsToBounds = true
        image_view.translatesAutoresizingMaskIntoConstraints = false
        image_view.layer.cornerRadius = profile_size/2
        image_view.image = UIImage(named: "default_profile")
        return image_view
    }()
    
    lazy var details: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 80.0
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup_navigation() {
        navigationItem.titleView = navigation_title
        navigation_title.text = name
    }
    
    fileprivate func setup_image() {
        view.center_X(item: profile_image)
        width_anchor = profile_image.widthAnchor.constraint(equalToConstant: profile_size)
        view.addConstraintsWithFormat(format: "V:|-20-[v0]-10-[v1]-20-|", views: profile_image, details)
        height_anchor = profile_image.heightAnchor.constraint(equalToConstant: profile_size)
        width_anchor?.isActive = true
        height_anchor?.isActive = true
    }
    
    fileprivate func setup() {
        view.backgroundColor = .white
        view.addSubview(profile_image)
        view.addSubview(details)
        setup_image()
        details.register(FriendsDetailCell.self, forCellReuseIdentifier: ID)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: details)
    }
    
    func setup_data() {
        setup_navigation()
        profile_image.init_from_S3(key: uid!, bucket_name: .profiles)
        details.reloadData()
    }
}

extension FriendDetail : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = details.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! FriendsDetailCell
        cell.create_view(data: transactions_list[indexPath.row])
        return cell
    }
}
