//
//  ProfileViewController.swift
//  ProjectSense
//
//  Created by Andriy on 10/20/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit
import Koloda
import AVFoundation

class ProfileViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    
    var userProfiles: [UserProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.init(hex: 0x895EC0)
        self.navigationController?.title = "Sense"
        
        for i in 0 ..< 20 {
            let userProfile = UserProfile.init()
            
            userProfile.age = 20 + i
            userProfile.height = 50 + i
            userProfile.city = String.init(format: "City %d", i)
            userProfile.occupation = String.init(format: "Consultant %d", i)
            userProfile.employer = String.init(format: "McKinsey & Company %d", i)
            userProfile.education = String.init(format: "University of Pennsylvania %d", i)
            userProfile.about = String.init(format: "Photographer, dancer, and singer %d", i)
            userProfile.name = String.init(format: "Name %d", i)
			
			if true { // read video from resource for testing mode
				let path = Bundle.main.path(forResource: "sample", ofType: "MOV")
				userProfile.videoURL = URL(fileURLWithPath: path!)
			} else { // firebase video url
				
			}
            
            let imageCount = 3 + i % 3
            for _ in 0 ..< imageCount {
                userProfile.addImage(image: UIImage.init(named: "user_profile_image"))
            }
            
            self.userProfiles.append(userProfile)
        }
        self.kolodaView.dataSource = self
        self.kolodaView.delegate = self
        self.kolodaView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.kolodaView.reloadData()
    }
    
    @IBAction func OnFlipProfileView(_ sender: AnyObject) {
        let profileView = self.kolodaView.viewForCard(at: self.kolodaView.currentCardIndex) as! ProfileView?
        if profileView != nil {
            profileView!.flipView()
        }
    }
}

//MARK: - KolodaViewDataSource
extension ProfileViewController: KolodaViewDataSource, KolodaViewDelegate {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.userProfiles.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let profileView = ProfileView.profileView(frame: koloda.bounds) as ProfileView?
        profileView!.setupView()
        profileView!.setUserProfile(self.userProfiles[index])
        
        return profileView!
    }
}
