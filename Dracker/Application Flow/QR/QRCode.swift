import UIKit
import Firebase

class QRCode: UIViewController {
    
    let image = UIImageView()
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.text = "QR Code"
        return title
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 30)
        label.textAlignment = .center
        label.textColor = .text_color
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        authorize(completion: setup)
    }
    
    fileprivate func setup_graphic() {
        navigationItem.titleView = navigation_title
    }
    
    fileprivate func setup_code() {
        view.addSubview(image)
        let height = view.frame.width - 60.0
        view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: image)
        view.addConstraintsWithFormat(format: "V:|-100-[v0(\(height))]-10-[v1(40)]", views: image, name)
    }
    
    fileprivate func setup_name() {
        view.addSubview(name)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: name)
    }
    
    fileprivate func setup() {
        setup_graphic()
        setup_name()
        setup_code()
        self.name.text = "@" +  (UserDefaults.standard.object(forKey: "name") as! String)
        let json = get_data().encrypt()
        image.image = generate_QRCode(from: json!)
    }
    
    fileprivate func generate_QRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
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
