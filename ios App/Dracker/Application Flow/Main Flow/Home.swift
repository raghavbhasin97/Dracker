import UIKit
import LocalAuthentication
import UserNotifications

class Home: UIViewController {
    let Homecomponent = HomeView()
    let walletcomponent = Wallet()
    let background_blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    var activty: UIActivityIndicatorView? = {
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.color = .red
        return activity
    }()
    let add_action_height: CGFloat = 50.0
    let ID = "SlidingCell"
    let menu_height = CGFloat(50.0)
    let titles = [" Home", " Wallet", " Profile", " Settings"]
    // User details
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        uid = UserDefaults.standard.object(forKey: "uid") as? String
        UNUserNotificationCenter.current().delegate = self
        setup()
        loading_initial()
        navigationController?.navigationBar.isUserInteractionEnabled = false
        authorize {[unowned self] in
            fetch_data(user_id: self.uid!) {[unowned self] in
                self.stop_loading()
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                self.Homecomponent.tableView.reloadData()
            }
        }
    }
    
    lazy var menu_bar: MenuBar = {
        let menu = MenuBar()
        menu.Home = self
        return menu
    }()
    
    lazy var navigation_title: UILabel = {
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        title.textColor = UIColor.white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        return title
    }()
    
    lazy var slidingViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collections = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collections.dataSource = self
        collections.delegate = self
        collections.backgroundColor = UIColor.white
        collections.register(HomeCell.self, forCellWithReuseIdentifier: ID)
        collections.isPagingEnabled = true
        collections.showsHorizontalScrollIndicator = false
        collections.scrollIndicatorInsets = UIEdgeInsets(top: menu_height, left: 0, bottom: 0, right: 0)
        collections.contentInset = UIEdgeInsets(top: menu_height, left: 0, bottom: 0, right: 0)
        return collections
    }()
    lazy var create_button: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "create"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "create_h"), for: .highlighted)
        button.addTarget(self, action: #selector(create_transaction), for: .touchUpInside)
        return button
    }()
    
    lazy var create_view: UIView = {
        let view = UIView()
        view.backgroundColor = .theme
        view.clipsToBounds = true
        return view
    }()
    
    func stop_loading() {
        activty?.stopAnimating()
        activty?.removeFromSuperview()
        background_blur.removeFromSuperview()
    }
    
    func loading() {
        //Add Loading logic
        let window = UIScreen.main.bounds
        view.addSubview(background_blur)
        view.addSubview(activty!)
        
        background_blur.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        activty?.center = CGPoint(x: window.width/2, y: window.height/2)
        activty?.startAnimating()
        background_blur.alpha = 0
        activty?.layer.transform = CATransform3DMakeTranslation(0, view.frame.height/2, 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {[unowned self] in
            self.background_blur.alpha = 1.0
            self.activty?.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
            }, completion: nil)
    }
    
    func loading_initial() {
        //Add Loading logic
        let window = UIScreen.main.bounds
        view.addSubview(background_blur)
        view.addSubview(activty!)
        
        background_blur.frame = CGRect(x: 0, y: menu_height, width: view.frame.width, height: view.frame.height - 2*menu_height - add_action_height - UIApplication.shared.statusBarFrame.height)
        activty?.center = CGPoint(x: window.width/2, y: window.height/2)
        activty?.startAnimating()
    }
    
    fileprivate func setup()
    {
        //CollectionView
        view.addSubview(slidingViews)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: slidingViews)
        view.addConstraintsWithFormat(format: "V:|-\(menu_height)-[v0]-\(add_action_height)-|", views: slidingViews)
        
        //Menu
        view.addSubview(menu_bar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menu_bar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menu_bar)
        
        
        //NavBar
        navigation_title.text = "Home"
        navigationItem.titleView = navigation_title
        let scanner = UIBarButtonItem(image: #imageLiteral(resourceName: "scanner"), style: .plain, target: self, action: #selector(scan))
        scanner.width = 20
        scanner.tintColor = .white
        let contact = UIBarButtonItem(image: #imageLiteral(resourceName: "contact") , style: .plain, target: self, action: #selector(search_contact))
        contact.width = 20
        contact.tintColor = .white
        navigationItem.rightBarButtonItems = [scanner, contact]
        
        //Create Button
        view.addSubview(create_view)
        view.addConstraintsWithFormat(format: "V:[v0(55)]|", views: create_view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: create_view)
        create_view.addSubview(create_button)
        create_view.addConstraintsWithFormat(format: "V:[v0(\(add_action_height-10))]-7.5-|", views: create_button)
        create_view.center_X(item: create_button)
        create_button.widthAnchor.constraint(equalToConstant: add_action_height-10).isActive = true
    }
    
    fileprivate func select_menu_item(path: IndexPath) {
        menu_bar.Menu.selectItem(at: path, animated: true, scrollPosition: .left)
        UIView.animate(withDuration: 0.5) {
            self.navigation_title.text = self.titles[path.item]
        }
    }
}

extension Home: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(menu_bar.count())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! HomeCell
        if indexPath.item == 0 {
            Homecomponent.parent = self
            Homecomponent.setup()
            Homecomponent.uid = uid
            cell.insert_component(component: Homecomponent)
        } else if indexPath.item == 1 {
            walletcomponent.create_view()
            cell.insert_component(component: walletcomponent)
        } else if indexPath.item == 2 {
            let component = Profile()
            component.setup_view(uid: uid!, width: view.frame.width, parent: self)
            cell.insert_component(component: component)
        } else if indexPath.item == 3 {
            let component = Settings()
            component.parent = self
            cell.insert_component(component: component)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x_constant = scrollView.contentOffset.x
        menu_bar.left_anchor?.constant = x_constant/menu_bar.count()
    }
    
    func scroll_to_menu_item(item: Int)
    {
        self.navigation_title.text = self.titles[item]
        let path = IndexPath(item: item, section: 0)
        slidingViews.scrollToItem(at: path, at: .left, animated: true)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x/view.frame.width
        let path = IndexPath(item: Int(index), section: 0)
        select_menu_item(path: path)
    }
}

//MARK: UserNotifications
extension Home: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber -= 1
        let json = response.notification.request.content.userInfo
        var parameters: [String: String] = [:]
        parameters["transaction_id"] = json["transaction_id"] as? String
        parameters["uid"] = json["uid"] as? String
        get_transaction(parameter: parameters) {[unowned self] (data) in
            let result = data.value as! [String: Any]
            let is_debt = result["is_debt"] as! Bool
            let amount = result["amount"] as! String
            let description = result["description"] as! String
            let name = result["name"] as! String
            let tagged_image = result["tagged_image"] as! String
            let time = result["time"] as! String
            let uid = result["uid"] as! String
            let phone = result["phone"] as! String
            let transaction_id = result["transaction_id"] as! String
            let amount_value = Double(amount)!
            
            var transaction = Unsettled(is_debt: is_debt, amount: amount, description: description, name: name, tagged_image: tagged_image, time: time, uid: uid, phone: phone, notification_identifier: nil, transaction_id: transaction_id)
            if let notification_identifier = result["notification_identifier"] {
                transaction.notification_identifier = notification_identifier as? String
            }
            if response.actionIdentifier == "com.drakerapp.dracker.notification.view" {
                let controller = Detail()
                controller.dahsboard = self.Homecomponent
                controller.data = transaction
                self.navigationController?.pushViewController(controller, animated: false)
            } else if response.actionIdentifier == "com.drakerapp.dracker.notification.note" {
                let controller = Note()
                controller.data = transaction
                self.navigationController?.pushViewController(controller, animated: false)
            } else if response.actionIdentifier == "com.drakerapp.dracker.notification.settle" {
                let time = Date().as_string(format: .full)
                var parameters: [String: String] = [:]
                parameters["transaction_id"] = json["transaction_id"] as? String
                parameters["payee_uid"] = json["uid"] as? String
                parameters["payer_uid"] = json["payer_uid"] as? String
                parameters["time"] = time
                remove_notification(identifier: json["notification_identifier"] as? String)
                debit -= amount_value
                let settled = Settled(is_debt: is_debt, amount: amount, description: description, name: name)
                settled_transactions.insert(settled, at: 0)
                self.walletcomponent.create_view()
                self.loading()
                post_settle_transaction(parameters: parameters, completion: {[unowned self](data) in
                    if data.isFailure { return }
                    self.Homecomponent.refetch_data()
                })
            }
            completionHandler()
        }
    }
}


//MARK: Transaction screen
extension Home {
    @objc fileprivate func create_transaction() {
        let controller = AddTransaction()
        controller.dahsboard = Homecomponent
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: Extra Actions

extension Home {
    @objc fileprivate func search_contact() {
        let controller = Contacts()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc fileprivate func scan() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //Code Action
        let action_code = UIAlertAction(title: "Show Code", style: .default, handler: {[unowned self] (_) in
            let controller = QRCode()
            self.navigationController?.pushViewController(controller, animated: true)
        })
        action_code.setValue(UIColor.settle_action, forKey: "titleTextColor")
        alert.addAction(action_code)
        //Scan Action
        let action_scan = UIAlertAction(title: "Scan Code", style: .default, handler: {[unowned self] (_) in
            let controller = QRScanner()
            controller.home = self
            self.navigationController?.pushViewController(controller, animated: true)
        })
        action_scan.setValue(UIColor.delete_action, forKey: "titleTextColor")
        alert.addAction(action_scan)
        //Present
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
