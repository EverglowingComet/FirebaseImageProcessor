//
//  ProfileImageTableViewCell.swift
//  ProjectSense
//
//  Created by Andriy on 10/20/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {
    static let ID = "ProfileImageTableViewCellID"
    
    @IBOutlet weak var thumbImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
