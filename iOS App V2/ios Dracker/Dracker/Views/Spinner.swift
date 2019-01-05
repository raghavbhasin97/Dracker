import UIKit
import NVActivityIndicatorView

class Spinner: UIView {
    
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
   
    var loader: NVActivityIndicatorView!
    
    init(type: NVActivityIndicatorType, color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = .clear
        loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: type, color: color, padding: 0)
        loader.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimating() {
        addSubview(blurView)
        blurView.fillSuperview()
        addSubview(loader)
        centerX(item: loader)
        centerY(item: loader)
        loader.startAnimating()
        blurView.alpha = 0
        loader.alpha = 0
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseIn, animations: {[unowned self] in
            self.blurView.alpha = 1
            self.loader.alpha = 1
        }, completion: nil)
    }
    
    public func stopAnimating() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            [unowned self] in
            self.alpha = 0
        }) {[unowned self] (_) in
            self.blurView.removeConstraints(self.blurView.constraints)
            self.blurView.removeFromSuperview()
            self.loader.removeConstraints(self.loader.constraints)
            self.loader.removeFromSuperview()
            self.removeConstraints(self.constraints)
            self.removeFromSuperview()
        }
    }
}
