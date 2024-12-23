import UIKit

class PsychiatristTableViewCell: UITableViewCell {
    
    // IBOutlet untuk komponen UI di dalam cell
//    @IBOutlet weak var psychiatristImageView: UIImageView!
//    @IBOutlet weak var nameLbl: UILabel!
//    @IBOutlet weak var ratingLbl: UILabel!
//    @IBOutlet weak var typeLbl: UILabel!
    
    
    
    
    @IBOutlet weak var psychiatristImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    // Configure cell dengan data yang diterima
    func configure(image: UIImage?, name: String, type: String, rating: Double) {
        // Menampilkan gambar, jika tidak ada gambar maka pakai gambar default
        psychiatristImageView.image = image ?? UIImage(named: "defaultImage") // Pastikan ada gambar default dalam assets
        nameLbl.text = name
        typeLbl.text = type
        ratingLbl.text = "Rating: \(rating)"
    }
}
