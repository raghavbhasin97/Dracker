import UIKit

/**
 A transition that creates a sliding, parallax effect by moving one view out of container and
 another in simultaneously in backward direction.
 */
class slide_backward: NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to = transitionContext.viewController(forKey: .to)
        let from = transitionContext.viewController(forKey: .from)
        let container = transitionContext.containerView
        //Add views
        container.addSubview((to?.view)!)
        //Setup before animation
        to?.view.layer.transform = CATransform3DMakeTranslation(-transitionContext.containerView.frame.width , 0, 0)
        let duration = self.transitionDuration(using: transitionContext)
        //Animate
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            to?.view.layer.transform = CATransform3DMakeTranslation(0 , 0, 0)
            from?.view.layer.transform = CATransform3DMakeTranslation(transitionContext.containerView.frame.width , 0, 0)
        }) { (did_finish) in
            transitionContext.completeTransition(did_finish)
        }
    }
}
