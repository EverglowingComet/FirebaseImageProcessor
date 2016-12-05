//
//  ProfileVideoTableViewCell.swift
//  ProjectSense
//
//  Created by Com on 01/12/2016.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileVideoTableViewCell: UITableViewCell {
	static let ID = "ProfileVideoTableViewCellID"
	
	@IBOutlet weak var playerView: UIView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	var playerLayer: AVPlayerLayer?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func layoutSubviews() {
		playerView.frame = CGRect(x: 10, y: 10, width: self.frame.size.width - 20, height: self.frame.size.height - 20)
		playerLayer?.frame = self.playerView.bounds
		
		activity.frame = CGRect(x: (self.frame.size.width - activity.frame.size.width)/2, y: (self.frame.size.height - activity.frame.size.height)/2,
		                        width: activity.frame.size.width, height: activity.frame.size.height)
	}
	
	open func showProgress(bShow: Bool) {
		if bShow == true {
			activity.isHidden = false
			activity.startAnimating()
		} else {
			activity.stopAnimating()
			activity.isHidden = true
		}
	}
	
	open func setVideo(_ avPlayer: AVPlayer?) {
		self.playerView.backgroundColor = UIColor.lightGray
		avPlayer?.pause()
		
		if playerLayer != nil {
			playerLayer?.removeFromSuperlayer()
			playerLayer = nil
		}
		
		playerLayer = AVPlayerLayer(player: avPlayer)
		playerLayer?.frame = self.playerView.bounds
		print("content view: \(self.contentView.bounds)")
		self.playerView.layer.addSublayer(playerLayer!)
		
		avPlayer?.play()
	}
}
