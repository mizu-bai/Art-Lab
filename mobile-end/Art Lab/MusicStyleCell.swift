//
//  MusicStyleCell.swift
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

import UIKit

class MusicStyleCell: UITableViewCell {
    // MARK: - Controls
    @IBOutlet weak var musicianImageView: UIImageView!
    @IBOutlet weak var musicianLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!

    // MARK: - Awake From Nib
    override func awakeFromNib() {
        // musician image view
        musicianImageView?.contentMode = .scaleAspectFill
        musicianImageView?.clipsToBounds = true
        musicianImageView?.layer.cornerRadius = 10
        // layer
        backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 5
        layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Play Button
    @IBAction func playButton(_ sender: UIButton) {

    }
}
