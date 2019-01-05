import UIKit
import AWSS3
import Alamofire

extension UIImageView {
    func loadProfile(key: String, completion: ((Bool) -> Void)? = nil) {
        loadFromS3(key: key, bucket: buckets["profiles"]!, imageView: self) { (success) in
                if !success {
                    DispatchQueue.main.async {[unowned self] in
                        self.image = #imageLiteral(resourceName: "blankProfile")
                    }
                }
                completion?(success)
        }
    }
    
    func loadImage(key: String, completion: ((Bool) -> Void)? = nil) {
        loadFromS3(key: key, bucket: buckets["transactions"]!, imageView: self) { (success) in
            if !success {
                DispatchQueue.main.async {[unowned self] in
                    self.image = #imageLiteral(resourceName: "noImage")
                }
            }
            completion?(success)
        }
    }
    
    func loadInstitution(name: String) {
        if let image = imageCache.object(forKey: name as AnyObject) {
            self.image = image
            return
        }
        let institutionName = name.lowercased().replacingOccurrences(of: " ", with: "")
        let url = "https://logo.clearbit.com/\(institutionName).com"
        Alamofire.request(url).responseData { (res) in
            if let data = res.value {
                guard let image = UIImage(data: data) else {
                    self.image = nil
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
                imageCache.setObject(image, forKey: name as AnyObject)
            } else {
                self.image = nil
            }
        }
    }
}

func loadFromS3(key: String, bucket: String, imageView: UIImageView, completion: ((Bool) -> Void)? = nil) {
    if let image = imageCache.object(forKey: key as AnyObject) {
        imageView.image = image
        completion?(true)
    } else {
        let request = AWSS3GetObjectRequest()
        request?.bucket = bucket
        request?.key = key
        if let S3request = request {
            AWSS3.default().getObject(S3request).continueWith { (res) -> Void in
                guard let response = res.result else {
                    completion?(false)
                    return
                }
                
                guard let data = response.body as? Data else {
                    completion?(false)
                    return
                }
                guard let image = UIImage(data: data) else {
                    completion?(false)
                    return
                }
                imageCache.setObject(image, forKey: key as AnyObject)
                DispatchQueue.main.async {
                    imageView.image = image
                }
                completion?(true)
            }
        } else {
            completion?(false)
        }
    }
}

