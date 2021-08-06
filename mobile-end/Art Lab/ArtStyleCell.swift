//
//  ArtStyleCell.swift
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

import UIKit

class ArtStyleCell: UICollectionViewCell {
    // MARK: - Controls
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!

    // MARK: - Init
    override func awakeFromNib() {
        // layer
        layer.backgroundColor = UIColor.systemPink.withAlphaComponent({ (min: Double, max: Double) -> CGFloat in
            let randomNum = Double(arc4random()) / Double(UInt32.max)
            return CGFloat(randomNum * (max - min + 1) + min)
        }(0.2, 0.8)).cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 10
        layer.borderColor = UIColor.white.cgColor

        // art image view
        artImageView.layer.cornerRadius = 20
        artImageView.contentMode = .scaleAspectFill
        artImageView.clipsToBounds = true
        // text color
        artistLabel.textColor = UIColor.blue
    }
}
