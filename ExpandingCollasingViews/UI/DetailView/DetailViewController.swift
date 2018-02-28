import UIKit

class DetailViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func closePressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: Animatable {
    var containerView: UIView? {
        return self.view
    }
    
    var childView: UIView? {
        return self.commonView
    }

    func positioning(with animator: UIViewPropertyAnimator, fromPoint: CGPoint, toPoint: CGPoint) {
        animator.addAnimations {
            // Add a shadow
            //            self.shadowView.layer.shadowRadius = 16
            //            self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
            //            self.shadowView.layer.shadowOpacity = 0.25
            //            self.shadowView.layer.masksToBounds = false

            // Round the corners
            self.view.layer.cornerRadius = 20
            self.view.layer.masksToBounds = true
        }
    }

    func resizing(with animator: UIViewPropertyAnimator, fromFrame: CGRect, toFrame: CGRect) {
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
        animator.addAnimations {
            self.view.layoutIfNeeded()
        }
    }
}
