import UIKit

class CommonView: UIView, NibOwnerLoadable {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }
}
