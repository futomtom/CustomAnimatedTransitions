import UIKit

class Cell: UICollectionViewCell, NibReusable {

    @IBOutlet fileprivate weak var shadowView: UIView!
    @IBOutlet fileprivate weak var commonView: CommonView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Add a shadow
        self.shadowView.layer.shadowRadius = 8
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.shadowView.layer.shadowOpacity = 0.25
        self.shadowView.layer.masksToBounds = false

        // Round the corners
        self.commonView.layer.cornerRadius = 10
        self.commonView.layer.masksToBounds = true
    }
}
