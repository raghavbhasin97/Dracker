import UIKit
import DZNEmptyDataSet

class FriendDetail: UIViewController {

    let ID = "FridensDetailCell"
    let profile_height: CGFloat = 70
    let profile_width: CGFloat = 60
    let empty_icons = [#imageLiteral(resourceName: "empty_transactions"), #imageLiteral(resourceName: "sent"), #imageLiteral(resourceName: "recieved")]
    let empty_titles = ["No pending", "No money sent", "No money recieved"]
    let padding: CGFloat = 5
    var transactions_list: [Friends_Data] = []
    var filtered_list: [Friends_Data] = []
    var uid: String?
    var name: String?
    var amount: Double?
    var phone: String?
    var width_anchor: NSLayoutConstraint?
    var height_anchor: NSLayoutConstraint?
    var previous_index: Int = 0
    
    lazy var image_view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = padding
        return view
    }()
    
    lazy var info: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var header_view: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        return view
    }()
    
    lazy var profile_image: ActivityImageView = {
        let image_view = ActivityImageView()
        image_view.contentMode = .scaleAspectFill
        image_view.clipsToBounds = true
        image_view.translatesAutoresizingMaskIntoConstraints = false
        image_view.layer.cornerRadius = padding
        image_view.image = #imageLiteral(resourceName: "default_profile")
        return image_view
    }()
    
    lazy var details: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.rowHeight = 60.0
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        table.tableFooterView = UIView()
        return table
    }()
    
    lazy var name_label: UILabel = {
        let label = UILabel()
        label.textColor = .theme
        label.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        return label
    }()
    
    lazy var handel_label: UILabel = {
        let label = UILabel()
        label.textColor = .theme
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var amount_label: UILabel = {
        let label = UILabel()
        label.textColor = .theme
        label.font = UIFont(name: "Avenir-Book", size: 50)
        return label
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        return view
    }()
    
    lazy var selector: UISegmentedControl = {
        let segmented = UISegmentedControl()
        segmented.tintColor = .theme
        segmented.insertSegment(withTitle: "Recieved", at: 0, animated: false)
        segmented.insertSegment(withTitle: "Sent", at: 0, animated: false)
        segmented.insertSegment(withTitle: "Pedning", at: 0, animated: false)
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(segmented_tapped), for: .valueChanged)
        return segmented
    }()
    
    lazy var phone_button: UIButton = {
        let phone = UIButton()
        phone.setImage(#imageLiteral(resourceName: "phone_register"), for: .normal)
        phone.addTarget(self, action: #selector(call), for: .touchUpInside)
        return phone
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup_image(header_height: CGFloat) {
        view.addSubview(image_view)
        let view_width: CGFloat = profile_width + 1.5*padding
        view.addConstraintsWithFormat(format: "H:|-\(2*padding)-[v0(\(view_width))]", views: image_view)
        image_view.addSubview(profile_image)
        image_view.addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: profile_image)
        image_view.addConstraintsWithFormat(format: "V:|-\(padding)-[v0]-\(padding)-|", views: profile_image)
        let image_height: CGFloat = header_height - (profile_height*0.45)
        let view_height: CGFloat = profile_height + 1.5*padding
        view.addConstraintsWithFormat(format: "V:|-\(image_height)-[v0(\(view_height))]", views: image_view)
        view.bringSubviewToFront(image_view)
    }
    
    fileprivate func setup_header_view() {
        view.addSubview(header_view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: header_view)
        header_view.addSubview(phone_button)
        header_view.addConstraintsWithFormat(format: "H:[v0(35)]-20-|", views: phone_button)
        header_view.addConstraintsWithFormat(format: "V:[v0(35)]-10-|", views: phone_button)
    }
    
    fileprivate func setup_table() {
        view.addSubview(details)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: details)
    }
    
    fileprivate func setup_info() {
        view.addSubview(info)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: info)
    }
    
    fileprivate func setup_user_data() {
        info.addSubview(name_label)
        info.addSubview(handel_label)
        info.addSubview(amount_label)
        info.addSubview(divider)
        info.addSubview(selector)
        info.addConstraintsWithFormat(format: "H:|-\(2*padding)-[v0]", views: name_label)
        info.addConstraintsWithFormat(format: "H:|-\(2*padding)-[v0]", views: handel_label)
        info.addConstraintsWithFormat(format: "V:|-\(0.70*profile_height)-[v0]-2-[v1]-5-[v2]", views: name_label, handel_label, selector)
        info.addConstraintsWithFormat(format: "V:|-10-[v0]", views: amount_label)
        info.addConstraintsWithFormat(format: "H:[v0]-40-|", views: amount_label)
        info.addConstraintsWithFormat(format: "H:|[v0]|", views: divider)
        info.addConstraintsWithFormat(format: "H:|-\(padding)-[v0]-\(padding)-|", views: selector)
        divider.bottomAnchor.constraint(equalTo: info.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    fileprivate func setup() {
        //Setup Background
        view.backgroundColor = .white
        let header_height: CGFloat = (navigationController?.navigationBar.frame.height)!
        
        setup_header_view()
        setup_table()
        setup_info()
        setup_image(header_height: header_height)
        details.register(FriendsDetailCell.self, forCellReuseIdentifier: ID)
        setup_user_data()
        //Common Vertial Arrangement
        view.addConstraintsWithFormat(format: "V:|[v0(\(header_height))][v1(130)][v2]|", views: header_view, info, details)
    }
    
    func setup_data() {
        profile_image.init_from_S3(key: uid!, bucket_name: .profiles)
        name_label.text = name!
        handel_label.text = generate_handel()
        amount_label.text = amount?.as_amount()
        if amount! < 0.0 {
            amount_label.textColor = .delete_action
        } else if amount! > 0.0 {
            amount_label.textColor = .settle_action
        } else {
             amount_label.textColor = .theme
        }
        filter_data(index: 0)
        details.reloadData()
    }
    
    @objc fileprivate func call() {
        let phone_string = "tel://\(phone!)"
        let url: NSURL = URL(string: phone_string)! as NSURL
        UIApplication.shared.open(url as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

extension FriendDetail : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = details.dequeueReusableCell(withIdentifier: ID, for: indexPath) as! FriendsDetailCell
        cell.create_view(data: filtered_list[indexPath.row])
        return cell
    }
}

//MARK: Data Functions
extension FriendDetail {
    
    fileprivate func generate_handel() -> String{
        let text = name!
        return "@" + String(text.replacingOccurrences(of: " ", with: "-"))
    }
    
    @objc func segmented_tapped(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        var delete_indices:  [IndexPath] = []
        for index in 0..<filtered_list.count {
            delete_indices.append(IndexPath(row: index, section: 0))
        }
        filter_data(index: index)
        var insert_indices:  [IndexPath] = []
        for index in 0..<filtered_list.count {
            insert_indices.append(IndexPath(row: index, section: 0))
        }
        
        let delete_animation = UITableView.RowAnimation.top
        let settle_antimation = UITableView.RowAnimation.top
        
        details.beginUpdates()
        details.deleteRows(at: delete_indices, with: delete_animation)
        details.insertRows(at: insert_indices, with: settle_antimation)
        details.endUpdates()
        previous_index = index
    }
    
    fileprivate func filter_data(index: Int) {
        if index == 0 {
            filtered_list = transactions_list.filter({ (data) -> Bool in
                return data.settelement_time == nil
            })
        } else if index == 1 {
            filtered_list = transactions_list.filter({ (data) -> Bool in
                return data.settelement_time != nil && data.is_debt
            })
        } else if index == 2 {
            filtered_list = transactions_list.filter({ (data) -> Bool in
                return data.settelement_time != nil && !data.is_debt
            })
        } else {
            fatalError("Internal Inconsistency")
        }
    }
}

//MARK: Empty Table view
extension FriendDetail: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return filtered_list.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)]
        return NSAttributedString(string: empty_titles[selector.selectedSegmentIndex], attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        return NSAttributedString(string: "", attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return empty_icons[selector.selectedSegmentIndex]
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
