//
//  videoPageTableViewCell.swift
//  projekMMSLec
//
//  Created by prk on 21/12/24.
//

import UIKit

protocol VideoPageTableViewCellDelegate: AnyObject {
    func didTapPlayButton(for cell: videoPageTableViewCell)
}

class videoPageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!

    weak var delegate: VideoPageTableViewCellDelegate?

    @IBAction func playButtonTapped(_ sender: Any) {
        delegate?.didTapPlayButton(for: self)
    }


    func configure(with title: String, image: UIImage, duration: String) {
        titleLabel.text = title
        imageLabel.image = image
        durationLabel.text = duration
    }
}
