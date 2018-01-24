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
}

extension ExpandedViewController: PushAndPopable {
    var animatableView: UIView? {
        return self.commonView
    }
}
