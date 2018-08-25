import UIKit
import Firebase

class Detail: UIViewController {
    
    //MARK: Fields
    var data: Unsettled?
    weak var dahsboard: HomeView?
    var index: IndexPath?
    var is_peeking: Bool = false
    
    //MARK: View Components
    lazy var transaction_image: ActivityImageView = {
        let image = ActivityImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        image.image = UIImage(named: "blank_transaction")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 4.0
        let tap_gesture = UITapGestureRecognizer(target: self, action: #selector(expand_image))
        if data?.tagged_image != "noImage"{
            image.isUserInteractionEnabled = true
        }
        image.addGestureRecognizer(tap_gesture)
        let long_press = UILongPressGestureRecognizer(target: self, action: #selector(save_image))
        long_press.minimumPressDuration = 1.0
        image.addGestureRecognizer(long_press)
        return image
    }()
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        return title
    }()
    
    let description_view: UITextView = {
        let text = UITextView()
        text.textAlignment = .center
        text.isScrollEnabled = false
        text.font = .systemFont(ofSize: 16)
        text.isEditable = false
        return text
    }()
    
    let amount_view: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 50)
        return label
    }()
    
    let created_label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .text_color
        label.text = "Added on"
        return label
    }()
    
    let time_stamp: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .text_color
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_navigation()
        setup()
        setup_components()
    }
    
    lazy var trash_button: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(delete_transaction))
        return button
    }()
    
    lazy var settle_button: UIBarButtonItem = {
        let image = UIImage(named: "settle_debt")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(settle_transaction))
        return button
    }()
    
    lazy var note: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "note"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "note_h"), for: .highlighted)
        button.addTarget(self, action: #selector(add_note), for: .touchUpInside)
        return button
    }()
    
    //MARK: expanded image view components
    lazy var black_background: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset_view)))
        return view
    }()
    
    lazy var expanded_image_view: UIImageView = {
        let image = UIImageView()
        image.image = transaction_image.image
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 4.0
        image.clipsToBounds = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset_view)))
        return image
    }()
    
    //MARK: Functions and setup
    fileprivate func setup_navigation() {
        navigationItem.titleView = navigation_title
        navigationItem.rightBarButtonItems = [trash_button, settle_button]
    }
    
    fileprivate func setup() {
        view.backgroundColor = .white
        // Add subviews
        view.addSubview(transaction_image)
        view.addSubview(description_view)
        view.addSubview(amount_view)
        view.addSubview(time_stamp)
        view.addSubview(created_label)
        view.addSubview(note)
        //Add COnstraints
        view.center_X(item: transaction_image)
        transaction_image.widthAnchor.constraint(equalToConstant: view.frame.width - 70.0).isActive = true
        view.addConstraintsWithFormat(format: "V:|-60-[v0]-20-[v1(210)]-20-[v2]", views:  amount_view, transaction_image, description_view)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: description_view)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: amount_view)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: time_stamp)
        view.addConstraintsWithFormat(format: "V:[v0]-10-[v1]-20-|", views: created_label, time_stamp)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: created_label)
        view.addConstraintsWithFormat(format: "H:|-20-[v0(40)]", views: note)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(40)]", views: note)
    }
    
    fileprivate func setup_components() {
        navigation_title.text = data?.name
        description_view.text = data?.description
        let time = (data?.time.as_date(format: .full))!
        let amount = (Double((data?.amount)!))!
        
        time_stamp.text = time.as_string(format: .month_name_day_year) + " at " + time.as_string(format: .time_only)
        if (data?.is_debt)! {
            amount_view.text = "- " + amount.as_amount()
            amount_view.textColor = .credit
        } else {
            amount_view.text = "+" + amount.as_amount()
            amount_view.textColor = .debt
        }
        set_bar_buttons()
        if data?.tagged_image != "noImage" {
            transaction_image.start_downloading()
            transaction_image.init_from_S3(key: (data?.tagged_image)!, bucket_name: .transactionImages) {[unowned self] in
                self.transaction_image.stop_downloading()
            }
        }
    }
    
    @objc fileprivate func settle_transaction() {
        let current_uid = UserDefaults.standard.object(forKey: "uid") as! String
        let other_uid = data?.uid
        let name = Auth.auth().currentUser?.displayName
        let transaction_id = data?.transaction_id
        let amount = Double((data?.amount)!)!
        let description = data?.description
        let time = Date().as_string(format: .full)
        let is_debt = data?.is_debt
        let alert = UIAlertController(title: nil, message: "Would you like to settle this transaction?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Settle", style: .default) {[unowned self] (_) in
            //Update current user's record and delete the other record
            var parameters: [String: String] = [:]
            parameters["transaction_id"] = transaction_id!
            parameters["payer_uid"] = other_uid
            parameters["payee_uid"] = current_uid
            parameters["time"] = time
            loading(target: self, completion: { (_) in
                post_settle_transaction(parameters: parameters, completion: { (res) in
                    if res.isFailure { return }
                    let val = res.value as! Int
                    if val == 404 {
                        stop_loading()
                        present_alert_error(message: .cannot_settle, target: self)
                        return
                    }
                    
                    //Delete pending notification
                    remove_notification(identifier: self.data?.notification_identifier)
                    let settled_transaction = Settled(is_debt: is_debt!, amount: String(amount), description: description!, name: name!)
                    settled_transactions.insert(settled_transaction, at: 0)
                    //Delete entry and redirect to Home
                    self.delete_and_push_back()
                })
            })
        }
        action.setValue(UIColor.settle_action, forKey: "titleTextColor")
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        execute_on_main {[unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func delete_transaction()
    {
        let current_uid = UserDefaults.standard.object(forKey: "uid") as! String
        let other_uid = data?.uid
        //let key_value = data?.
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: {[unowned self] (_) in
            //Remove from both current user (creditor's) and debter's account.
            var parameters: [String: String] = [:]
            parameters["transaction_id"] = self.data?.transaction_id
            parameters["payer_uid"] = current_uid
            parameters["payee_uid"] = other_uid
            //Delete the tagged image if one exists.
            loading(target: self, completion: { (_) in
                post_delete_transaction(parameters: parameters, completion: { (res) in
                    if res.isFailure { return }
                    //Delete entry and redirect to Home
                    self.delete_and_push_back()
                })
            })
        })
        action.setValue(UIColor.delete_action, forKey: "titleTextColor")
        let alert = UIAlertController(title: nil, message: "Would you like to delete this transaction?", preferredStyle: .actionSheet)
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        execute_on_main {[unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Transaction (delete/settle) common actions
    
    /**
     * This function allows to delete the current item from Home View and push back to
     the main controller.
     */
    fileprivate func delete_and_push_back()
    {
        stop_loading()
        //Push back to root view controller.
        navigationController?.popViewController(animated: true)
        if index != nil {
            //Start a delete transaction
            unsettled_transactions.remove(at: (index?.row)!)
        }
        if (data?.is_debt)! {
            debit -= Double((data?.amount)!)!
        } else {
            credit -= Double((data?.amount)!)!
        }

        if index != nil {
            dahsboard?.tableView.beginUpdates()
            dahsboard?.tableView.deleteRows(at: [index!], with: UITableViewRowAnimation.automatic)
            dahsboard?.tableView.endUpdates()
        } else {
            dahsboard?.refetch_data()
        }
    }

    fileprivate func set_bar_buttons()
    {
        settle_button.isEnabled = (data?.is_debt)!
        trash_button.isEnabled = !(data?.is_debt)!
    }
}

//MARK: Picture action
extension Detail {
    
    @objc fileprivate func expand_image() {
        //Add background view
        view.addSubview(black_background)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: black_background)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: black_background)
        //Add picture view
        let image_size = transaction_image.image?.size
        let frame = view.frame
        let factor = view.frame.width/(image_size?.width)!
        view.addSubview(expanded_image_view)
        expanded_image_view.frame = transaction_image.frame
        transaction_image.alpha = 0
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {[unowned self] in
            self.black_background.alpha = 1.0
            self.expanded_image_view.layer.cornerRadius = 0
            self.expanded_image_view.bounds = CGRect(x: 0, y: 0, width: frame.width, height: factor * (image_size?.height)!)
            self.navigationItem.setHidesBackButton(true, animated:true);
            self.disable_bar_buttons()
            }, completion: nil)
    }
    
    @objc fileprivate func reset_view() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [unowned self] in
            self.black_background.alpha = 0.0
            self.expanded_image_view.frame = CGRect(x: self.transaction_image.frame.minX, y: self.transaction_image.frame.minY, width: self.transaction_image.frame.width, height: self.transaction_image.frame.height)
            self.expanded_image_view.layer.cornerRadius = 4.0
            self.navigationItem.setHidesBackButton(false, animated:true);
            self.set_bar_buttons()
        }) { [unowned self] (_) in
            self.transaction_image.alpha = 1.0
            self.expanded_image_view.removeFromSuperview()
            self.black_background.removeFromSuperview()
        }
    }
    
    fileprivate func disable_bar_buttons() {
        settle_button.isEnabled = false
        trash_button.isEnabled = false
    }
    
    @objc fileprivate func save_image() {
        let alert = UIAlertController(title: nil, message: "Do you want to save this image to Photo library?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {[unowned self] (_) in
            UIImageWriteToSavedPhotosAlbum(self.transaction_image.image!, self, #selector(self.image_saved(_:didFinishSavingWithError:contextInfo:)), nil)
        }))
        execute_on_main {[unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func image_saved(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let message = MessageView(superView_frame: view.frame, center: transaction_image.center, text: "Image Saved to Camera Roll", image: #imageLiteral(resourceName: "saved"))
            view.addSubview(message)
            message.alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                message.alpha = 1.0
            }, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    message.alpha = 0.0
                }, completion: { (_) in
                    message.removeFromSuperview()
                })
            }
        }
    }
    
    @objc fileprivate func add_note() {
        let controller = Note()
        controller.data = data
        if is_peeking {
            if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController? {
                    root?.pushViewController(controller, animated: true)
            }
        } else {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: Notifications App Launch
extension Detail {
    func remove_interactions() {
        settle_button.isEnabled = false
        note.removeFromSuperview()
        for gestures in transaction_image.gestureRecognizers ?? [] {
            transaction_image.removeGestureRecognizer(gestures)
        }
    }
    
    func prepare_view() {
        setup_navigation()
        setup()
        setup_components()
        remove_interactions()
    }
}

extension Detail {
    override var previewActionItems: [UIPreviewActionItem] {
        let add_note_action = UIPreviewAction(title: "Add Note",
                                      style: .default,
                                      handler: {[unowned self] _, _ in
                                        self.is_peeking = true
                                        self.add_note()
        })
        return [add_note_action]
    }
}
