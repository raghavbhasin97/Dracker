import UIKit

let background_blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
var activty: UIActivityIndicatorView? = {
    let activity = UIActivityIndicatorView(style: .whiteLarge)
    activity.color = .red
    return activity
}()
func loading(target: UIViewController, completion: @escaping (Bool) -> Void) {
    //Add Loading logic
    let window = UIScreen.main.bounds
    target.view.addSubview(background_blur)
    target.view.addSubview(activty!)
    
    background_blur.frame = CGRect(x: 0, y: 0, width: target.view.frame.width, height: target.view.frame.height)
    activty?.center = CGPoint(x: window.width/2, y: window.height/2)
    activty?.startAnimating()
    background_blur.alpha = 0
    activty?.layer.transform = CATransform3DMakeTranslation(0, target.view.frame.height/2, 0)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        background_blur.alpha = 1.0
        activty?.layer.transform = CATransform3DMakeTranslation(0, 0, 0)
        }, completion: completion)
}

func stop_loading() {
    activty?.stopAnimating()
    activty?.removeFromSuperview()
    background_blur.removeFromSuperview()
}
