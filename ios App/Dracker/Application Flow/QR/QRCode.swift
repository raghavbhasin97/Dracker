import UIKit
import Firebase

class QRCode: UIViewController {
    let base_padding: CGFloat = 60
    let image_padding: CGFloat = 80
    let profile_size: CGFloat = 70
    let top_padding: CGFloat = 90
    
    lazy var share_button: ShareButton = {
        let button = ShareButton(image: #imageLiteral(resourceName: "share"), text: "Share my code", selected_color: .black, unselected_color: .text_color, bacground_selected: .share_button_highlighted_light)
        button.addTarget(self, action: #selector(share_image), for: .touchUpInside)
        return button
    }()
    
    lazy var save_button: ShareButton = {
        let button = ShareButton(image: #imageLiteral(resourceName: "download"), text: "Save to photos", selected_color: .black, unselected_color: .text_color, bacground_selected: .share_button_highlighted_light)
        button.addTarget(self, action: #selector(save_image), for: .touchUpInside)
        return button
    }()

    
    let image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.borderWidth = 2.5
        image.layer.borderColor = UIColor.qr_back.cgColor
        return image
    }()
    
    lazy var profile_image: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = profile_size/2
        return image
    }()
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = .systemFont(ofSize: 15)
        title.text = "QR Code"
        return title
    }()
    
    let base_view: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4.0
        view.clipsToBounds = true
        return view
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .qr_back
        authorize(completion: setup)
    }

    fileprivate func setup_graphic() {
        navigationItem.titleView = navigation_title
    }
    
    fileprivate func setup_code() {
        base_view.addSubview(image)
        let height = view.frame.width - (image_padding + base_padding)
        base_view.addConstraintsWithFormat(format: "H:|-\(image_padding/2)-[v0]-\(image_padding/2)-|", views: image)
        base_view.addConstraintsWithFormat(format: "V:[v0]-12-[v1(\(height))]-25-|", views: name, image)
        
    }
    
    fileprivate func setup_name() {
        base_view.addSubview(name)
        base_view.addConstraintsWithFormat(format: "H:|[v0]|", views: name)
    }
    
    fileprivate func setup_profile() {
        view.addSubview(profile_image)
        view.center_X(item: profile_image)
        profile_image.widthAnchor.constraint(equalToConstant: profile_size).isActive = true
        profile_image.heightAnchor.constraint(equalToConstant: profile_size).isActive = true
        let top = top_padding - profile_size/2
        view.addConstraintsWithFormat(format: "V:|-\(top)-[v0]", views: profile_image)
        let uid = UserDefaults.standard.object(forKey: "uid") as? String
        profile_image.init_from_S3(key: uid!, bucket_name: .profiles)
    }
    
    fileprivate func setup_base() {
        view.addSubview(base_view)
        view.addConstraintsWithFormat(format: "H:|-\(base_padding/2)-[v0]-\(base_padding/2)-|", views: base_view)
        view.addConstraintsWithFormat(format: "V:|-\(top_padding)-[v0]-170-|", views: base_view)
    }
    
    fileprivate func setup() {
        setup_base()
        setup_graphic()
        setup_name()
        setup_code()
        setup_profile()
        self.name.text = "@" +  (UserDefaults.standard.object(forKey: "name") as! String).replacingOccurrences(of: " ", with: "-")
        let json = get_data().encrypt()
        image.image = generate_QRCode(from: json!)
        setup_buttons()
    }
    
    fileprivate func setup_buttons() {
        
        //MARK: Share Button
        view.addSubview(share_button)
        view.center_X(item: share_button)
        share_button.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        //MARK: Save Buttons
        view.addSubview(save_button)
        view.center_X(item: save_button)
        save_button.widthAnchor.constraint(equalToConstant: 160).isActive = true
        view.addConstraintsWithFormat(format: "V:[v0(30)]-10-[v1(30)]-40-|", views: save_button, share_button)
    }
    
    fileprivate func generate_QRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            guard let color_filter = CIFilter(name: "CIFalseColor") else { return nil }
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            color_filter.setValue(filter.outputImage, forKey: "inputImage")
            color_filter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
            color_filter.setValue(CIColor(red: 1 - 226/255 , green: 1 - 233/255, blue: 1 - 237/255), forKey: "inputColor0")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = color_filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    fileprivate func get_data() -> String {
        var data: Dictionary = [String: String]();
        data["uid"] = UserDefaults.standard.object(forKey: "uid") as? String
        data["name"] = Auth.auth().currentUser?.displayName
        data["phone"] = UserDefaults.standard.object(forKey: "phone") as? String
        let json = try? JSONSerialization.data(withJSONObject: data, options: [])
        return String(data: json!, encoding: .utf8)!
    }
}

//MARK: Actions

extension QRCode {
    @objc func share_image() {
        let share_image = get_image()
        let share_activity = UIActivityViewController(activityItems: [share_image], applicationActivities: [])
        present(share_activity, animated: true, completion: nil)
    }
    
    fileprivate func get_image() -> UIImage{
        let size = self.image.frame.width
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        self.image.drawHierarchy(in: CGRect(x: 0, y: 0, width: size, height: size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    
    @objc fileprivate func save_image() {
        UIImageWriteToSavedPhotosAlbum(self.get_image(), self, #selector(self.image_saved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image_saved(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let shift = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
            let message = MessageView(superView_frame: view.frame, center: CGPoint(x: view.center.x, y: view.center.y - shift), text: "QR Code saved to photos", image: #imageLiteral(resourceName: "saved"))
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
}
