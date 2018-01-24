import UIKit

protocol CollectionPushAndPoppable {
    var sourceCell: UICollectionViewCell? { get }
    var collectionView: UICollectionView! { get }
    var view: UIView! { get }
}

protocol PushAndPopable {
    var view: UIView? { get }
    var animatableView: UIView? { get }
}

extension PushAndPopable {
    var view: UIView? {
        if let vc = self as? UIViewController {
            return vc.view
        } else {
            return self as? UIView
        }
    }
}

class PopInAndOutAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    fileprivate let operationType: UINavigationControllerOperation
    fileprivate let transitionDuration: TimeInterval

    init(operation: UINavigationControllerOperation) {
        self.operationType = operation
        self.transitionDuration = 0.5
    }

    init(operation: UINavigationControllerOperation, andDuration duration: TimeInterval) {
        self.operationType = operation
        self.transitionDuration = duration
    }

    // MARK: Push and Pop animations performers
    internal func performPushTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard
            let toVC = transitionContext.viewController(forKey: .to) as? PushAndPopable,
            let toView = transitionContext.view(forKey: .to),
            let toExpandingView = toVC.animatableView
        else {
            return
        }

        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? PushAndPopable,
            let cell = fromVC.animatableView
        else {
            // There is not enough info to perform the animation but it is still possible
            // to perform the transition presenting the destination view
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        // We will restore these later
        let fromSuperview = cell.superview
        let originalFrame = cell.frame
        let removedConstraints = cell.constraints.filter({ (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutAttribute.height ||
                constraint.firstAttribute == NSLayoutAttribute.width
        })

        // If your view is set in place using constraints, you'll want to remove the ones used to anchor the view
        // so that the view can stretch/shink/move to your desired position.
        cell.translatesAutoresizingMaskIntoConstraints = true
        cell.removeConstraints(removedConstraints)

        // Add to container the destination view
        container.addSubview(toView)
        container.addSubview(cell)

        // Hide the final view until the end
        toView.isHidden = true

        toView.layoutIfNeeded()

        UIView.animate(withDuration: self.transitionDuration, animations: {
            // Resize cell to
            cell.frame = toExpandingView.frame
            cell.layoutIfNeeded()
        }) { _ in
            // Restore original info
            cell.frame = originalFrame
            cell.addConstraints(removedConstraints)
            cell.translatesAutoresizingMaskIntoConstraints = false

            fromSuperview?.addSubview(cell)

            toView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }

    internal func performPopTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: .to) else {
            print("ERROR: Transition impossible to perform without knowing where to transition to!")
            return
        }

        guard
            let source = transitionContext.viewController(forKey: .from) as? PushAndPopable,
            let destination = transitionContext.viewController(forKey: .to) as? PushAndPopable,
            let dView = destination.animatableView,
            let toVC = transitionContext.viewController(forKey: .to),
            let sView = source.animatableView
        else {
            // There are not enough info to perform the animation but it is still possible
            // to perform the transition presenting the destination view
            container.addSubview(toView)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        let removedConstraints = dView.constraints.filter({ (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutAttribute.height ||
                constraint.firstAttribute == NSLayoutAttribute.width
        })

        // If your view is set in place using constraints, you'll want to remove the ones used to anchor the view
        // so that the view can stretch/shink/move to your desired position.
        dView.translatesAutoresizingMaskIntoConstraints = true
        dView.removeConstraints(removedConstraints)

        // Add destination view to the container view
        container.addSubview(toVC.view)

        let originalFrame = dView.frame
        dView.frame = sView.frame

        UIView.animate(withDuration: self.transitionDuration, animations: {
            dView.frame = originalFrame
            dView.layoutIfNeeded()
        }) { _ in
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

