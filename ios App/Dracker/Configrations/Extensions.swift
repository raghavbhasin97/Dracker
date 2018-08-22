import UIKit
import AWSS3
import AES256CBC

//MARK: Colors Used
extension UIColor {
    
    //MARK: function
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    //MARK: Colors
    static let theme = UIColor(r: 55, g: 52, b: 71)
    static let theme_unselected = UIColor(r: 155, g: 145, b: 208)
    static let profile_background = UIColor(r: 240, g: 240, b: 240)
    static let text_color = UIColor(white: 0.32, alpha: 1.0)
    static let textfield = UIColor(r: 248, g: 248, b: 248)
    static let textfield_disabled = UIColor(r: 230, g: 230, b: 230)
    static let debt = UIColor(r: 0, g: 158, b: 96)
    static let credit = UIColor(r: 184, g: 15, b: 10)
    static let settle_action = debt
    static let delete_action = credit
    static let bank_back = UIColor(r: 247, g: 247, b: 247)
}

//MARK: Visual Constraints
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func center_X(item: UIView) {
        center_X(item: item, constant: 0)
    }
    
    func center_X(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: constant))
    }
    
    func center_Y(item: UIView, constant: CGFloat) {
         self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constant))
    }
    
    func center_Y(item: UIView) {
        center_Y(item: item, constant: 0)
    }
}

//MARK: Date

enum DateformatString: String {
    case compact = "MMM dd yyyy h:mm a"
    case full = "MM/dd/yy h:mm:ss.SSSS a Z"
    case day_time = "E h:mm a"
    case month_day = "MMM dd"
    case month_day_year = "MM dd yyyy"
    case time_only = "HH:MM a"
    case month_name_day_year = "MMM dd, yyyy"
    case birthdate = "yyyy-MM-dd"
}

extension Date {
    func as_string(format: DateformatString) -> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format.rawValue
        let now = dateformatter.string(from: self as Date)
        return now
    }
    
    func as_string_timetrack() -> String {
        let dateformatter = DateFormatter()
        let difference = Date().timeIntervalSince(self)/seconds_in_day
        if difference < 7 {
            dateformatter.dateFormat = DateformatString.day_time.rawValue
        } else if (difference < 365) {
            dateformatter.dateFormat = DateformatString.month_day.rawValue
        } else {
            dateformatter.dateFormat = DateformatString.month_day_year.rawValue
        }
        let now = dateformatter.string(from: self)
        return now
    }
}
extension String {
    
    func encrypt() -> String?{
        return AES256CBC.encryptString(self, password: .AES_password)
    }
    
    func decrypt() -> String? {
        return AES256CBC.decryptString(self, password: .AES_password)
    }
    
    func as_date(format: DateformatString) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format.rawValue
        let now = dateformatter.date(from: self)
        return now!
    }
    
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

//MARK: UIImageView with S3
extension UIImageView {
    func init_from_S3(key: String, bucket_name: AWSConstants, completion: (() -> Void)? = nil)
    {
        if let image = cache.object(forKey: key as AnyObject) {
            self.image = UIImage(data: image as! Data)
            completion?()
        } else {
            let S3_request = AWSS3GetObjectRequest()
            S3_request?.bucket = bucket_name.rawValue
            S3_request?.key = key
            AWSS3.default().getObject(S3_request!).continueWith { (output) -> Void in
                let data = output.result?.body
                if data == nil {
                    completion?()
                    return
                }
                cache.setObject(data as AnyObject, forKey: key as AnyObject )
                execute_on_main {
                    self.image = UIImage(data: data as! Data)
                }
                completion?()
            }
        }
    }
    
    func downloadImage(url: String, completion: (() -> Void)? = nil) {
        if let image = cache.object(forKey: url as AnyObject) {
            self.image = UIImage(data: image as! Data)
            completion?()
        } else {
            let source = URL(string: url)
            getDataFromUrl(url: source!) { data, response, error in
                completion?()
                guard let data = data, error == nil else { return }
                cache.setObject(data as AnyObject, forKey: url as AnyObject )
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

//MARK: Currency Extension
extension Double {
    func as_amount() -> String {
        return "$" + String(format: "%.2f", self.magnitude)
    }
}

//MARK: UIImage temporary path
extension UIImage {
    func get_temporary_path(quality: CGFloat = 0.30) -> NSURL {
        //Settings temporary location for image
        let image_name = NSURL.fileURL(withPath: NSTemporaryDirectory() + uuid()).lastPathComponent
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        // Get local path
        let local = (document as NSString).appendingPathComponent(image_name)
        let data = UIImageJPEGRepresentation(self,  quality)
        do {
            try data?.write(to: URL(fileURLWithPath: local))
        } catch {
            NSLog("Error Saving camera photo")
        }
        return NSURL(fileURLWithPath: local)
    }
}
