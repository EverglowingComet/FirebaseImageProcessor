//
//  UserProfile.swift
//  SwipeDemo
//
//  Created by Andriy on 10/19/16.
//  Copyright © 2016 Andriy. All rights reserved.
//

import UIKit
import AVFoundation

class UserProfile : NSObject {
    var name: String?
    var age: Int
    var height: Int
    var city: String?
    var occupation: String?
    var employer: String?
    var education: String?
    var about: String?
    var ethnicity: Int
    var religion: Int
    var images: [UIImage]
	var videoURL: URL?
    
    override init() {
        self.name = "UnKnown"
        self.age = 26
        self.height = 58
        self.images = []
        self.ethnicity = 0
        self.religion = 0
		
        super.init()
    }
    
    // MARK: - Images
    func imageCount() -> Int {
        return self.images.count
    }
    
    func addImage(image: UIImage?) {
        if image != nil {
            self.images.append(image!)
        }
    }
    
    func image(index: Int) -> UIImage? {
        if index < 0 || index >= self.imageCount() {
            return nil
        }
        
        return images[index]
    }
    
    func ethnicityName() -> String {
        return "Caucasian"
    }
    
    func religionName() -> String {
        return "Spiritual but not religious"
    }
    
}
