import UIKit

protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }

    func dismissingView(_ view: UIView, withDuration duration: TimeInterval)
    func presentingView(_ view: UIView, withDuration duration: TimeInterval)
    func transitionDidComplete(_ finish: Bool)

    func resizing(with animator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect)
    func positioning(with animator: UIViewPropertyAnimator, fromPoint: CGPoint, toPoint: CGPoint)

    func presentingView(sizeAnimator: UIViewPropertyAnimator, positionAnimator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect)
}

extension Animatable {
    func dismissingView(_ view: UIView, withDuration duration: TimeInterval) {}
    func presentingView(_ view: UIView, withDuration duration: TimeInterval) {}
    func transitionDidComplete(_ finish: Bool) {}

    func resizing(with animator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect) {}
    func positioning(with animator: UIViewPropertyAnimator, fromPoint: CGPoint, toPoint: CGPoint) {}

    func presentingView(sizeAnimator: UIViewPropertyAnimator, positionAnimator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect) {}
}
