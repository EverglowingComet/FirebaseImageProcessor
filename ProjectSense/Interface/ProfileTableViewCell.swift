//
//  ProfileTableViewCell.swift
//  ProjectSense
//
//  Created by Andriy on 10/20/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let ID = "ProfileTableViewCellID"
    static let ContentHeight = 50
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentTitleLabel1: UILabel!
    @IBOutlet weak var contentLabel1: UILabel!
    @IBOutlet weak var contentTitleLabel2: UILabel!
    @IBOutlet weak var contentLabel2: UILabel!
    @IBOutlet weak var contentTitleLabel3: UILabel!
    @IBOutlet weak var contentLabel3: UILabel!

    @IBOutlet weak var contentView2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView3HeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.categoryLabel.transform = CGAffineTransform.init(rotationAngle:CGFloat(-M_PI / 2.0))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellHeight(_ count: Int) -> CGFloat {
        return CGFloat(20 + ContentHeight * count + 20 + 1)
    }
    
    func setContentCount(_ count: Int) {
        self.contentTitleLabel1.text = ""
        self.contentLabel1.text = ""
        self.contentTitleLabel2.text = ""
        self.contentLabel2.text = ""
        self.contentTitleLabel3.text = ""
        self.contentLabel3.text = ""
        
        switch count {
        case 3:
            self.contentTitleLabel1.isHidden = false
            self.contentLabel1.isHidden = false
            self.contentTitleLabel2.isHidden = false
            self.contentLabel2.isHidden = false
            self.contentTitleLabel3.isHidden = false
            self.contentLabel3.isHidden = false
            
            self.contentView2HeightConstraint.constant = CGFloat(ProfileTableViewCell.ContentHeight)
            self.contentView3HeightConstraint.constant = CGFloat(ProfileTableViewCell.ContentHeight)
            break
        case 2:
            self.contentTitleLabel1.isHidden = false
            self.contentLabel1.isHidden = false
            self.contentTitleLabel2.isHidden = false
            self.contentLabel2.isHidden = false
            self.contentTitleLabel3.isHidden = true
            self.contentLabel3.isHidden = true
            
            self.contentView2HeightConstraint.constant = CGFloat(ProfileTableViewCell.ContentHeight)
            self.contentView3HeightConstraint.constant = CGFloat(0)
            break
        default:
            self.contentTitleLabel1.isHidden = false
            self.contentLabel1.isHidden = false
            self.contentTitleLabel2.isHidden = true
            self.contentLabel2.isHidden = true
            self.contentTitleLabel3.isHidden = true
            self.contentLabel3.isHidden = true
            
            self.contentView2HeightConstraint.constant = CGFloat(0)
            self.contentView3HeightConstraint.constant = CGFloat(0)
            break
        }
        self.layoutIfNeeded()
    }
    
    func setCategoryName(_ name: String) {
        self.categoryLabel.text = name
    }
    
    func setCategoryContent(_ title: String, value: String, index: Int) {
        var contentTitleLabel: UILabel!
        var contentLabel: UILabel!
        
        switch index {
        case 2:
            contentTitleLabel = self.contentTitleLabel3
            contentLabel = self.contentLabel3
            break
        case 1:
            contentTitleLabel = self.contentTitleLabel2
            contentLabel = self.contentLabel2
            break
        default:
            contentTitleLabel = self.contentTitleLabel1
            contentLabel = self.contentLabel1
            break
        }
        
        contentTitleLabel.text = title
        contentLabel.text = value
    }
}
