//
//  ProfileView.swift
//  ProjectSense
//
//  Created by Andriy on 10/20/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit
import AVFoundation

enum SortDirection: Int {
	case up = 0
	case down
	
	func getRowCount(profile: UserProfile?) -> [Int] {
		let imgCount: Int = (profile != nil ? profile!.imageCount() : 0)
		let videoCount: Int = (profile!.videoURL == nil ? 0 : 1)
		if self == .up {
			return [videoCount, imgCount]
		}
		
		return [imgCount, videoCount]
	}
	
	func getImageSection() -> Int {
		if self == .up {
			return 1
		}
		
		return 0
	}
	
	mutating func changeDirect() -> String {
		if self == .up {
			self = .down
			return "topImage"
		}
		
		self = .up
		return "topVideo"
	}
}


enum SoundMute: Int {
	case on = 0
	case off
	
	mutating func changeMute(avPlayer: AVPlayer) -> String {
		if self == .on {
			self = .off
			avPlayer.isMuted = false
			return "volumeOff"
		}
		
		self = .on
		avPlayer.isMuted = true
		return "volumeOn"
	}
}


class ProfileView : UIView {
    let profileCategoryContentCount: [Int] = [2, 2, 3, 1]
    let profileCategoryName:[String] = ["Physical", "Cultural", "Professional", "Personal"]
    let profileCategoryContentName:[[String]] = [["Age", "Height"],
                                                 ["Ethnicity", "Religion"],
                                                 ["Occupation", "Employer", "Education"],
                                                 ["About You"]]
    var profileCategoryContentValue:[[String]] = [["", ""],
                                                  ["", ""],
                                                  ["", "", ""],
                                                  [""]]
    
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var ageCityLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var employerLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var bottomContainerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageTableView: UITableView!
    @IBOutlet weak var profileTableView: UITableView!
	
	@IBOutlet weak var btnSortDirection: UIButton!
	@IBOutlet weak var btnMute: UIButton!
    
    var flipState: Int = 1
    var profile: UserProfile? = nil
	var sortDirection: SortDirection = .down
	var soundMute: SoundMute = .on
	
	var videoPlayer: AVPlayer?
	
	
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	deinit {
		print("deinit")
		NotificationCenter.default.removeObserver(self)
	}
    
    class func profileView(frame: CGRect) -> ProfileView? {
        var profileView: ProfileView? = nil;
        
        let items = Bundle.main.loadNibNamed("ProfileView", owner: nil, options: nil)
        if items!.count > 0 {
            profileView = items?[0] as! ProfileView?
            profileView?.frame = frame
        }
        
        return profileView;
    }
    
    // MARK: - Setup View
    func setupView() {
        self.clipsToBounds = true
        
        self.profileContainerView.layer.borderColor = UIColor.init(hex: 0x875ABF).cgColor
        self.profileContainerView.layer.borderWidth = 2
        self.profileContainerView.layer.cornerRadius = 10
        
        self.profileImageTableView.dataSource = self
        self.profileImageTableView.delegate = self
        self.profileImageTableView.register(UINib.init(nibName: "ProfileImageTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileImageTableViewCell.ID)
		self.profileImageTableView.register(UINib.init(nibName: "ProfileVideoTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileVideoTableViewCell.ID)

        self.profileTableView.dataSource = self
        self.profileTableView.delegate = self
        self.profileTableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileTableViewCell.ID)
        
        self.flipState = 1
        self.frontView.isHidden = false
        self.backView.isHidden = true
        
        self.layer.borderColor = UIColor.init(hex: 0x875ABF).cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
    }
    
    
    // MARK: - Interface
    func flipView() {
        if self.flipState == 0 {
            return
        }
        
        let fromView = (self.flipState == 1) ? self.frontView : self.backView
        let toView = (self.flipState == 1) ? self.backView : self.frontView
        
        self.isUserInteractionEnabled = false
        self.flipState = 0
        UIView.transition(from: fromView!,
                          to: toView!,
                          duration: 1.0,
                          options: [UIViewAnimationOptions.transitionFlipFromLeft, UIViewAnimationOptions.showHideTransitionViews]) { (finished: Bool) in
                            fromView!.isHidden = true
                            toView!.isHidden = false
                            self.flipState = (toView == self.frontView) ?  1 : 2
                            self.isUserInteractionEnabled = true
        }
    }
    
    func setUserProfile(_ profile: UserProfile?) {
        self.profile = profile
        
        self.ageCityLabel.text = String.init(format: "%d, %@", self.profile!.age, self.profile!.city!)
        self.occupationLabel.text = self.profile!.occupation!
        self.employerLabel.text = self.profile!.employer!
        self.educationLabel.text = self.profile!.education!

        self.profileCategoryContentValue[0][0] = String.init(format: "%d", self.profile!.age)
        self.profileCategoryContentValue[0][1] = String.init(format: "%d'%d\"", self.profile!.height / 10, self.profile!.height % 10 )
        self.profileCategoryContentValue[1][0] = self.profile!.ethnicityName()
        self.profileCategoryContentValue[1][1] = self.profile!.religionName()
        self.profileCategoryContentValue[2][0] = self.profile!.occupation!
        self.profileCategoryContentValue[2][1] = self.profile!.employer!
        self.profileCategoryContentValue[2][2] = self.profile!.education!
        self.profileCategoryContentValue[3][0] = self.profile!.about!
		
		videoPlayer = AVPlayer(url: (self.profile?.videoURL)!)
		NotificationCenter.default.addObserver(self, selector: #selector(onFinishedPlayer), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
		
        self.profileImageTableView.reloadData()
        self.profileTableView.reloadData()
    }
	
	// MARK: - Button actions
	@IBAction func onSortDirection(_ sender: Any) {
		let imageName: String = self.sortDirection.changeDirect()
		self.btnSortDirection.setImage(UIImage(named: imageName), for: .normal)
		
		self.profileImageTableView.reloadData()
	}
	
	@IBAction func onMute(_ sender: Any) {
		let imageName: String = self.soundMute.changeMute(avPlayer: self.videoPlayer!)
		self.btnMute.setImage(UIImage(named: imageName), for: .normal)
	}
}

// MARK: - AVPlayer observer
extension ProfileView {
	func onFinishedPlayer() {
		print("finished playing video")
		videoPlayer?.pause()
		videoPlayer?.seek(to: CMTime(value: 0, timescale: 1000))
		videoPlayer?.play()
	}
}

// MARK: - TableView DataSource & Delegate
extension ProfileView : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.profileImageTableView {
			var counts : [Int] = self.sortDirection.getRowCount(profile: self.profile)
			return counts[section]
            
        } else if tableView == self.profileTableView {
            return self.profileCategoryContentCount.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.profileImageTableView {
			let imgCellSection = self.sortDirection.getImageSection()
			
			if indexPath.section == imgCellSection {
				let profileImageCell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.ID) as! ProfileImageTableViewCell?
				profileImageCell?.thumbImageView.image = self.profile?.image(index: indexPath.row)
				
				return profileImageCell!
				
			} else {
				let profileVideoCell = tableView.dequeueReusableCell(withIdentifier: ProfileVideoTableViewCell.ID) as! ProfileVideoTableViewCell?
				profileVideoCell?.setVideo(avPlayer: self.videoPlayer)
				
				return profileVideoCell!
			}
        } else if tableView == self.profileTableView {
            let profileCell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.ID) as! ProfileTableViewCell?
            let index = indexPath.row
            let contentCount = self.profileCategoryContentCount[index]
            
            profileCell?.setCategoryName(self.profileCategoryName[index])
            profileCell?.setContentCount(contentCount)
            for i in 0 ..< contentCount {
                profileCell?.setCategoryContent(title: self.profileCategoryContentName[index][i], value: self.profileCategoryContentValue[index][i], index: i)
            }
            
            return profileCell!
        }
        
        return UITableViewCell.init()
    }
}

extension ProfileView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.profileImageTableView {
            return tableView.bounds.width
        } else if tableView == self.profileTableView {
            return ProfileTableViewCell.cellHeight(count: self.profileCategoryContentCount[indexPath.row])
        }
        
        return 0
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView != self.profileImageTableView {
            return
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.bottomContainerViewBottomConstraint.constant = -160
                        self.layoutIfNeeded()
        }) { (finished: Bool) in
            
        }
        print("1")
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.profileImageTableView {
            return
        }
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.bottomContainerViewBottomConstraint.constant = 0
                        self.layoutIfNeeded()
        }) { (finished: Bool) in
            
        }
        print("2")
    }
}
