import UIKit

class DetailViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    @IBOutlet weak var closeButton: UIButton!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func asCard(_ value: Bool) {
        if value {
            // Round the corners
            self.maskView.layer.cornerRadius = 10
        } else {
            // Round the corners
            self.maskView.layer.cornerRadius = 0
        }
    }
}

extension DetailViewController: Animatable {
    var containerView: UIView? {
        return self.view
    }
    
    var childView: UIView? {
        return self.commonView
    }

    func dismissingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    ) {
        self.topConstraint.isActive = true

        // If the top card is completely off screen, we move it to be JUST offscreen.
        // This makes for a cleaner looking animation.
        if scrollView.contentOffset.y > commonView.frame.height {
            self.topConstraint.constant = -commonView.frame.height
            self.view.layoutIfNeeded()

            // Still want to animate the common view getting pinned to the top of the view
            self.topConstraint.constant = 0
        }

        self.heightConstraint.constant = toFrame.height
        sizeAnimator.addAnimations {
            self.closeButton.alpha = 0
            self.view.layoutIfNeeded()
        }

        positionAnimator.addAnimations {
            self.asCard(true)
        }
    }

    func presentingView(
        sizeAnimator: UIViewPropertyAnimator,
        positionAnimator: UIViewPropertyAnimator,
        fromFrame: CGRect,
        toFrame: CGRect
    ) {
        self.heightConstraint.constant = fromFrame.height
        self.closeButton.alpha = 1

        self.asCard(true)

        self.view.layoutIfNeeded()

        self.heightConstraint.constant = 500
        sizeAnimator.addAnimations {
            self.view.layoutIfNeeded()
        }

        positionAnimator.addAnimations {
            self.asCard(false)
        }
    }
}
