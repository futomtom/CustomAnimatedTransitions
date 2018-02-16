import UIKit

class DetailViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var bodyView: UIView!
}

extension DetailViewController: Animatable {
    var containerView: UIView? {
        return self.view
    }
    
    var childView: UIView? {
        return self.commonView
    }

    func presentingView(_ view: UIView, withDuration duration: TimeInterval) {
        guard let view = view as? Cell else { return }

        self.commonView.isHidden = true
        self.view.backgroundColor = UIColor.clear

        self.bodyView.alpha = 0

        let xScale = view.frame.width / self.bodyView.frame.width

//        self.bodyView.transform = CGAffineTransform(scaleX: xScale, y: 1)
//            .concatenating(CGAffineTransform(translationX: 0, y: -self.bodyView.frame.height))

        let originalFrame = self.bodyView.frame

        self.bodyView.frame.origin = view.frame.origin
//        self.bodyView.frame.height = view.frame.height

        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 8,
            options: .curveEaseInOut,
            animations: {

//                self.bodyView.transform = .identity
                self.bodyView.frame = originalFrame
                self.view.layoutIfNeeded()
                view.styleAsCard(isCard: false)
            }) { _ in
                self.view.backgroundColor = UIColor.white
                self.commonView.isHidden = false

                view.styleAsCard(isCard: true)
            }

        UIView.animate(withDuration: duration / 4, delay: 0, options: .curveEaseOut, animations: {
            self.bodyView.alpha = 1

//            view.styleAsCard(isCard: false)
        }, completion: { _ in

        })
    }

    func dismissingView(_ view: UIView, withDuration duration: TimeInterval) {
        self.commonView.isHidden = true
        self.view.backgroundColor = UIColor.clear

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.bodyView.alpha = 0
            self.bodyView.transform = CGAffineTransform(translationX: 0, y: self.bodyView.frame.maxY)
        }, completion: { _ in
            self.bodyView.transform = .identity
            self.bodyView.alpha = 1
            self.view.backgroundColor = UIColor.white
            self.commonView.isHidden = false
        })
    }
}
