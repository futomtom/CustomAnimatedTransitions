import UIKit

class Cell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var commonView: CommonView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.shadowView.layer.masksToBounds = false
        self.commonView.layer.masksToBounds = true

        self.styleAsCard(isCard: true)
    }

    func styleAsCard(isCard: Bool) {


        if isCard {
            // Add a shadow
            self.shadowView.layer.shadowRadius = 16
            self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.shadowView.layer.shadowOpacity = 0.25

            // Round the corners
            self.commonView.layer.cornerRadius = 20
        } else {
            // Add a shadow
            self.shadowView.layer.shadowRadius = 0
            self.shadowView.layer.shadowOffset = .zero
            self.shadowView.layer.shadowOpacity = 0

            // Round the corners
            self.commonView.layer.cornerRadius = 0
        }
    }
}
