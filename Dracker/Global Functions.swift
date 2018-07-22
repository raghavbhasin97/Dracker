import UIKit
import Alamofire
import SystemConfiguration

func execute_on_main(block: @escaping () -> Void) {
    DispatchQueue.main.async {
        block()
    }
}

func execute_on_main_delay(delay: Double, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        block()
    }
}

//MARK: Validations
func valid_email(email: String) -> Bool {
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,3}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: email)
}
func valid_amount(amount: String) -> Bool {
    let regex = "[0-9]+\\.[0-9]{2}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: amount)
}

func valid_description(description: String) -> Bool {
    return description.count < 30
}

func valid_password(password: String) -> Bool {
    return password.count > 5
}

func valid_street(street: String) -> Bool {
    return street.count > 2
}

func valid_city(city: String) -> Bool {
    return city.count > 2
}

func valid_state(state: String) -> Bool {
    return states.contains(state)
}

func valid_zip(zip: String) -> Bool {
    let regex = "[0-9]{5}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: zip)
}

func valid_code(zip: String) -> Bool {
    let regex = "[0-9]{5}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: zip)
}

func valid_phone(phone: String) -> Bool {
    let regex = "[0-9]{10}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: phone)
}

func valid_name(name: String) -> Bool {
    let regex = "[A-Za-z]+\\s[A-Za-z]+"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: name)
}

func valid_code(code: String) -> Bool {
    let regex = "[0-9]{5}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: code)
}

func valid_pin(pin: String) -> Bool {
    let regex = "[0-9]{4}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: pin)
}

func valid_ssn(ssn: String) -> Bool {
    let regex = "[0-9]{4}"
    return NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: ssn)
}

func valid_birthdate(birthdate: Date) -> Bool {
    let now = Date()
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthdate, to: now)
    let age = ageComponents.year!
    return age >= 18
}

func valid_frequency(frequency: String) -> Bool {
    if frequency == "" {return false}
    let integer_frequency = Int(frequency)
    return integer_frequency! > 0 && integer_frequency! < 30
}

//Send SMS via Twillo using Alamofire
func send_message(phone:String, message:String) {
    
    let url = "https://api.twilio.com/2010-04-01/Accounts/\(TwilloAccountSID)/Messages"
    let parameters = ["From": "+17606426291", "To": phone, "Body": message]
    
    Alamofire.request(url, method: .post, parameters: parameters)
        .authenticate(user: TwilloAccountSID, password: TwilloauthToken)
    
}

//MARK: Controllers
func root_navigation() -> UIViewController {
    let navigation: UINavigationController = {
        let controller = UINavigationController(rootViewController: Home())
        controller.navigationBar.isTranslucent = false
        controller.navigationBar.shadowImage =  UIImage()
        return controller
    }()
    return navigation
}

func get_navigation() -> UINavigationController? {
    if let root = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
        return root
    }
    return nil
}
//MARK: Verification code generator
func random_code() -> Int{
    let number = String.init(format: "%04d", arc4random_uniform(100000))
    return Int(number)!
}


func uuid() -> String {
    let uuid = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
    return uuid
}

//MARK: Animation shothand

fileprivate func animate(animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
    UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseOut, animations: animations, completion: completion)
}

func animate_cycle(view: UIView, completion: @escaping (Bool) -> Void) {
    animate(animations: {
        view.layer.transform = CATransform3DMakeTranslation(kPasscodeTransformScale/3, 0, 0)
    }) { (_) in
        animate(animations: {
            view.layer.transform = CATransform3DMakeTranslation(-kPasscodeTransformScale, 0, 0)
        }, completion: { (_) in
            animate(animations: {
                view.layer.transform = CATransform3DMakeTranslation(kPasscodeTransformScale, 0, 0)
            }, completion: { (_) in
                animate(animations: {
                    view.layer.transform = CATransform3DMakeTranslation(-kPasscodeTransformScale/3, 0, 0)
                }, completion: { (_) in
                    animate(animations: {
                        view.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
                    }, completion: completion)
                })
            })
        })
    }
}

func reachable() -> Bool{
    
    var zero_address = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zero_address.sin_len = UInt8(MemoryLayout.size(ofValue: zero_address))
    zero_address.sin_family = sa_family_t(AF_INET)
    
    let reachability = withUnsafePointer(to: &zero_address) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(reachability!, &flags) == false {
        return false
    }
    
    // Working for Cellular and WIFI
    let reachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needs_connection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (reachable && !needs_connection)
    
    return ret
}
