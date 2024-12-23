import UIKit

class itemCellHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageLbl: UIImageView!
    
    @IBOutlet weak var backgorundColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Ensure background view is behind other elements
        backgorundColor.layer.zPosition = -1
    }
    
    func configureCell(withTitle title: String, andImage image: UIImage) {
        titleLbl.text = title
        imageLbl.image = image
    }
    
    func setBackgroundColorOrImage(_ color: UIColor?) {
        if let backgroundColor = color {
            backgorundColor.backgroundColor = backgroundColor
        } else {
            backgorundColor.backgroundColor = UIColor.systemBlue
        }
    }
}
