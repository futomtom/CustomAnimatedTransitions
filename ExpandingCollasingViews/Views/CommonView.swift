//
//  CommonView.swift
//  ExpandingCollasingViews
//
//  Created by John DeLong on 10/11/17.
//  Copyright © 2017 MichiganLabs. All rights reserved.
//

import Foundation
import UIKit

class CommonView: UIView, NibOwnerLoadable {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
