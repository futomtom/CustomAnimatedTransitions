import UIKit

class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum AnimationType {
        case spring(dampingRatio: CGFloat, velocity: CGFloat, options: UIViewAnimationOptions)
        case linear(options: UIViewAnimationOptions)
    }

    fileprivate let operationType: UINavigationControllerOperation
    fileprivate let transitionDuration: TimeInterval
    fileprivate let animationType: AnimationType

    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval, animationType: AnimationType) {
        self.operationType = operation
        self.transitionDuration = duration
        self.animationType = animationType
    }

    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.operationType == .push {
            presentTransition(transitionContext)
        } else if self.operationType == .pop {
            dismissTransition(transitionContext)
        }
    }

    // MARK: Push and Pop animations performers
    internal func presentTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        // Get the views of where we are animating from
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromContainer = fromVC.containerView,
            let fromChild = fromVC.childView
        else {
            return
        }

        // Get the views of where we are animating to
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to),
            let toChild = toVC.childView
        else {
            return
        }

        // We will restore these later
        let fromSuperview = fromChild.superview
        let originalFrame = fromChild.frame

        // Add to container the destination view
        container.addSubview(toView)
        container.addSubview(fromChild)

        // Get the coordinates of the view inside the container
        let containerCoord = fromContainer.convert(fromChild.frame.origin, to: container)
        fromChild.frame.origin = containerCoord

        // Let the views know we are about to animate
        toVC.presentingView(fromChild, withDuration: self.transitionDuration)
        fromVC.dismissingView(fromChild, withDuration: self.transitionDuration)

        self.animate({
            // Resize cell to
            fromChild.frame = toChild.frame
            fromChild.layoutIfNeeded()
        }, completion: { _ in
            // Restore original info
            fromChild.frame = originalFrame
            fromSuperview?.addSubview(fromChild)

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    internal func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromView = transitionContext.view(forKey: .from),
            let fromChild = fromVC.childView
        else {
            return
        }

        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toView = transitionContext.view(forKey: .to),
            let toContainer = toVC.containerView,
            let toChild = toVC.childView
        else {
            return
        }

        let toSuperview = toChild.superview
        let originalFrame = toChild.frame

        // Add destination view to the container view
        container.addSubview(toView)
        container.addSubview(toChild)
        container.addSubview(fromView)

        // Get the coordinates of the view inside the container
        let containerCoord = toContainer.convert(toChild.frame.origin, to: container)
        toChild.frame = fromChild.frame

        // Let the views know we are about to animate
        toVC.presentingView(toChild, withDuration: self.transitionDuration)
        fromVC.dismissingView(toChild, withDuration: self.transitionDuration)

        self.animate({
            toChild.frame = originalFrame
            toChild.frame.origin = containerCoord
            toChild.layoutIfNeeded()
        }, completion: { _ in
            toChild.frame = originalFrame
            toSuperview?.addSubview(toChild)

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func animate(_ animations: @escaping (() -> Void), completion: @escaping ((Bool) -> Void)) {
        switch self.animationType {
        case .linear(let options):
            UIView.animate(
                withDuration: self.transitionDuration,
                delay: 0,
                options: options,
                animations: animations,
                completion: completion
            )
        case .spring(let ratio, let velocity, let options):
            UIView.animate(
                withDuration: self.transitionDuration,
                delay: 0,
                usingSpringWithDamping: ratio,
                initialSpringVelocity: velocity,
                options: options,
                animations: animations,
                completion: completion
            )
        }
    }
}

