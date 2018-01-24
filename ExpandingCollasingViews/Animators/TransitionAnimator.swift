import UIKit

protocol TransitionDelegate {
    func transitionWillBegin()
    func animate(
        alongsideTransition animation: ((UIViewControllerContextTransitioning) -> Swift.Void)?,
        completion: ((UIViewControllerContextTransitioning) -> Swift.Void)?
    ) -> Bool
    func transitionDidEnd()
}

protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }

    var transitionDelegate: TransitionDelegate? { get }
}

extension Animatable {
    // Default implementation
    var transitionDelegate: TransitionDelegate? {
        return nil
    }
}

class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate let operationType: UINavigationControllerOperation
    fileprivate let transitionDuration: TimeInterval

    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval) {
        self.operationType = operation
        self.transitionDuration = duration
    }

    // MARK: Push and Pop animations performers
    internal func performPushTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        // Can we just use transitionContext.view(forKey: .to) for the toView?

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
        fromChild.frame = originalFrame
        fromChild.frame.origin = containerCoord

        // Hide the final view until the end
        toView.isHidden = true

        UIView.animate(withDuration: self.transitionDuration, animations: {
            // Resize cell to
            fromChild.frame = toChild.frame
            fromChild.layoutIfNeeded()
        }) { _ in
            // Restore original info
            fromChild.frame = originalFrame
            fromSuperview?.addSubview(fromChild)

            toView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    internal func performPopTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromChild = fromVC.childView
        else {
            return
        }

        guard
            let toVC = transitionContext.viewController(forKey: .to) as? Animatable,
            let toContainer = toVC.containerView,
            let toChild = toVC.childView,
            let toView = transitionContext.view(forKey: .to)
        else {
            return
        }

        let toSuperview = toChild.superview
        let originalFrame = toChild.frame

        // Add destination view to the container view
        container.addSubview(toView)
        container.addSubview(toChild)

        // Get the coordinates of the view inside the container
        let containerCoord = toContainer.convert(toChild.frame.origin, to: container)
        toChild.frame = fromChild.frame

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

    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.operationType == .push {
            performPushTransition(transitionContext)
        } else if self.operationType == .pop {
            performPopTransition(transitionContext)
        }
    }

    func transformFromRect(from: CGRect, toRect to: CGRect) -> CGAffineTransform {
        let transform = CGAffineTransform(translationX: to.midX - from.midX, y: to.midY - from.midY)
        return transform.scaledBy(x: to.width / from.width, y: to.height / from.height)
    }
}

