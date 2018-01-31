import UIKit

protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }

    // willDismiss
    func willDismiss(withDuration: TimeInterval)
    func willPresent(withDuration: TimeInterval)
}

extension Animatable {
    func willDismiss(withDuration: TimeInterval) {}
    func willPresent(withDuration: TimeInterval) {}
}

class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate let operationType: UINavigationControllerOperation
    fileprivate let transitionDuration: TimeInterval

    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval) {
        self.operationType = operation
        self.transitionDuration = duration
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
        toVC.willPresent(withDuration: self.transitionDuration)
        fromVC.willDismiss(withDuration: self.transitionDuration)

        UIView.animate(withDuration: self.transitionDuration, animations: {
            // Resize cell to
            fromChild.frame = toChild.frame
            fromChild.layoutIfNeeded()
        }) { _ in
            // Restore original info
            fromChild.frame = originalFrame
            fromSuperview?.addSubview(fromChild)

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
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
        toVC.willPresent(withDuration: self.transitionDuration)
        fromVC.willDismiss(withDuration: self.transitionDuration)

        UIView.animate(withDuration: self.transitionDuration, animations: {
            toChild.frame = originalFrame
            toChild.frame.origin = containerCoord
            toChild.layoutIfNeeded()
        }) { _ in
            toChild.frame = originalFrame
            toSuperview?.addSubview(toChild)

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

