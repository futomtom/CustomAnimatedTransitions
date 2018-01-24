//
//  NavigationController.swift
//  ExpandingCollasingViews
//
//  Created by John DeLong on 10/11/17.
//  Copyright © 2017 MichiganLabs. All rights reserved.
//

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
        return PopInAndOutAnimator(operation: operation, andDuration: 0.4)
    }
}
