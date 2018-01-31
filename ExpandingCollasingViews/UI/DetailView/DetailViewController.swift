import UIKit

class DetailViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var bodyView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func transition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        duration: TimeInterval,
        options: UIViewAnimationOptions = [],
        animations: (() -> Void)?,
        completion: ((Bool) -> Void)? = nil)
    {
        print("test")
    }
}

extension DetailViewController: Animatable {
    var containerView: UIView? {
        return self.view
    }
    
    var childView: UIView? {
        return self.commonView
    }

    func willPresent(withDuration: TimeInterval) {
        self.commonView.isHidden = true
        self.view.backgroundColor = UIColor.clear

        self.bodyView.alpha = 0
        self.bodyView.transform = CGAffineTransform(translationX: 0, y: self.bodyView.frame.maxY)
        UIView.animate(withDuration: withDuration, animations: {
            self.bodyView.alpha = 1
            self.bodyView.transform = .identity
        }, completion: { _ in
            self.view.backgroundColor = UIColor.white
            self.commonView.isHidden = false
        })
    }

    func willDismiss(withDuration: TimeInterval) {
        self.commonView.isHidden = true
        self.view.backgroundColor = UIColor.clear

        UIView.animate(withDuration: withDuration, animations: {
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
