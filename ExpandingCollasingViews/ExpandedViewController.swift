//
//  ExpandedViewController.swift
//  ExpandingCollasingViews
//
//  Created by John DeLong on 10/11/17.
//  Copyright © 2017 MichiganLabs. All rights reserved.
//

import Foundation
import UIKit

class ExpandedViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var commonView: CommonView!
    @IBOutlet weak var detailView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.detailView.alpha = 0
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

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        self.detailView.alpha = 0
//        self.detailView.transform = CGAffineTransform(translationX: 0, y: self.detailView.frame.maxY)
//        coordinator.animate(
//            alongsideTransition: { _ in
//                self.detailView.alpha = 1
//                self.detailView.transform = .identity
//            }, completion: { _ in
//                print("animation complete")
//            }
//        )
//    }
}

extension ExpandedViewController: Animatable {
    var containerView: UIView? {
        return self.view
    }
    
    var childView: UIView? {
        return self.commonView
    }
}
