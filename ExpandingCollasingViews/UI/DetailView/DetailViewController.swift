import UIKit

class DetailViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var bodyConstraint: NSLayoutConstraint!

    
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

    func presentingView(_ view: UIView, withDuration duration: TimeInterval) {
//        guard let view = view as? Cell else { return }

        self.view.layer.cornerRadius = 20
//        self.bottomConstraint.isActive = false
        UIView.animate(withDuration: duration / 4, animations: {
            self.view.layer.cornerRadius = 0
//            self.view.layoutIfNeeded()
        }, completion: { _ in
            print("finished")
        })
    }

    func dismissingView(_ view: UIView, withDuration duration: TimeInterval) {
        guard let view = view as? Cell else { return }


//        self.bottomConstraint.isActive = true
//        self.bodyConstraint.isActive = true

        UIView.animate(withDuration: duration/4, animations: {
            self.view.layer.cornerRadius = 20
//            self.view.layoutIfNeeded()
//            view.alpha = 1
        }, completion: { _ in
//            self.view.layer.cornerRadius = 0
            print("finished")
//            self.bottomConstraint.isActive = false
        })
    }
}
