//
//  ViewController.swift
//  ExpandingCollasingViews
//
//  Created by John DeLong on 10/11/17.
//  Copyright © 2017 MichiganLabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var card: CommonView!

//    var destinationView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.5
        card.layer.shadowOffset = CGSize(width: 0, height: 5)
        card.layer.shadowRadius = 5

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        card.addGestureRecognizer(tap)

//        self.destinationView = card
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let vc = ExpandedViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: PushAndPopable {
    var animatableView: UIView? {
        return self.card
    }
}
