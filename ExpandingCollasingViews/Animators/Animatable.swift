import UIKit

protocol Animatable {
    var containerView: UIView? { get }
    var childView: UIView? { get }

    func dismissingView(_ view: UIView, withDuration duration: TimeInterval)
    func presentingView(_ view: UIView, withDuration duration: TimeInterval)
}

extension Animatable {
    func dismissingView(_ view: UIView, withDuration duration: TimeInterval) {}
    func presentingView(_ view: UIView, withDuration duration: TimeInterval) {}
}