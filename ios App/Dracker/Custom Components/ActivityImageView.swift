import UIKit
/**
 * An implementation of UIImageView with the ablity to add activity indicator during loading.
 */
class ActivityImageView: UIImageView {
    
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activity.color = UIColor.black
        activity.hidesWhenStopped = true
        activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        return activity
    }()
    
    lazy var background: UIVisualEffectView = {
        let background = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        background.alpha = 0.65
        return background
    }()
    
    func start_downloading() {
        self.addSubview(background)
        let correct_frame = superview?.frame
        self.activity.center = CGPoint(x: ((correct_frame?.width)! - 70.0)/2, y: frame.height/2)
        self.addSubview(activity)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: background)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: background)
        self.activity.startAnimating()
    }
    
    func stop_downloading()
    {
        execute_on_main {
            self.activity.stopAnimating()
            self.background.removeFromSuperview()
            self.activity.removeFromSuperview()
        }
    }
}
