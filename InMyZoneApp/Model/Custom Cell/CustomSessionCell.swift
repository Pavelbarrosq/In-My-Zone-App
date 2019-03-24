//
//  CustomSessionCell.swift
//  InMyZoneApp
//
//  Created by Pavel Barros Quintanilla on 2019-03-24.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import UIKit

class CustomSessionCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var recordedAudioButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
