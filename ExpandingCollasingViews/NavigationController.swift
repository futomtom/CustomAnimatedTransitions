import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return PopInAndOutAnimator(
            operation: operation,
            andDuration: 1,
            animationType: .spring(dampingRatio: 0.7, velocity: 8, options: .curveEaseOut)
        )
    }
}
