import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .destructive, handler: handler))
        present(alert, animated: true, completion: nil)
    }
    
    func showError(message: ErrorMessage, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: "Aw, Snap!", message: message.rawValue, handler: handler)
    }
    
    func showSuccess(message: ErrorMessage, handler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: "Success!", message: message.rawValue, handler: handler)
    }
    
    func presentConfirmation(image: UIImage, message: String) {
        let confirmation = ConfirmationMessage(image: image, message: message)
        view.addSubview(confirmation)
        confirmation.layer.transform = CATransform3DMakeScale(0, 0, 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            confirmation.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 1.50, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                confirmation.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                confirmation.alpha = 0
            }, completion: { (_) in
                confirmation.removeFromSuperview()
            })
        }
    }
}

