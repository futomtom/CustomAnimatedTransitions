import UIKit

// https://www.shinobicontrols.com/blog/ios-10-day-by-day-day-4-uiviewpropertyanimator

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
            let fromView = transitionContext.view(forKey: .from),
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

//        let fromViewSuperview = fromView.superview

//        container.addSubview(fromView)
        container.addSubview(toView)

        let originalFrame = toView.frame


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
        let positionAnimator = UIViewPropertyAnimator(duration: self.transitionDuration, dampingRatio: 0.7)
        positionAnimator.addAnimations {
            // Move the view in the Y direction
            toView.transform = CGAffineTransform(translationX: 0, y: yDiff)

        }

        let sizeAnimator = UIViewPropertyAnimator(duration: self.transitionDuration / 2, curve: .easeInOut)
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

//        fromVC.positioning(with: positionAnimator, fromPoint: originFrame.origin, toPoint: destinationFrame.origin)
//        fromVC.resizing(with: sizeAnimator, fromFrame: fromView.frame, toFrame: destinationFrame)

        toVC.presentingView(sizeAnimator: sizeAnimator, positionAnimator: positionAnimator, fromFrame: originFrame, toFrame: destinationFrame)

        positionAnimator.startAnimation()
        sizeAnimator.startAnimation()
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
        let positionAnimator = UIViewPropertyAnimator(duration: self.transitionDuration, dampingRatio: 0.7)
        positionAnimator.addAnimations {
            // Move the view in the Y direction
            fromView.transform = CGAffineTransform(translationX: 0, y: yDiff)
        }

        let sizeAnimator = UIViewPropertyAnimator(duration: self.transitionDuration / 2, curve: .easeInOut)
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

        fromVC.positioning(with: positionAnimator, fromPoint: originFrame.origin, toPoint: destinationFrame.origin)
        fromVC.resizing(with: sizeAnimator, fromFrame: fromView.frame, toFrame: destinationFrame)

        positionAnimator.startAnimation()
        sizeAnimator.startAnimation()
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

