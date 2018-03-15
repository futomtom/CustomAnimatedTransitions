import UIKit

class CustomTransitionAnimationController: NSObject {
    fileprivate let operation: UINavigationControllerOperation
    fileprivate let positioningDuration: TimeInterval
    fileprivate let resizingDuration: TimeInterval

    init(
        operation: UINavigationControllerOperation,
        positioningDuration: TimeInterval,
        resizingDuration: TimeInterval
    ) {
        self.operation = operation
        self.positioningDuration = positioningDuration
        self.resizingDuration = resizingDuration
    }
}

extension CustomTransitionAnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return max(self.resizingDuration, self.positioningDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.operation == .push {
            self.presentTransition(transitionContext)
        } else if self.operation == .pop {
            self.dismissTransition(transitionContext)
        }
    }
}

/// Perform custom presentation and dismiss animations
extension CustomTransitionAnimationController {
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
            let toView = transitionContext.view(forKey: .to)
        else {
            return
        }

        let originalFrame = toView.frame

        container.addSubview(toView)

        // Get the coordinates of the view inside the container
        let originFrame = CGRect(
            origin: fromContainer.convert(fromChild.frame.origin, to: container),
            size: fromChild.frame.size
        )
        let destinationFrame = toView.frame

        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x

        toView.frame = originFrame
        toView.layoutIfNeeded()

        fromChild.isHidden = true

        // For the duration of the animation, we are moving the frame. Therefore we have a separate animator
        // to just control the Y positioning of the views. We will also use this animator to determine when
        // all of our animations are done.
        let positionAnimator = UIViewPropertyAnimator(duration: self.positioningDuration, dampingRatio: 0.7)
        positionAnimator.addAnimations {
            // Move the view in the Y direction
            toView.transform = CGAffineTransform(translationX: 0, y: yDiff)
        }

        let sizeAnimator = UIViewPropertyAnimator(duration: self.resizingDuration, curve: .easeInOut)
        sizeAnimator.addAnimations {
            toView.frame.size = destinationFrame.size
            toView.layoutIfNeeded()

            // Move the view in the X direction. We concatinate here because we do not want to overwrite our
            // previous transformation
            toView.transform = toView.transform.concatenating(CGAffineTransform(translationX: xDiff, y: 0))
        }

        // Animations Have Ended
        positionAnimator.addCompletion { _ in
            toView.transform = .identity
            toView.frame = originalFrame
            toView.layoutIfNeeded()

            fromChild.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        toVC.presentingView(
            sizeAnimator: sizeAnimator,
            positionAnimator: positionAnimator,
            fromFrame: originFrame,
            toFrame: destinationFrame
        )

        positionAnimator.startAnimation()
        sizeAnimator.startAnimation()
    }

    internal func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView

        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? Animatable,
            let fromView = transitionContext.view(forKey: .from)
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

        // container view (2 views)
        //  * starts at full screen
        //  * resizes to card size
        // - Card
        //  * if off screen, starts exactly at the top of the container
        //  * use center of card to postion
        // - snapshot of body text

        container.addSubview(toView)
        container.addSubview(fromView)

        toChild.isHidden = true

        // Get the coordinates of the view inside the container
        let originFrame = fromView.frame
        let destinationFrame = CGRect(
            origin: toContainer.convert(toChild.frame.origin, to: container),
            size: toChild.frame.size
        )

        let yDiff = destinationFrame.origin.y - originFrame.origin.y
        let xDiff = destinationFrame.origin.x - originFrame.origin.x

        // For the duration of the animation, we are moving the frame. Therefore we have a separate animator
        // to just control the Y positioning of the views. We will also use this animator to determine when
        // all of our animations are done.
        let positionAnimator = UIViewPropertyAnimator(duration: self.positioningDuration, dampingRatio: 0.7)
        positionAnimator.addAnimations {
            // Move the view in the Y direction
            fromView.transform = CGAffineTransform(translationX: 0, y: yDiff)
        }

        let sizeAnimator = UIViewPropertyAnimator(duration: self.resizingDuration, curve: .easeInOut)
        sizeAnimator.addAnimations {
            fromView.frame.size = destinationFrame.size
            fromView.layoutIfNeeded()

            // Move the view in the X direction. We concatinate here because we do not want to overwrite our
            // previous transformation
            fromView.transform = fromView.transform.concatenating(CGAffineTransform(translationX: xDiff, y: 0))
        }

        // Animations Have Ended
        positionAnimator.addCompletion { _ in
            fromView.removeFromSuperview()
            toChild.isHidden = false

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        fromVC.dismissingView(
            sizeAnimator: sizeAnimator,
            positionAnimator: positionAnimator,
            fromFrame: originFrame,
            toFrame: destinationFrame
        )

        positionAnimator.startAnimation()
        sizeAnimator.startAnimation()
    }
}

