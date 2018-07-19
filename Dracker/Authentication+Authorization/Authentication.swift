import Foundation
import UIKit
import Firebase
import LocalAuthentication

//MARK: Login function
func authenticate_visual(caller: UIViewController, email:String, password: String)
{
    //Setup Visual Activity
    let background_blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let activity_indicator = TextActivity(text: "Loggin In!")
    background_blur.frame = caller.view.frame
    caller.view.addSubview(background_blur)
    caller.view.addSubview(activity_indicator)
    activity_indicator.show()
    background_blur.alpha = 0
    activity_indicator.alpha = 0
    activity_indicator.layer.transform = CATransform3DMakeTranslation(0, caller.view.frame.height/2, 0)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        background_blur.alpha = 1.0
        activity_indicator.alpha = 1.0
        activity_indicator.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
    }) { (_) in
        //Try Signing In Running on delay for visual elements
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                background_blur.alpha = 0
                activity_indicator.alpha = 0
                activity_indicator.layer.transform = CATransform3DMakeTranslation(0, caller.view.frame.height/2, 0)
            }, completion: { (_) in
                Auth.auth().signIn(withEmail: email, password: password, completion: { (result, err) in
                    //Remove views
                    background_blur.removeFromSuperview()
                    activity_indicator.removeFromSuperview()
                    //If the login was unsuccessful
                    let user = result?.user
                    if err != nil {
                        present_alert_error(message: .incorrect_login, target: caller)
                    } else if !(user?.isEmailVerified)! {
                        //If email is not verified
                        present_alert_error(message: .unverified_email, target: caller)
                    } else {
                        if let uid = UserDefaults.standard.object(forKey: "uid") as? String {
                            if uid != user?.uid {
                                UserDefaults.standard.removeObject(forKey: "phone")
                            }
                        }
                        store_credentials(email: email, password: password, user_id: (user?.uid)!)
                        move_to_home(caller: caller)
                    }
                })
            })
        }
    }
}

func authenticate()
{
    let email = (UserDefaults.standard.object(forKey: "email") as? String)?.decrypt()
    let password = (UserDefaults.standard.object(forKey: "password") as? String)?.decrypt()
    Auth.auth().signIn(withEmail: email!, password: password!, completion: nil)
}

fileprivate func store_credentials(email:String, password: String, user_id:String)
{
    UserDefaults.standard.set(email.encrypt(), forKey: "email")
    UserDefaults.standard.set(password.encrypt(), forKey: "password")
    UserDefaults.standard.set(true, forKey: "auto_login")
    UserDefaults.standard.set(user_id, forKey: "uid")
}

fileprivate func move_to_home(caller: UIViewController)
{
    if let _ = UserDefaults.standard.object(forKey: "phone")  {
        let controller = root_navigation()
        caller.present(controller, animated: true, completion: nil)
    } else {
        let controller = Onboarding()
        caller.present(controller, animated: true, completion: nil)
    }
}

func authorize(completion: @escaping () -> Void) {
    if UserDefaults.standard.bool(forKey: "touch") && !UserDefaults.standard.bool(forKey: "auth"){
        let context = LAContext()
        context.localizedFallbackTitle = "Enter Passcode"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please Authenticate") { (success, err) in
            if success {
                UserDefaults.standard.set(true, forKey: "auth")
                execute_on_main { completion() }
            } else {
                execute_on_main {
                    let controller = Passcode()
                    controller.completion = completion
                    if let main = UIApplication.shared.keyWindow?.rootViewController {
                        main.present(controller, animated: true, completion: nil)
                    }
                }
            }
        }
    } else {
        completion()
    }
}
